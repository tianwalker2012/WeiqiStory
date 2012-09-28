//
//  EZSoundAction.h
//  WeiqiStory
//
//  Created by xietian on 12-9-28.
//
//

#import "EZAction.h"

@interface EZSoundAction : EZAction

//I can assign serveral files
@property (strong, nonatomic) NSArray* audioFiles;

@property (assign, nonatomic) NSInteger currentAudio;

@end
