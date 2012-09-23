//
//  EZSoundPlayer.m
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import "EZSoundPlayer.h"
#import "EZFileUtil.h"

@interface EZSoundPlayer()
{
    EZOperationBlock block;
    AVAudioPlayer* audioPlayer;
    
}
@end

@implementation EZSoundPlayer

- (EZSoundPlayer*) initWithFile:(NSString*)fileName completeCall:(void(^)())blk
{
    self = [super init];
    NSError *error;
    NSURL* fileURL = [EZFileUtil fileToURL:fileName];
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:fileURL
                   error:&error];
    if(error){
        EZDEBUG(@"Sound load Error:%@",error);
    }
    audioPlayer.delegate = self;
    block = blk;
    [audioPlayer play];
    EZDEBUG(@"start playing:%@, url:%@",fileName,fileURL);
    return self;
}

/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    EZDEBUG(@"Finish playing: %@", flag?@"success":@"fail");
    if(block){
        block();
    }
    
    //block = nil;
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    EZDEBUG(@"Error occurred. Error detail:%@", error);
}

@end
