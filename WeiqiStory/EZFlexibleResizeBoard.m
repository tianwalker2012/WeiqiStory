//
//  EZFlexibleResizeBoard.m
//  WeiqiStory
//
//  Created by xietian on 12-12-12.
//
//


#import "EZFlexibleResizeBoard.h"
#import "EZChessBoard.h"
#import "EZTouchHelper.h"
#import "EZTouchHelper.h"
#import "EZChess2Image.h"
#import "EZCCExtender.h"
#import "EZCoord.h"
#import "EZChessPosition.h"
#import "EZTitleImage.h"

@implementation EZFlexibleResizeBoard

- (void) createGestureView:(CGRect)frame
{
    frame.origin.x = frame.origin.x - frame.size.width/2;
    frame.origin.y = frame.origin.y - frame.size.height/2;
    EZDEBUG(@"Frame:%@", NSStringFromCGRect(frame));
    CGRect uiRect = [EZTouchHelper convertGL2UI:frame];
    _gestureView = [[UIView alloc] initWithFrame:uiRect];
    _gestureView.backgroundColor = [UIColor colorWithRed:0.8 green:0.7 blue:0.7 alpha:0.4];
    UIGestureRecognizer* recog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
    [_gestureView addGestureRecognizer:recog];
    [[CCDirector sharedDirector].view addSubview:_gestureView];
}

- (id) initWithBoard:(NSString*)orgBoardName boardTouchRect:(CGRect)boardTouchRegion visibleSize:(CGSize)size
{
    self = [super init];
    self.anchorPoint = ccp(0.5, 0.5);
    _chessBoard = [[EZChessBoard alloc] initWithFile:orgBoardName touchRect:boardTouchRegion rows:19 cols:19];
    
    _chessBoard.touchEnabled = NO;
    _chessBoard.anchorPoint = ccp(0.5, 0.5);
    _chessBoard.position = ccp(size.width/2, size.height/2);
    _chessBoard.isLargeBoard = true;
    _chessBoard.whiteChessName = @"white-button-large.png";
    _chessBoard.blackChessName = @"black-button-large.png";
    _visableSize = size;
    _touchEnabled = true;
    _simpleBoard = [[EZTitleImage alloc] initWith:orgBoardName viewPort:size];
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
    
    
    _moveInnerRegion = CGRectMake(8, 8, _visableSize.width-16, _visableSize.height-16);
    _moveOutterRegion = CGRectMake(-8, -8, _visableSize.width+16, _visableSize.width+16);
    //CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(128, 0, 128, 255)];
    //[self addChild:colorLayer z:0];
    //[self addChild:_simpleBoard];
    [self addChild:_chessBoard];
    [self addChild:_movingCursor];
    [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:StandardTouchPriority];
    return self;
}

