//
//  EZFlexibleBoard.m
//  WeiqiStory
//
//  Created by xietian on 12-12-3.
//
//

#import "EZFlexibleBoard.h"
#import "EZChessBoard.h"
#import "EZTouchHelper.h"
#import "EZTouchHelper.h"
#import "EZChess2Image.h"
#import "EZCCExtender.h"
#import "EZCoord.h"
#import "EZChessPosition.h"

@implementation EZFlexibleBoard

- (id) initWithBoard:(NSString*)orgBoardName boardTouchRect:(CGRect)boardTouchRegion visibleSize:(CGSize)size
{
    self = [super init];
    self.anchorPoint = ccp(0.5, 0.5);
    _chessBoard = [[EZChessBoard alloc] initWithFile:orgBoardName touchRect:boardTouchRegion rows:19 cols:19];
    
    _chessBoard.touchEnabled = NO;
    _chessBoard.anchorPoint = ccp(0.5, 0.5);
    _chessBoard.position = ccp(size.width/2, size.height/2);
    _chessBoard.whiteChessName = @"white-button-large.png";
    _chessBoard.blackChessName = @"black-button-large.png";
    _visableSize = size;
    _touchEnabled = true;
    _simpleBoard = [CCSprite spriteWithFile:orgBoardName];
    _simpleBoard.anchorPoint = ccp(0.5, 0.5);
    //_simpleBoard.position = ccp(-150, -150);
    _simpleBoard.position = ccp(_visableSize.width/2, _visableSize.height/2);
    self.contentSize = _visableSize;
    _allTouches = [[NSMutableSet alloc] init];
    _touchState = kTouchStart;
    //Zoom in limit. You can't make the board smaller than the boardFrame
    //I assume the width and height is the same,
    //Use an animation to indicate what user can do on this board.
    _orgScale = _visableSize.width/_chessBoard.boundingBox.size.width;
    _movingCursor = [CCSprite spriteWithFile:@"board-move-sign.png"];
    _movingCursor.position = ccp(_visableSize.width/2, _visableSize.height/2);
    _movingCursor.visible = false;
    //CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(128, 0, 128, 255)];
    //[self addChild:colorLayer z:0];
    //[self addChild:_simpleBoard];
    [self addChild:_chessBoard];
    [self addChild:_movingCursor];

    [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:StandardTouchPriority];
    return self;
}

- (void) backToRollStatus
{
    _chessBoard.scale = _orgScale;
    _chessBoard.position = ccp(_visableSize.width/2, _visableSize.height/2);
    _chessBoard.anchorPoint = ccp(0.5, 0.5);
}

//Client don't need to care about the possiblity
//The method will figure out a feasible scale value for it.
- (void) scaleBoardTo:(CGFloat)scale
{
    EZDEBUG(@"before normalize:%f", scale);
    if(scale > MaximumScale){
        scale = MaximumScale;
    }
    
    if(scale < _orgScale){
        scale = _orgScale;
    }
    EZDEBUG(@"After normalize:%f", scale);
    
    CGPoint center = ccp(_visableSize.width/2, _visableSize.height/2);
    CGPoint globalCenter = [self convertToWorldSpace:center];
    CGPoint localCenter = [_chessBoard convertToNodeSpace:globalCenter];
    CGPoint changedAnchor = ccp(localCenter.x/_chessBoard.contentSize.width, localCenter.y/_chessBoard.contentSize.height);
    //EZDEBUG(@"Changed anchor:%@, center:%@, globalCenter:%@, localCenter:%@", NSStringFromCGPoint(changedAnchor), NSStringFromCGPoint(center), NSStringFromCGPoint(globalCenter), NSStringFromCGPoint(localCenter));
    
    [_chessBoard changeAnchor:changedAnchor];
    EZDEBUG(@"Position before scale:%@, boundingBox:%@", NSStringFromCGPoint(_chessBoard.position), NSStringFromCGRect(_chessBoard.boundingBox));
    _chessBoard.scale = scale;
    EZDEBUG(@"Position after scale:%@, boundingBox:%@", NSStringFromCGPoint(_chessBoard.position), NSStringFromCGRect(_chessBoard.boundingBox));
    [_chessBoard changeAnchor:ccp(0, 0)];
    EZDEBUG(@"Position after anchor change:%@", NSStringFromCGPoint(_chessBoard.position));
    
    CGPoint newPos = [EZTouchHelper adjustRect:_chessBoard.boundingBox coveredRect:CGRectMake(0, 0, _visableSize.width, _visableSize.height)];
    
    _chessBoard.position = newPos;
    //Make sure the boundingBox accurately reflect the reality.
    
    EZDEBUG(@"BoundingBox after scale:%@, the updatd position:%@", NSStringFromCGRect(_chessBoard.boundingBox), NSStringFromCGPoint(newPos));
     
}

