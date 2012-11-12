//
//  EZBubble2.m
//  WeiqiStory
//
//  Created by xietian on 12-11-11.
//
//

#import "EZBubble2.h"
#import "EZConstants.h"

@implementation EZBubble2

- (id) init
{
    self  = [super init];
    return self;
}

/**
- (void) onEnter
{
    EZDEBUG(@"Accept touch");
    //[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:TouchEventPriority swallowsTouches:YES];
}

- (void) onExit
{
    EZDEBUG(@"Quit for touch");
    //[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}
**/

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch clicked");
    return false;
}

@end
