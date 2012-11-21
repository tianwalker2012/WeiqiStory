//
//  EZChessBoardWrapper.m
//  WeiqiStory
//
//  Created by xietian on 12-11-21.
//
//

#import "EZChessBoardWrapper.h"
#import "EZChessBoard.h"

@implementation EZChessBoardWrapper

- (id) initWithBoard:(EZChessBoard*) board
{
    self = [super init];
    
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

@end