- (void) recalculateBoardRegion
{
    NSArray* allChesssMan = _chessBoard.allSteps;
    NSMutableArray* coords = [[NSMutableArray alloc] initWithCapacity:allChesssMan.count];
    for(EZChessPosition* cp in allChesssMan){
        [coords addObject:cp.coord];
    }
    [self calculateRegionForPattern:coords isPlant:NO];
}

- (void) zoomIn
{
    [self scaleBoardTo:1];
}

- (void) zoomOut
{
    [self scaleBoardTo:1];
}

- (void) pinchEvent:(id)sender
{
    EZDEBUG(@"Pinch scale:%f", _pinchRecognizer.scale);
    //_pinchOngoing = false;
}

//What's the logic in this method
//1.Calculate the rect
//2.Calculate the shift in largeBoard
//3.Shift the bound to the board
//4.Scale the board to fit the frame.
- (void) setBasicPatterns:(NSArray *)basicPatterns
{
    _basicPatterns = basicPatterns;
    
    [self calculateRegionForPattern:_basicPatterns];
}


//Some times, I just want to calculate the region without really plant it.
//Like my recalculation jobs.
- (void) calculateRegionForPattern:(NSArray*)pattern isPlant:(BOOL)plant
{
    CGRect alignRect = [EZChess2Image shrinkBoard:pattern minimum:5];
    //EZDEBUG(@"alignedRect:%@", NSStringFromCGRect(alignRect));
    int iWidth = MAX(alignRect.size.height,alignRect.size.width);
    //CGFloat scala = orgWidth/size.width;
    _chessBoard.position = ccp(0, 0);
    _chessBoard.anchorPoint = ccp(0, 0);
    _chessBoard.scale = 1;
    //We need to start with a fresh board, otherwise, it won't able to work
    CGFloat gap = 35.0;
    CGFloat pad = 27.0;
    CGFloat fWidth = 2*pad + gap*iWidth;
    CGFloat orgX = 0.0;
    CGFloat orgY = 0.0;
    if(alignRect.origin.x == 0){
        orgX = 0;
    }
    if(alignRect.origin.y == 0){
        orgY = 0;
    }
    
    if(alignRect.origin.x == 1){
        orgX = fWidth - _chessBoard.boundingBox.size.width;
    }
    
    if(alignRect.origin.y == 1){
        orgY = fWidth - _chessBoard.boundingBox.size.width;
    }
    
    CGRect clippedRect = CGRectMake(orgX, orgY, fWidth, fWidth);
    EZDEBUG(@"Final clippedRect is:%@", NSStringFromCGRect(clippedRect));
    //[_chessBoard changeAnchor:ccp(0, 0)];
    
    EZDEBUG(@"Before scale:%@", NSStringFromCGRect(_chessBoard.boundingBox));
    CGFloat scaleFactor = _visableSize.width/fWidth;
    EZDEBUG(@"Before scale:%@, scalaFactor:%f", NSStringFromCGRect(_chessBoard.boundingBox), scaleFactor);
    _chessBoard.scale = scaleFactor;
    _chessBoard.position = ccp(orgX*scaleFactor, orgY*scaleFactor);
    
    
    EZDEBUG(@"After scale:%@", NSStringFromCGRect(_chessBoard.boundingBox));
    if(plant){
        [_chessBoard putChessmans:pattern animated:NO];
    }

    //What's the purpose of this?
    //Make sure the rotation was normal
    [_chessBoard changeAnchor:ccp(0.5, 0.5)];
}


- (void) calculateRegionForPattern:(NSArray*)pattern
{
    [self calculateRegionForPattern:pattern isPlant:YES];
}

