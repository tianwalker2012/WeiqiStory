//
//  EZPlayerStatus.h
//  WeiqiStory
//
//  Created by xietian on 12-9-23.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EZActionPlayer.h"

//All the button status will be maintained by this status.
//Currently it will tightly coupled with the Menu font.
//Will add the decouple refractor later.
@interface EZPlayerStatus : NSObject<EZActionCompleted>

@property (weak, nonatomic) CCMenuItemFont* playButton;

@property (weak, nonatomic) CCMenuItemFont* prevButton;

@property (weak, nonatomic) CCMenuItemFont* replayButton;

@property (weak, nonatomic) CCMenuItemFont* nextButton;

@property (weak, nonatomic) EZActionPlayer* player;

@property (assign, nonatomic) BOOL playing;

- (id) initWithPlay:(id)play prev:(id)prev next:(id)next replay:(id)replay;

//Who will call this method?
//The button for pause and play will call this method
- (void) play;

@end
