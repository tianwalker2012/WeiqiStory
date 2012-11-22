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

static CCSprite* bubble;
static CCSprite* broken;

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
    //EZDEBUG(@"Accept touch");
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:BubbleTouchPriority swallowsTouches:NO];
}

- (void) onExit
{
    [super onExit];
    //EZDEBUG(@"Quit for touch");
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
    //EZDEBUG(@"Bubble clicked %@, boundingBox:%@", NSStringFromCGPoint(localPt),NSStringFromCGRect(boundingBox));

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

+ (void) generatedBubble:(CCNode*)node z:(NSInteger)zOrder
{
    if(bubble == nil){
        bubble = [CCSprite spriteWithFile:@"bubble-pad.png"];
        broken = [CCSprite spriteWithFile:@"bubble-broken-pad.png"];
    }
    //EZDEBUG(@"Generate bubble, size:%@", NSStringFromCGSize(bubble.boundingBox.size));
    CGFloat xStartPos = arc4random()%768;
    CGFloat xEndPos = arc4random()%768;
    CGFloat yEndPos = 1048;
    CGFloat addDuration = arc4random()%5;
    
    CGFloat duration = 5 + addDuration;
    EZBubble* randBubble = [[EZBubble alloc] initWithBubble:[CCSprite spriteWithSpriteFrame:bubble.displayFrame] broken:[CCSprite spriteWithSpriteFrame:broken.displayFrame]];
    //CCNode* randBubble = [[EZBubble2 alloc] init];
    randBubble.contentSize = bubble.contentSize;
    CGFloat finalScale =0.4 + 0.15 * (arc4random() % 4);
    
    CGFloat finalAngle = 90 * (arc4random() % 5);
    
    randBubble.scale = 0.5;
    randBubble.position = ccp(xStartPos, 0);
    [node addChild:randBubble z:zOrder];
    id animate =  [CCSpawn actions:[CCMoveTo actionWithDuration:duration position:ccp(xEndPos, yEndPos)],[CCRotateBy actionWithDuration:duration angle:finalAngle], [CCScaleTo actionWithDuration:duration scale:finalScale], nil];
    id action = [CCSequence actions:animate,[CCCallBlock actionWithBlock:^(){
        [randBubble removeFromParentAndCleanup:YES];
    }], nil];
    [randBubble runAction:action];
}

@end
