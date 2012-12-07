//
//  EZFlexibleTester.m
//  WeiqiStory
//
//  Created by xietian on 12-12-6.
//
//

#import "EZFlexibleTester.h"
#import "EZChess2Image.h"
#import "EZTouchHelper.h"
#import "EZConstants.h"

@implementation EZFlexibleTester


- (id) initWithBoard:(NSString*)orgBoardName boardTouchRect:(CGRect)boardTouchRegion visibleSize:(CGSize)size
{
    self = [super init];
    _chessBoard = [CCSprite spriteWithFile:orgBoardName];
    //_chessBoard.touchEnabled = NO;
    _chessBoard.anchorPoint = ccp(0, 0);
    _chessBoard.position = ccp(0, 0);
    //_chessBoard.whiteChessName = @"white-button-large.png";
    //_chessBoard.blackChessName = @"black-button-large.png";
    _visableSize = size;
    _allTouches = [[NSMutableSet alloc] init];
    _touchState = kTouchStart;
    //Zoom in limit. You can't make the board smaller than the boardFrame
    //I assume the width and height is the same,
    //Use an animation to indicate what user can do on this board.
    _orgScale = _visableSize.width/_chessBoard.boundingBox.size.width;
    _movingCursor = [CCSprite spriteWithFile:@"board-move-sign.png"];
    _movingCursor.position = ccp(_visableSize.width/2, _visableSize.height/2);
    _movingCursor.visible = false;
    CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(128, 0, 128, 255)];
    [self addChild:colorLayer z:0];
    
    [self addChild:_chessBoard];
    [self addChild:_movingCursor];
    
    return self;
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
    
    //CGPoint center = [EZTouchHelper center:self.boundingBox];
    //What's meaning of the center?
    //it is the center of the self?
    CGPoint center = ccp(self.position.x + _visableSize.width*0.5, self.position.y + _visableSize.height*0.5);
    
    EZDEBUG(@"Center is:%@", NSStringFromCGPoint(center));
    
    CGPoint orgAnchor = _chessBoard.anchorPoint;
    //CGPoint o = _chessBoard.position;
    CGPoint deltaAnchor =  ccp(center.x - _chessBoard.position.x,center.y - _chessBoard.position.y);
    EZDEBUG(@"Changed anchor:%@", NSStringFromCGPoint(deltaAnchor));
    CGPoint changedAnchor = ccp(orgAnchor.x + deltaAnchor.x/_chessBoard.contentSize.width, orgAnchor.y + deltaAnchor.y/_chessBoard.contentSize.height);
    EZDEBUG(@"real anchor:%@", NSStringFromCGPoint(changedAnchor));
    _chessBoard.anchorPoint = changedAnchor;
    //CGRect changedRect = [EZTouchHelper changeAnchor:CGRectMake(_chessBoard.position.x, _chessBoard.position.y, _chessBoard.contentSize.width, _chessBoard.contentSize.height) orgAnchor:orgAnchor changedAnchor:changedAnchor];
    //EZDEBUG(@"changedRect:%@, orgPosition:%@", NSStringFromCGRect(changedRect), NSStringFromCGPoint(_chessBoard.position));
    _chessBoard.position = center;
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

- (void) calculateRegionForPattern:(NSArray*)pattern
{
    CGRect alignRect = [EZChess2Image shrinkBoard:pattern minimum:5];
    //EZDEBUG(@"alignedRect:%@", NSStringFromCGRect(alignRect));
    int iWidth = MAX(alignRect.size.height,alignRect.size.width);
    //CGFloat scala = orgWidth/size.width;
    
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
    CGRect backBounding = _chessBoard.boundingBox;
    _chessBoard.anchorPoint = ccp(0, 0);
    
    EZDEBUG(@"Before scale:%@", NSStringFromCGRect(backBounding));
    CGFloat scaleFactor = _visableSize.width/fWidth;
    EZDEBUG(@"Before scale:%@, scalaFactor:%f", NSStringFromCGRect(_chessBoard.boundingBox), scaleFactor);
    _chessBoard.scale = scaleFactor;
    _chessBoard.position = ccp(orgX*scaleFactor, orgY*scaleFactor);
    
    
    EZDEBUG(@"After scale:%@", NSStringFromCGRect(_chessBoard.boundingBox));
    //[_chessBoard putChessmans:pattern animated:NO];
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
    [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:10];
    //_pinchRecognizer.delegate = self;
    //_panRecognizer.delegate = self;
    
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
