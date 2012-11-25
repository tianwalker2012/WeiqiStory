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
#import "EZImageView.h"
#import "EZCoreAccessor.h"



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
            NSMutableArray* episodes =[NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:episodeData]];
            _episodeCounts += episodes.count;
            NSInteger count = 0;
            while(episodes.count > 0){
                EZEpisodeVO* ep = [episodes objectAtIndex:0];
                [episodes removeObjectAtIndex:0];
                ep.name = [NSString stringWithFormat:@"%i:%@", count++, ep.name];
                @autoreleasepool {
                    [self processEpisode:ep];
                }
                //Release the object.
                ep = nil;
                //if(count > 20){
                //    break;
                // }
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
    //if(episode.thumbNail == nil){
    //    [episode regenerateThumbNail];
    //}
    UIImage* image = [EZImageView generateSmallBoard:episode.basicPattern];
    NSString* fileName = [EZFileUtil generateFileName:@"smallboard"];
    [EZFileUtil storeImageFile:image file:fileName];
    image = nil;
    episode.thumbNailFile = fileName;
    
    episode.inMainBundle = self.isMainBundle;
    [self downloadAllAudio:episode.audioFiles completeBlock:nil];
    BOOL completed = true;
    
    for(EZAudioFile* file in episode.audioFiles){
        //For downloaded files, It could never be in the mainbundle.
        //Wrong assumption
        //It is possible some file just locate in the bundles
        //file.inMainBundle = self.isMainBundle;
        if(!file.downloaded){
            completed = false;
            break;
        }
    }
    episode.completed = completed;
    
    NSInteger workerID = (int)[NSThread currentThread];
    [self executeBlockInMainThread:^(){
        EZDEBUG(@"worker:%i, main:%i, blockID:%i", workerID, (int)[NSThread mainThread], (int)[NSThread currentThread]);
        [episode persist];
        if(episode.completed){
            //EZDEBUG(@"Completed download, object:%@", episode.name);
            [[NSNotificationCenter defaultCenter] postNotificationName:EpisodeDownloadDone object:nil
             ];
        }else{
            EZDEBUG(@"Failed download %@, Let's retry download later", episode.name);
        }
    }];
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
        if(_isMainBundle){//Keep it as it is.
            file.inMainBundle = true;
            file.downloaded = true;
        }else
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
