//
//  EZChessBoardWrapper.m
//  WeiqiStory
//
//  Created by xietian on 12-11-21.
//
//

#import "EZChessBoardWrapper.h"
#import "EZChessBoard.h"
#import "EZChess2Image.h"

@implementation EZChessBoardWrapper

- (id) initWithBoard:(EZChessBoard*) board
{
    self = [super init];
    board.position = ccp(0, 0);
    board.anchorPoint = ccp(0, 0);
    _board = board;
    _board.touchEnabled = false;
    
    [self addChild:_board];
    return self;
}

- (void) onEnter
{
    [super onEnter];
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:10 swallowsTouches:YES];
}

- (void) onExit
{
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return [_board ccTouchBegan:touch withEvent:event];
}
// touch updates:
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_board ccTouchMoved:touch withEvent:event];
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_board ccTouchEnded:touch withEvent:event];
}


//What's the relationship between visit and draw.
- (void) visit
{
    EZDEBUG(@"Visit get called:%@", [NSThread callStackSymbols]);
    glEnable(GL_SCISSOR_TEST);
    CGRect pixRect = [EZChess2Image rectPointToPix:self.boundingBox];
    
    glScissor(pixRect.origin.x, pixRect.origin.y,  pixRect.size.width, pixRect.size.height);
    
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}

//The possible problem could be that the GL coordinator didn't match the point in the screen.
//Let's test them carefully.
//Let's check the CCSprite code see what's the case with the sprite.
//Why call 2 times, what's the tricks behind it?
//This is very interesting. 
- (void) draw
{
    glEnable(GL_SCISSOR_TEST);
    
    CGRect pixRect = [EZChess2Image rectPointToPix:self.boundingBox];
    
    glScissor(pixRect.origin.x, pixRect.origin.y,  pixRect.size.width, pixRect.size.height);    //if (stop)
    
    [super draw];
}

@end