//Turn into local point
//Turn off the move region.
//Make the move more intuitive.
//Let's me describe what's going on in my mind
//1. Record the fist touch point.
//2. for each moving event, compare it with the previous one
//3. If it is farther away from the initial touch point, I will intepret it as you want to move the board rather than try to
//Plant chessman, is this cool?
//I will calculate the vectors, use it to move the board accordingly.
- (BOOL) fallInMoveRegion:(CGPoint)localPt
{
    return TRUE;
    
    if(CGRectContainsPoint(_moveOutterRegion, localPt) && !CGRectContainsPoint(_moveInnerRegion, localPt)){
        return TRUE;
    }
    return false;
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
//5. I assume don't have basic pattern mean don't scale at all. 
- (void) setBasicPatterns:(NSArray *)basicPatterns
{
    _basicPatterns = basicPatterns;
    [self calculateRegionForPattern:_basicPatterns];
}


//Some times, I just want to calculate the region without really plant it.
//Like my recalculation jobs.
- (void) calculateRegionForPattern:(NSArray*)pattern isPlant:(BOOL)plant
{
    
    if(pattern.count == 0){
        //Will back to the original size
        //Why? This is a convention. 
        _chessBoard.scale = _orgScale;
        _lastCalculatedScale = _orgScale;
        return;
    }
    //EZDEBUG(@"CalculateRegion get called, thread stack is:%@", [NSThread callStackSymbols]);
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
    _lastCalculatedScale = scaleFactor;
    _chessBoard.position = ccp(orgX*scaleFactor, orgY*scaleFactor);
    
    //I will back to this scale once being recovered
    //_prevScale = _chessBoard.scale;
    
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


//The point itself determined the move speed.
//
- (void) adjustPositionForPoint:(CGPoint)localPoint
{
    [_chessBoard changeAnchor:ccp(0, 0)];
    CGPoint moveSpeed = ccp(120, 120);
    CGPoint curAnchor = ccp(localPoint.x/_moveOutterRegion.size.width, localPoint.y/_moveOutterRegion.size.height);
    CGPoint deltaAnchor = ccp(0.5 - curAnchor.x, 0.5 - curAnchor.y);
    CGPoint delta = ccp(deltaAnchor.x*moveSpeed.x, deltaAnchor.y*moveSpeed.y);
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
    EZDEBUG(@"curAnchor:%@, deltaAnchor:%@, delta:%@, After change:%@", NSStringFromCGPoint(newPos), NSStringFromCGPoint(curAnchor),
            NSStringFromCGPoint(deltaAnchor), NSStringFromCGPoint(delta));
    id animate = [CCMoveTo actionWithDuration:0.1 position:newPos];
    id totalAnimate = [CCSequence actions:animate,[CCCallBlock actionWithBlock:^(){
        EZDEBUG(@"animate completed, Current touch status:%i", _touchState);
        if(_touchState == kBoardMoving){
            EZDEBUG(@"seems still touched, let's move again");
            [_chessBoard stopAllActions];
            [self ccTouchesMoved:[NSSet setWithObject:_currMovingTouch] withEvent:nil];
        }
    }],nil];
    [_chessBoard runAction:totalAnimate];


    
}
//I assumed that the anchor is 0, 0
//Which is not the case. Let's fix it.
- (void) adjustPosition:(CGPoint)delta
{
    [_chessBoard changeAnchor:ccp(0, 0)];
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
    
    id animate = [CCMoveTo actionWithDuration:0.2 position:newPos];
    id totalAnimate = [CCSequence actions:animate,[CCCallBlock actionWithBlock:^(){
        EZDEBUG(@"animate completed, Current touch status:%i", _touchState);
        if(_touchState == kBoardMoving){
            EZDEBUG(@"seems still touched, let's move again");
            [_chessBoard stopAllActions];
            [self ccTouchesMoved:[NSSet setWithObject:_currMovingTouch] withEvent:nil];
        }
    }],nil];
    [_chessBoard runAction:totalAnimate];
}

//I assumed that the anchor is 0, 0
//Which is not the case. Let's fix it.
- (void) adjustPositionOld:(CGPoint)delta
{
    [_simpleBoard changeAnchor:ccp(0, 0)];
    EZDEBUG(@"Before change:%@", NSStringFromCGPoint(_simpleBoard.position));
    //What's the purpose of this factor?
    //make the move faster.
    
    CGFloat scaleFactor = _simpleBoard.boundingBox.size.width/_visableSize.width;
    delta = ccp(delta.x*scaleFactor, delta.y*scaleFactor);
    CGPoint newPos = ccp(_simpleBoard.position.x + delta.x, _simpleBoard.position.y + delta.y);
    if(newPos.x > 0){
        newPos.x = 0;
    }
    if(newPos.y > 0){
        newPos.y = 0;
    }
    
    if((_simpleBoard.boundingBox.size.width + newPos.x) < _visableSize.width){
        newPos.x = _visableSize.width - _simpleBoard.boundingBox.size.width;
    }
    
    if((_simpleBoard.boundingBox.size.height + newPos.y) < _visableSize.height){
        newPos.y = _visableSize.height - _simpleBoard.boundingBox.size.height;
    }
    EZDEBUG(@"After change:%@", NSStringFromCGPoint(newPos));
    _simpleBoard.position = newPos;
}


- (CGFloat) distanceBetween:(CGPoint)src dst:(CGPoint)dst
{
    return sqrtf((src.x - dst.x)*(src.x - dst.x) + (src.y - dst.y)*(src.y - dst.y));
}

//What I should do in the method?
//I will only move when the segament larger than so threshold value.
- (void) adjustPositionForPan:(CGPoint)localPoint
{

    CGFloat distance = [self distanceBetween:_prevPoint dst:localPoint];
    //Some filter machanism
    EZDEBUG("New Distance:%f, prevPoint:%@, localPoint:%@", distance, NSStringFromCGPoint(_prevPoint), NSStringFromCGPoint(localPoint));
    if(distance < 10){
        EZDEBUG("smaller than the threshold, ignore");
        return;
    }
    EZDEBUG(@"Animated number:%i", _chessBoard.numberOfRunningActions);
    if(_chessBoard.numberOfRunningActions > 0){
        EZDEBUG(@"Animation are going on, ignore the pan");
        return;
    }
    
    //[_chessBoard ]
    CGPoint oldPos = _chessBoard.position;
    //I think I am doing the right thing, seems this is a typo.
    CGPoint delta = ccp(localPoint.x - _prevPoint.x, localPoint.y - _prevPoint.y);
    CGFloat scaleFactor = _chessBoard.boundingBox.size.width/_visableSize.width;
    delta = ccp(delta.x*scaleFactor, delta.y*scaleFactor);
    CGPoint newPos = ccp(_chessBoard.position.x + delta.x, _chessBoard.position.y + delta.y);
    _prevPoint = localPoint;
    [_chessBoard changeAnchor:ccp(0, 0)];
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
    
    EZDEBUG(@"delta:%@, scaleFactor:%f, newPos:%@, oldPos:%@", NSStringFromCGPoint(delta), scaleFactor, NSStringFromCGPoint(newPos), NSStringFromCGPoint(oldPos));
    id animate = [CCMoveTo actionWithDuration:0.1 position:newPos];
    [_chessBoard runAction:animate];
    
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

- (void) locateLargeBoard:(CGPoint) globalPoint
{
    EZDEBUG(@"Current scale:%f", _chessBoard.scale);
    if(_chessBoard.scale >= 1){
        EZDEBUG(@"quit enlarging board for the board already big enough");
        return;
    }
    //_prevScale = _chessBoard.scale;
    //CGFloat deltaX = (pt.x/_visableSize.width) * _largeSize.width - pt.x;
    
    //CGFloat deltaY = (pt.y/_visableSize.height) * _largeSize.height - pt.y;
    CGPoint localPoint = [_chessBoard convertToNodeSpace:globalPoint];
    CGPoint adjustedPoint = ccp(localPoint.x*_chessBoard.scale, localPoint.y*_chessBoard.scale);
    CGSize boardSize = _chessBoard.boundingBox.size;
    CGPoint updatedAnchor = ccp(adjustedPoint.x/boardSize.width, adjustedPoint.y/boardSize.height);
    EZDEBUG(@"gloablPoint:%@, localPoint:%@, updatedAnchor:%@， position:%@, boardSize:%@, adjustedPoint:%@", NSStringFromCGPoint(globalPoint), NSStringFromCGPoint(localPoint), NSStringFromCGPoint(updatedAnchor), NSStringFromCGPoint(_chessBoard.position), NSStringFromCGRect(_chessBoard.boundingBox), NSStringFromCGPoint(adjustedPoint));
    
    [_chessBoard changeAnchor:updatedAnchor];
    id action = [CCScaleTo actionWithDuration:0.15 scale:1];
    id completeAct = [CCCallBlock actionWithBlock:^(){
        EZDEBUG(@"Enlarge animation is done. what we can do here?");
    }];
    
    [_chessBoard runAction:[CCSequence actions:action, completeAct, nil]];
}


- (void) panEvent:(id)sender
{
    UIPanGestureRecognizer* panRecog = sender;
    EZDEBUG(@"Pan position:%@", NSStringFromCGPoint([panRecog translationInView:[CCDirector sharedDirector].view]));
    //[self handlePan:[_panRecognizer translationInView:[CCDirector sharedDirector].view]];
    
}

- (void) onEnter
{
    [super onEnter];
    self.clippingRegion = CGRectMake(self.position.x, self.position.y, _visableSize.width, _visableSize.height);
    
    _touchRegion = CGRectMake(0, 0, _visableSize.width, _visableSize.height);
    
    //[_gestureView addGestureRecognizer:_panRecognizer];
    
    //[_gestureView addGestureRecognizer:_pinchRecognizer];
    //[[CCDirector sharedDirector].view addSubview:_gestureView];
    //Is this necessary?
    //if(!_gestureView){
    //    [self createGestureView:self.clippingRegion];
    //}
    [[CCDirector sharedDirector].view setMultipleTouchEnabled:YES];
    //Some magic number
    //What's the meaning of the priority
    //When would I use it?
    if(_touchEnabled){
        [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
        [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:StandardTouchPriority];
        
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


//What should I do in this code?
//Set the board back to it's previous ratio.
//Cool, Let's do it. 
- (void) setBoardBack:(ccTime) time
{
    __weak EZFlexibleResizeBoard* weakSelf = self;
    id animate =[CCSequence actions:[CCScaleTo actionWithDuration:0.1 scale:_lastCalculatedScale],[CCCallBlock actionWithBlock:^(){
        [weakSelf adjustBoardToFit];
    }],nil];
    [_chessBoard runAction:animate];

    EZDEBUG(@"setBoardBack to scale:%f", _lastCalculatedScale);
}

//The purpose of this function call is to make the board will not show raw background.
- (void) adjustBoardToFit
{
    [_chessBoard changeAnchor:ccp(0, 0)];
    CGPoint org = _chessBoard.boundingBox.origin;
    
    if(org.x > 0){
        org.x = 0;
    }
    if(org.y > 0){
        org.y = 0;
    }
    
    if((_chessBoard.boundingBox.size.width + org.x) < _visableSize.width){
        org.x = _visableSize.width - _chessBoard.boundingBox.size.width;
    }
    
    if((_chessBoard.boundingBox.size.height + org.y) < _visableSize.height){
        org.y = _visableSize.height - _chessBoard.boundingBox.size.height;
    }
    _chessBoard.position = org;
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
    [self unschedule:@selector(setboardBack:)];
    //Why do I have oldTouch?
    //Because I want to use it to detect multiple touchs
    UITouch* oldTouch = [_allTouches anyObject];
    [_allTouches addObjectsFromArray:validTouches.allObjects];
    UITouch* touch = [validTouches anyObject];
    _initialPoint = [self locationInSelf:touch];
    if(!oldTouch){
        oldTouch = touch;
    }
    
   
    EZDEBUG(@"Original Resize board Touch begin");
    _touchState = kSingleTouch;
    [self locateLargeBoard:[touch locationInGL]];
    [_chessBoard ccTouchBegan:touch withEvent:event];
    //[self schedule:@selector(setMoveBoard:) interval:2];
    return;
    
}

//What's the purpose of this method?
//To check if the move is to move the board or not
- (BOOL) isBoardMoving:(CGPoint)org currentMove:(CGPoint)cur
{

    return FALSE;
    CGFloat thresholdDistance = 20;
    CGFloat distance = sqrtf((cur.x-org.x)*(cur.x - org.x) + (cur.y - org.x)*(cur.y - org.y));
    if(distance > thresholdDistance){
        return TRUE;
    }
    return FALSE;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch moved, touch count:%i, allTouches:%i, touchState:%i", touches.count, _allTouches.count, _touchState);
    UITouch* touch = [touches anyObject];
    
    UITouch* tch = touch;
    CGPoint localPT = [self locationInSelf:tch];
    
    if(_touchState == kSingleTouch && [self isBoardMoving:_initialPoint currentMove:localPT]){
        EZDEBUG(@"Board moving, initial:%@, current:%@",NSStringFromCGPoint(_initialPoint), NSStringFromCGPoint(localPT));
        _prevPoint = localPT;
        [_chessBoard ccTouchCancelled:tch withEvent:event];
        _touchState = kBoardMoving;
        _movingCursor.visible = true;
    }
    
    if(_touchState == kBoardMoving){
        [self adjustPositionForPan:localPT];
        return;
    }else if(_touchState == kSingleTouch){
        _movingCursor.visible = false;
        [_chessBoard ccTouchMoved:touch withEvent:event];
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch ended:%i, status:%i", touches.count, _touchState);
    //May add animation later.
    _movingCursor.visible = false;
    UITouch* tch = [touches anyObject];
    CGPoint localPT = [self locationInSelf:tch];
    for(UITouch* touch in touches){
        [_allTouches removeObject:touch];
    }
    if(_touchState == kBoardMoving){
        EZDEBUG(@"Fall into the move region:%@", NSStringFromCGPoint(localPT));
        if(_touchState == kSingleTouch){
            [_chessBoard ccTouchCancelled:tch withEvent:event];
        }
        //_touchState = kBoardMoving;
        _touchState = kTouchStart;
        EZDEBUG(@"will handle board move");
        //_currMovingTouch = tch;
        //_isFirstPan = TRUE;
        [self adjustPositionForPan:localPT];
        return;
    }
    
    
    UITouch* touch = [touches anyObject];
    //mean this guy was really removed from the queue
    if(_touchState == kSingleTouch && _allTouches.count == 0){
        _touchState = kTouchStart;
        [_chessBoard ccTouchEnded:touch withEvent:event];
        [self schedule:@selector(setBoardBack:) interval:1.0 repeat:0 delay:0.5];
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
