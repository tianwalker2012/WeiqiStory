//
//  EZSoundPlayer.h
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EZConstants.h"
//Why do I need this this class
//Because I need the voice playback with the knowledge about when it will be completed.
@interface EZSoundPlayer : NSObject<AVAudioPlayerDelegate>

- (EZSoundPlayer*) initWithFile:(NSString*)fileName completeCall:(EZOperationBlock)blk;

- (EZSoundPlayer*) initWithURL:(NSURL*)url completeCall:(EZOperationBlock)blk;

- (EZSoundPlayer*) initWithFile:(NSString*)fileName inMainBundle:(BOOL)mainBundle completeCall:(void(^)())blk;

//stop play back
- (void) stop;

- (void) setVolume:(CGFloat)volume;

@end