- (void) adjustPosition:(CGPoint)delta
{
    EZDEBUG(@"Before change:%@", NSStringFromCGPoint(_chessBoard.position));
    //What's the purpose of this factor?
    //make the move faster.
    
    CGFloat scaleFactor = _chessBoard.boundingBox.size.width/_visableSize.width;
    delta = ccp(delta.x*scaleFactor, delta.y*scaleFactor);
    CGPoint newPos = ccp(_chessBoard.position.x + delta.x, _chessBoard.position.y + delta.y);
    if(newPos.x > 0){
        newPos.x = 0;
    }
    if(newPos.y > 0){
        newPos.y = 0;
    }
    
    if((_chessBoard.boundingBox.size.width + newPos.x) < _visableSize.width){
        newPos.x = _visableSize.width - _chessBoard.boundingBox.size.width;
    }
    
    if((_chessBoard.boundingBox.size.height + newPos.y) < _visableSize.height){
        newPos.y = _visableSize.height - _chessBoard.boundingBox.size.height;
    }
    EZDEBUG(@"After change:%@", NSStringFromCGPoint(newPos));
    _chessBoard.position = newPos;
}

- (void) handlePan:(CGPoint)uiPoint
{
    CGPoint glPoint = [[CCDirector sharedDirector] convertToGL:uiPoint];
    EZDEBUG("Pan in view:%@", NSStringFromCGPoint(glPoint));
    if(_isFirstPan){
        _isFirstPan = FALSE;
        //Will use the point of the CCDirectorView
        _prevPanPoint = glPoint;
        return;
    }
    
    CGPoint currentPoint = glPoint;
    CGPoint delta = ccp(currentPoint.x - _prevPanPoint.x, currentPoint.y - _prevPanPoint.y);
    EZDEBUG(@"Delta:%@, currentPoint:%@, prevPoint:%@", NSStringFromCGPoint(delta), NSStringFromCGPoint(_prevPanPoint), NSStringFromCGPoint(currentPoint));
    [self adjustPosition:delta];
    _prevPanPoint = currentPoint;
}

- (void) panEvent:(id)sender
{
    
    [self handlePan:[_panRecognizer translationInView:[CCDirector sharedDirector].view]];
 
}

- (void) onEnter
{
    [super onEnter];
    self.clippingRegion = CGRectMake(self.position.x, self.position.y, _visableSize.width, _visableSize.height);
    
    _touchRegion = CGRectMake(0, 0, _visableSize.width, _visableSize.height);
    
    //[_gestureView addGestureRecognizer:_panRecognizer];

    //[_gestureView addGestureRecognizer:_pinchRecognizer];
    //[[CCDirector sharedDirector].view addSubview:_gestureView];
    [[CCDirector sharedDirector].view setMultipleTouchEnabled:YES];
    //Some magic number
    //What's the meaning of the priority
    //When would I use it?
    if(_touchEnabled){
        //[[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:StandardTouchPriority];

    }
}

- (void) onExit
{
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}



/**
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    EZDEBUG(@"Original Resize board Touch begin");
    CGPoint localPt = [self locationInSelf:touch];
    if(CGRectContainsPoint(_touchRegion, localPt)){
        
        _touchAccepted = true;
        EZDEBUG(@"Unschedule get called");
        
        [_chessBoard ccTouchBegan:touch withEvent:event];
        return TRUE;
    }
    _touchAccepted = false;
    return FALSE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_chessBoard ccTouchMoved:touch withEvent:event];
}

//Why the touch event give to me, even if I refuse it.
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(_touchAccepted){
        EZDEBUG(@"Accepted touch end");
        [_chessBoard ccTouchEnded:touch withEvent:event];
    }else{
        EZDEBUG(@"Unaccepted touch end");
    }
    _touchAccepted = false;
    //[self schedule:@selector(setBoardBack:) interval:1];
    
}


- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    EZDEBUG(@"Cancel get called");
    [_chessBoard ccTouchCancelled:touch withEvent:event];
}
**/

//Make sure all in the same plage
- (BOOL) checkAllWithinRegion:(NSSet*)touches
{
    for(UITouch* touch in touches){
        CGPoint localPt = [self locationInSelf:touch];
        if(!CGRectContainsPoint(_touchRegion, localPt)){
            return false;
        }
    }
    return true;
}

