//
//  EZVoiceRecorder.m
//  SpeakHere
//
//  Created by xietian on 12-9-17.
//
//

#import "EZVoiceRecorder.h"
#import "EZFileUtil.h"
#import "EZConstants.h"

@interface EZVoiceRecorder(){
    AVAudioRecorder* audioRecorder;
    AVAudioPlayer* audioPlayer;
    //NSString* recordedFile;
}

- (NSURL*)fileToURL:(NSString*)fileName;

@end



@implementation EZVoiceRecorder


- (id) initWithFile:(NSString*)fileName
{
    self = [super init];
    if(self){
        
        NSDictionary *recordSettings = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16],
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:44100.0],
                                        AVSampleRateKey,
                                        nil];
        
        NSError *error = nil;
        _recordedFile = fileName;
        NSURL* soundFileURL = [EZFileUtil fileToURL:fileName dirType:NSDocumentDirectory];
        
        audioRecorder = [[AVAudioRecorder alloc]
                         initWithURL:soundFileURL
                         settings:recordSettings
                         error:&error];
        
        if (error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
            
        } else {
            [audioRecorder prepareToRecord];
        }
    }
    
    return self;
}

//Hide the detail within us.
- (NSURL*) getRecordedFileURL
{
    return [EZFileUtil fileToURL:_recordedFile dirType:NSDocumentDirectory];
}

- (NSString*) getRecordedFile
{
    return _recordedFile;
}

- (void) stop
{
    if(audioRecorder.isRecording){
        [audioRecorder stop];
    }
}

- (void) start
{
    if(!audioRecorder.isRecording){
        BOOL recordResult = [audioRecorder record];
        EZDEBUG(@"RecordedResult %@", recordResult?@"True":@"Failure");
    }else{
        NSLog(@"Warning: are recording");
    }
}

- (BOOL) isRecording
{
    return audioRecorder.isRecording;
}

- (void) play:(NSString *)fileName
{
    if (!audioRecorder.recording)
    {
            
        NSError *error;
        
        if(fileName == nil){
            fileName = _recordedFile;
        }
        
        
        audioPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:[self fileToURL:fileName]
                       error:&error];
        
        
        
        audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
            [audioPlayer play];
    }
}


//Following are delegation method for the avPlayer delegate.
-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Complete playing");
    
}
-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}
-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
    NSLog(@"Recording finished successfully");
}
-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}


@end

