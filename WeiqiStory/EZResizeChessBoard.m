//
//  EZResizeChessBoard.m
//  WeiqiStory
//
//  Created by xietian on 12-11-20.
//
//

#import "EZResizeChessBoard.h"
#import "EZTouchHelper.h"
#import "EZConstants.h"
#import "EZCoord.h"
#import "EZImageResources.h"
#import "EZChessman.h"
#import "EZChessMark.h"
#import "EZRegretAction.h"
#import "EZChessPosition.h"
#import "EZBoardStatus.h"

@implementation EZResizeChessBoard

- (id) initWithOrgBoard:(NSString*)orgBoardName orgRect:(CGRect)orgRect largeBoard:(NSString*)largeBoardName largeRect:(CGRect)largeRect
{
    self = [super init];
    _orgBoard = [[EZChessBoard alloc] initWithFile:orgBoardName touchRect:orgRect rows:19 cols:19];
    _orgBoard.touchEnabled = false;
    _orgBoard.anchorPoint = ccp(0, 0);
    _orgBoard.position = ccp(0, 0);
    
    
    _touchZone = _orgBoard.touchRect;
    self.contentSize = _touchZone.size;
    _enlargedBoard = [[EZChessBoard alloc] initWithFile:largeBoardName touchRect:largeRect rows:19 cols:19];
    _enlargedBoard.touchEnabled = false;
    _enlargedBoard.anchorPoint = ccp(0, 0);
    _enlargedBoard.position = ccp(0, 0);
    _enlargedBoard.blackChessName = @"black-button-large.png";
    _enlargedBoard.whiteChessName = @"white-button-large.png";
    [self addChild:_orgBoard z:OrginalZorder];
    
    _largeSize = _enlargedBoard.boundingBox.size;
    _orgSize = _orgBoard.boundingBox.size;
    
    return self;
}

- (void) setTouchEnabled:(BOOL)touchEnabled
{
    if(touchEnabled){
        [[[CCDirector sharedDirector]  touchDispatcher] addTargetedDelegate:self priority:10 swallowsTouches:YES];
    }else{
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }
    _touchEnabled = touchEnabled;
}


- (void) setBoardBack:(ccTime) passed
{
    EZDEBUG(@"setBoardBack get called");
    _isLargeBoard = false;
    [_enlargedBoard removeFromParentAndCleanup:NO];
    //Add animation later, mean shink at the initial touch point
    //sync up largeBoard and small board
    //Assume some chess are planted
    //Regret will be handled by me.
    for(int i = _orgBoard.allSteps.count; i < _enlargedBoard.allSteps.count; i++){
        EZChessPosition* cp = [_enlargedBoard.allSteps objectAtIndex:i];
        [_orgBoard putChessman:cp.coord animated:NO];
    }
}

//How to enlarge the board?
- (void) locateLargeBoard:(CGPoint) pt
{
    CGFloat deltaX = (pt.x/_orgSize.width) * _largeSize.width - pt.x;
    
    CGFloat deltaY = (pt.y/_orgSize.height) * _largeSize.height - pt.y;
    
    _enlargedBoard.position = ccp(-deltaX, -deltaY);
    [self addChild:_enlargedBoard z:LargerZorder];
}
//I don't like to ask for help.
//It mean to owe people something. I have to pay it back.
//How to pay it back?
//Forgot about it.
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint localPt = [self locationInSelf:touch];
    if(CGRectContainsPoint(_touchZone, localPt)){
        EZDEBUG(@"Unschedule get called");
        [self unschedule:@selector(setBoardBack:)];
        if(_isLargeBoard){
           //Ya, I got the whole logic sort out.
        }else{
            //Add animation later
            [self locateLargeBoard:localPt];
            _isLargeBoard = TRUE;
        }
        
        [_enlargedBoard ccTouchBegan:touch withEvent:event];
        return TRUE;
    }
    
    return FALSE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Forward the touch event to the large board
    EZDEBUG(@"Move recieved. touch.Point:%@", NSStringFromCGPoint(touch.locationInGL));
    [_enlargedBoard ccTouchMoved:touch withEvent:event];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_enlargedBoard ccTouchEnded:touch withEvent:event];
    //[self schedule:@selector(setBoardBack:) interval:1];
    
    EZDEBUG(@"Arranged schedule");
    [self schedule:@selector(setBoardBack:) interval:1.0 repeat:1 delay:0.5];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    EZDEBUG(@"TouchCancelled get called");
}


- (void) onEnter
{
    [super onEnter];
    [self setTouchEnabled:YES];
}

- (void) onExit
{
    [super onExit];
    [self setTouchEnabled:FALSE];
}

@end