//The purpose is to pick the touchs which fall into the touch region
- (NSSet*) pickWithinRegion:(NSSet*) touches
{
    NSMutableSet* res = [[NSMutableSet alloc] initWithCapacity:touches.count];
    for(UITouch* touch in touches){
        CGPoint localPt = [self locationInSelf:touch];
        if(CGRectContainsPoint(_touchRegion, localPt)){
            [res addObject:touch];
        }
    }
    return res;
}


- (void) setTouchEnabled:(BOOL)touchEnabled
{
    if(_touchEnabled == touchEnabled){
        EZDEBUG(@"Return without repeat");
        return;
    }
    if(touchEnabled){
        [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:StandardTouchPriority];
    }else{
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }
    _touchEnabled = touchEnabled;
}

//Standard touch event
- (void)ccTouchesBegan:(NSSet *)orgTouches withEvent:(UIEvent *)event
{
    EZDEBUG(@"touch began new:%i", orgTouches.count);
    
    NSSet* validTouches = [self pickWithinRegion:orgTouches];
    EZDEBUG(@"touch within is:%i", validTouches.count);
    if(validTouches.count == 0){
        EZDEBUG(@"Quit for no valid touch");
        return;
    }
    if(_touchBlock){
        _touchBlock();
    }
    //Why do I have oldTouch?
    //Because I want to use it to detect multiple touchs
    UITouch* oldTouch = [_allTouches anyObject];
    [_allTouches addObjectsFromArray:validTouches.allObjects];
    UITouch* touch = [validTouches anyObject];
    if(!oldTouch){
        oldTouch = touch;
    }
    
    if(_touchState == kTouchStart && _allTouches.count == 1){
        EZDEBUG(@"Original Resize board Touch begin");
        _touchState = kSingleTouch;
        EZDEBUG(@"Unschedule get called");
        [_chessBoard ccTouchBegan:touch withEvent:event];
        //[self schedule:@selector(setMoveBoard:) interval:2];
        return;
    }else if(_allTouches.count >= 2){
    //2 cases will get into this block
    //Already accepted the first touch or 2 touch come at the same time
        if(_touchState == kSingleTouch){
            [_chessBoard ccTouchCancelled:touch withEvent:event];
        }
        _touchState = kBoardMoving;
        EZDEBUG(@"will handle board move");
        _currMovingTouch = oldTouch;
        _isFirstPan = TRUE;
        _movingCursor.visible = true;
        [self handlePan:[_currMovingTouch locationInView:[CCDirector sharedDirector].view]];
    }     
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch moved, touch count:%i, allTouches:%i", touches.count, _allTouches.count);
    UITouch* touch = [touches anyObject];
    
    if(_touchState == kBoardMoving){
        //I only care about the touch which is the first registered.
        [self handlePan:[_currMovingTouch locationInView:[CCDirector sharedDirector].view]];
    }else if(_touchState == kSingleTouch){
        [_chessBoard ccTouchMoved:touch withEvent:event];
    }

}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch ended:%i", touches.count);
    //May add animation later.
    for(UITouch* touch in touches){
        [_allTouches removeObject:touch];
    }
    UITouch* touch = [touches anyObject];
    
    //mean this guy was really removed from the queue
    if(_touchState == kSingleTouch && _allTouches.count == 0){
        _touchState = kTouchStart;
        [_chessBoard ccTouchEnded:touch withEvent:event];
    }else if(_touchState == kBoardMoving && _allTouches.count < 2){
        _touchState = kTouchStart;
        [self handlePan:[_currMovingTouch locationInView:[CCDirector sharedDirector].view]];
        _movingCursor.visible = FALSE;
    }
    //[self schedule:@selector(setBoardBack:) interval:1];
}

//Sometimes if the condication is more flexible, make the things easier 
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Cancel get called");
    for(UITouch* touch in touches){
        [_allTouches removeObject:touch];
    }
    if(_touchAccepted){
        UITouch* touch = [touches anyObject];
        [_chessBoard ccTouchCancelled:touch withEvent:event];
    }
    _touchAccepted = false;
}

@end
