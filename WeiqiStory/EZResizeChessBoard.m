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
#import "EZChess2Image.h"

@implementation EZResizeChessBoard

- (id) initWithOrgBoard:(NSString*)orgBoardName orgRect:(CGRect)orgRect largeBoard:(NSString*)largeBoardName largeRect:(CGRect)largeRect
{
    self  = [super init];
    _orgBoard = [[EZChessBoard alloc] initWithFile:orgBoardName touchRect:orgRect rows:19 cols:19];
    _orgBoard.touchEnabled = false;
    _orgBoard.anchorPoint = ccp(0, 0);
    _orgBoard.position = ccp(0, 0);
    
    //self.clippingRegion = _orgBoard.boundingBox;
    
    _touchZone = _orgBoard.touchRect;
    self.contentSize = _touchZone.size;
    _enlargedBoard = [[EZChessBoard alloc] initWithFile:largeBoardName touchRect:largeRect rows:19 cols:19];
    _enlargedBoard.touchEnabled = false;
    _enlargedBoard.anchorPoint = ccp(0, 0);
    _enlargedBoard.position = ccp(0, 0);
    _enlargedBoard.blackChessName = @"black-button-large.png";
    _enlargedBoard.whiteChessName = @"white-button-large.png";
    [self addChild:_orgBoard z:OrginalZorder];
    //[self addChild:_enlargedBoard z:LargerZorder];
    
    _largeSize = _enlargedBoard.boundingBox.size;
    _orgSize = _orgBoard.boundingBox.size;
    //Why the boundingBox didn't reflect the real rectangular?
    //What's going on?
    //self.clippingRegion = self.boundingBox;
    //EZDEBUG(@"Initial region:%@", NSStringFromCGRect(self.boundingBox));
    return self;
}

//If I add a similarity check what will happen?
//Then it will not call the add again if it is already exist.

- (void) setTouchEnabled:(BOOL)touchEnabled
{
    if(_touchEnabled == touchEnabled){
        EZDEBUG(@"Return without repeat");
        return;
    }
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
    //[self addChild:_orgBoard];
    [_enlargedBoard removeFromParentAndCleanup:NO];
    _enlargedBoard.visible = false;
    _orgBoard.visible = true;
    
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
    
    _orgBoard.anchorPoint = ccp(pt.x/_orgSize.width, pt.y/_orgSize.height);
    _orgBoard.position = ccp(pt.x, pt.y);
    _enlargedBoard.position = ccp(-deltaX, -deltaY);
    [self addChild:_enlargedBoard z:LargerZorder];
    
    id action = [CCScaleTo actionWithDuration:0.15 scale:_largeSize.width/_orgSize.width];
    id completeAct = [CCCallBlock actionWithBlock:^(){
        //[_orgBoard removeFromParentAndCleanup:NO];
        _enlargedBoard.visible = true;
        _orgBoard.visible = false;
        _orgBoard.scale = 1;
    }];
    
    [_orgBoard runAction:[CCSequence actions:action, completeAct, nil]];
}


- (void) syncMarks
{
    if(_orgBoard.allMarks.count > _enlargedBoard.allMarks.count){
        //add marks.
        for(int i = _enlargedBoard.allMarks.count; i < _orgBoard.allMarks.count; i++){
            [_enlargedBoard putMarks:@[[_orgBoard.allMarks objectAtIndex:i]]];
        }
        
    }else if(_orgBoard.allMarks.count < _enlargedBoard.allMarks.count){
        NSInteger regretSteps = _enlargedBoard.allMarks.count - _orgBoard.allMarks.count;
        _enlargedBoard.chessmanSetType = kChessMark;
        [_enlargedBoard regretSteps:regretSteps animated:NO];
        _enlargedBoard.chessmanSetType = kChessMan;
    }
    
}

// Sync all the chessmans. 
- (void) syncChessmans
{
    if(_orgBoard.allSteps.count > _enlargedBoard.allSteps.count){
        for(int i = _enlargedBoard.allSteps.count; i < _orgBoard.allSteps.count; i++){
            EZChessPosition* cp = [_orgBoard.allSteps objectAtIndex:i];
            [_enlargedBoard putChessman:cp.coord animated:NO];
        }
    }else if(_orgBoard.allSteps.count < _enlargedBoard.allSteps.count){
        NSInteger regretSteps = _enlargedBoard.allSteps.count - _orgBoard.allSteps.count;
        [_enlargedBoard regretSteps:regretSteps animated:NO];
    }
    
}

//Sync the orgBoard to the large board.
- (void) syncBoards
{
    //_enlargedBoard.showStep =  _orgBoard.showStep;
    //_enlargedBoard.showStepStarted = _orgBoard.showStepStarted;
    if(_orgBoard.allMarks.count == _enlargedBoard.allMarks.count && _orgBoard.allSteps.count == _enlargedBoard.allSteps.count){
        return;
    }
    [self syncMarks];
    [self syncChessmans];
    //Do the right thing at the right place, is quite important.
    //Why do we need to be tranparent.
    //Tell people why can keep them focused.
    if(_enlargedBoard.isCurrentBlack != _orgBoard.isCurrentBlack){
        [_enlargedBoard toggleColor];
    }
}
//I don't like to ask for help.
//It mean to owe people something. I have to pay it back.
//How to pay it back?
//Forgot about it.
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    EZDEBUG(@"Original Resize board Touch begin");
    CGPoint localPt = [self locationInSelf:touch];
    if(CGRectContainsPoint(_touchZone, localPt)){
        if(_touchedBlock){
            _touchedBlock();
        }
        _touchAccepted = true;
        EZDEBUG(@"Unschedule get called");
        [self unschedule:@selector(setBoardBack:)];
        [self syncBoards];
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
    _touchAccepted = false;
    return FALSE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Forward the touch event to the large board
    EZDEBUG(@"Move recieved. touch.Point:%@", NSStringFromCGPoint(touch.locationInGL));
    [_enlargedBoard ccTouchMoved:touch withEvent:event];
}

//Why the touch event give to me, even if I refuse it.
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(_touchAccepted){
        EZDEBUG(@"Accepted touch end");
        [_enlargedBoard ccTouchEnded:touch withEvent:event];
        [self schedule:@selector(setBoardBack:) interval:1.0 repeat:0 delay:0.5];
    }else{
        EZDEBUG(@"Unaccepted touch end");
    }
    _touchAccepted = false;
    //[self schedule:@selector(setBoardBack:) interval:1];
        
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    EZDEBUG(@"TouchCancelled get called");
}


- (void) onEnter
{
    //Only here the boundingBox, the original are determined
    //Because it already added into the display layer.
    [super onEnter];
    self.clippingRegion = self.boundingBox;
    [self setTouchEnabled:YES];
}

- (void) onExit
{
    [super onExit];
    [self setTouchEnabled:FALSE];
}

@end
