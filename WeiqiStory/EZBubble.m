//
//  EZBubble.m
//  WeiqiStory
//
//  Created by xietian on 12-11-11.
//
//

#import "EZBubble.h"
#import "EZTouchHelper.h"
#import "EZConstants.h"
#import "EZSoundManager.h"

@implementation EZBubble


- (id) initWithBubble:(CCSprite *)bubble broken:(CCSprite *)broken
{
    self = [super init];
    
    _bubble = bubble;
    _bubble.position = ccp(_bubble.boundingBox.size.width/2, _bubble.boundingBox.size.height/2);
    [self addChild:bubble];
    self.contentSize = _bubble.contentSize;
    _broken = broken;
    _isBroken = false;
    return self;
}


- (void) onEnter
{
    [super onEnter];
    EZDEBUG(@"Accept touch");
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:TouchEventPriority swallowsTouches:YES];
}

- (void) onExit
{
    [super onExit];
    EZDEBUG(@"Quit for touch");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

//FadeIn and FadeOut will need to call this method.
- (void) setOpacity:(CGFloat)opacity
{
    _broken.opacity = opacity;
}
//Only when the touch right in the region of the boundingBox
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGRect boundingBox = self.boundingBox;
    CGPoint localPt = [self.parent locationInSelf:touch];
    EZDEBUG(@"Bubble clicked %@, boundingBox:%@", NSStringFromCGPoint(localPt),
            NSStringFromCGRect(boundingBox));

    if(CGRectContainsPoint(boundingBox, localPt) && !_isBroken){
        EZDEBUG(@"Broken triggered %@, boundingBox:%@", NSStringFromCGPoint(localPt),
                NSStringFromCGRect(boundingBox));
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndBubbleBroken];
        _isBroken = true;
        [self stopAllActions];
        [_bubble removeFromParentAndCleanup:YES];
        _broken.position = ccp(_broken.boundingBox.size.width/2, _broken.boundingBox.size.height/2);
        [self addChild:_broken];
        
        //id swell = [CCScaleTo actionWithDuration:0.05 scale:1.2];
        id fadeOut = [CCFadeOut actionWithDuration:1];
        id cleanAct = [CCCallBlock actionWithBlock:^(){
            [self removeFromParentAndCleanup:YES];
        }];
        id combined = [CCSequence actions:fadeOut, cleanAct, nil];
        [self runAction:combined];
        return true;
    }
    return false;
}

@end
