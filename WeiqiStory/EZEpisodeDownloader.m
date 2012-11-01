//
//  EZEpisodeDownloader.m
//  WeiqiStory
//
//  Created by xietian on 12-10-19.
//
//

#import "EZEpisodeDownloader.h"
#import "EZAudioFile.h"
#import "EZFileUtil.h"
#import "EZExtender.h"
#import "EZThreadPool.h"
#import "EZEpisodeVO.h"
#import "SBJson.h"

@implementation EZEpisodeDownloader


- (id) init
{
    self = [super init];
    _worker = [EZThreadPool createWorkerThread];
    return self;
}

- (void) downloadAccordingToList:(NSURL*)url
{
    NSError* error = nil;
    NSString* jsonStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if(!error){
        NSArray* arr = jsonStr.JSONValue;
        for(NSDictionary* dict in arr){
            NSString* fileName = [dict objectForKey:@"fileName"];
            NSURL* downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", _baseURL, fileName]];
            [self downloadEpisode:downloadURL completeBlock:nil];
        }
    }
}

//This is a asynchronized method.
//It will not block the main thead.
- (void) downloadEpisode:(NSURL*)url completeBlock:(EZOperationBlock)block
{
    [self executeBlockInBackground:^(){
        NSData* episodeData = [NSData dataWithContentsOfURL:url];
        if(episodeData){
            EZDEBUG(@"Successfully download %i from %@", episodeData.length, url);
            NSArray* episodes = [NSKeyedUnarchiver unarchiveObjectWithData:episodeData];
            for(EZEpisodeVO* ep in episodes){
                [self processEpisode:ep];
            }
            
        }else{
            EZDEBUG(@"Failed to download episodes:%@", url);
        }
    
    
    } inThread:_worker];
}

//Process each episode
//Generate the thumbNail, download each files and update the data base accordingly.
- (void) processEpisode:(EZEpisodeVO*)episode
{
    if(episode.thumbNail == nil){
        [episode regenerateThumbNail];
    }
    [self downloadAllAudio:episode.audioFiles completeBlock:nil];
    BOOL completed = true;
    for(EZAudioFile* file in episode.audioFiles){
        //For downloaded files, It could never be in the mainbundle.
        file.inMainBundle = false;
        
        if(!file.downloaded){
            completed = false;
            break;
        }
    }
    episode.completed = completed;
    [episode persist];
    if(episode.completed){
        EZDEBUG(@"Completed download, thumbNail:%@, object:%i", episode.thumbNail, (int)episode);
        [[NSNotificationCenter defaultCenter] postNotificationName:EpisodeDownloadDone object:episode
         ];
        
    }else{
        EZDEBUG(@"Let's retry download later");
    }
}

//Once this audio for this guy is over
//I will use the blocking method here.
//I will store the downloaded file to the document directory
//I will give the list of successful files back.
//I want experiment what if the url not exist and what if the file not exist with the NSData.
//Not necessary, since each file have it's own flag to indicate if it is downloaded or not.
//We are in good shape.
//I could in another thread.
- (void) downloadAllAudio:(NSArray*)files completeBlock:(EZOperationBlock)block
{
    for(EZAudioFile* file in files){
        if(!file.downloaded){
            EZDEBUG(@"Start downloading:%@", file.fileName);
            NSString* combinedURL = [NSString stringWithFormat:@"%@/%@", _baseURL, file.fileName];
            EZDEBUG(@"CombinedURL:%@", combinedURL);
            NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:combinedURL]];
            if(data){
                EZDEBUG(@"Downloaded files length:%i",data.length);
                NSURL* storedURL = [EZFileUtil fileToURL:file.fileName dirType:NSDocumentDirectory];
                [data writeToURL:storedURL atomically:NO];
                //release the memory
                data = nil;
                file.downloaded = true;
            }else{
                EZDEBUG(@"Failed to download from:%@", combinedURL);
            }
        }
    }
    
    if(block){
        block();
    }
    
}

@end
