//
//  EZEpisodeUploader.m
//  WeiqiStory
//
//  Created by xietian on 12-10-19.
//
//

#import "EZEpisodeUploader.h"
#import "EZUploader.h"
#import "EZEpisodeVO.h"
#import "SBJson.h"
#import "EZEpisodeFile.h"
#import "EZExtender.h"
#import "EZAudioFile.h"

@implementation EZEpisodeUploader


//Just implement the most stupid and straight forward version.
//What make me hesitate is that in the asynchronized environment, what I might do to collect the result of the asynchronized operation.
//Man, I am run in the same network,
//As long as the network setting is right, nothing wrong would happen.
//All I need to care is that any negative information regarding the upload.
//Ya, differentiate what could be simplified. Focus on your efforts on something really matter to your customer. 
- (void) uploadEpisodes:(NSArray*)episodes completBlk:(EZOperationBlock)block
{
    NSString* uniqueFileName = [NSString stringWithFormat:@"episode%@.ar", [[NSDate date] stringWithFormat:@"yyyyMMddHHmmss"]];
    [self updateList:uniqueFileName];
    //NSString* jsonStr = episodes.JSONRepresentation;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:episodes];
    EZUploader* uploader = [[EZUploader alloc] initWithURL:[NSURL URLWithString:_uploadBaseURL]];
    EZDEBUG(@"Begin upload to URL:%@", _uploadBaseURL);
    [uploader uploadToServer:data fileName:uniqueFileName contentType:@"episode" resultBlock:^(id sender){
        EZDEBUG(@"upload episode script success");
    }];
    for(EZEpisodeVO* ep in episodes){
        [self uploadEpisode:ep nextBlk:nil];
    }
}

//What I will do here?
//Upload all the files for this episode.
- (void) uploadEpisode:(EZEpisodeVO*)episode nextBlk:(EZOperationBlock)block
{
    EZDEBUG(@"Start upload audio for:%@", episode.name);
    EZUploader* uploader = [[EZUploader alloc] initWithURL:[NSURL URLWithString:_uploadBaseURL]];
    for(EZAudioFile* file in episode.audioFiles){
        NSURL* fileURL = file.getFileURL;
        [uploader uploadFileURL:fileURL fileName:file.fileName resultBlock:^(id sender){
            EZDEBUG(@"Upload:%@, send detail:%@",fileURL, sender);
        }];
    }
}

- (void) cleanList
{
    EZUploader* uploader = [[EZUploader alloc] initWithURL:[NSURL URLWithString:_uploadBaseURL]];
    uploader.url = [NSURL URLWithString:_uploadBaseURL];
    [uploader uploadToServer:[@"[]" dataUsingEncoding:NSUTF8StringEncoding] fileName:EpisodeListFile contentType:@"list" resultBlock:^(id resp){
        EZDEBUG(@"upload successfully:%@",resp);
    }];
}

- (void) updateList:(NSString*)fileName
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSArray* existed = [self getEpisodeList];
    if(existed){
        [array addObjectsFromArray:existed];
    }
    EZEpisodeFile* spFile = [[EZEpisodeFile alloc] init];
    spFile.fileName = fileName;
    spFile.createTime = [NSDate date];
    [array addObject:[spFile proxyForJson]];
    NSString* jsonStr = array.JSONRepresentation;
    EZDEBUG(@"Will upload:%@ to %@", jsonStr, _uploadBaseURL);
    //NSString* uploadListURL = [NSString stringWithFormat:@"%@/%@", _uploadBaseURL, EpisodeListFile];
    EZUploader* uploader = [[EZUploader alloc] initWithURL:[NSURL URLWithString:_uploadBaseURL]];
    uploader.url = [NSURL URLWithString:_uploadBaseURL];
    [uploader uploadToServer:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] fileName:EpisodeListFile contentType:@"list" resultBlock:^(id resp){
        EZDEBUG(@"upload successfully:%@",resp);
    }];
}

- (NSArray*) getEpisodeList
{
    NSString* listURL = [NSString stringWithFormat:@"%@/%@", _downloadBaseURL, EpisodeListFile];
    NSError* err = nil;
    NSString* fileContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:listURL] encoding:NSUTF8StringEncoding error:&err];
    if(fileContent){
        return fileContent.JSONValue;
    }
    return nil;
}

@end
