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

@implementation EZFlexibleBoard

- (id) initWithBoard:(NSString*)orgBoardName boardTouchRect:(CGRect)boardTouchRegion visibleSize:(CGSize)size
{
    self = [super init];
    _chessBoard = [[EZChessBoard alloc] initWithFile:orgBoardName touchRect:boardTouchRegion rows:19 cols:19];
    _chessBoard.touchEnabled = NO;
    _chessBoard.anchorPoint = ccp(0, 0);
    _chessBoard.position = ccp(0, 0);
    _chessBoard.whiteChessName = @"white-button-large.png";
    _chessBoard.blackChessName = @"black-button-large.png";
    _visableSize = size;
    _allTouches = [[NSMutableSet alloc] init];
    
    //Zoom in limit. You can't make the board smaller than the boardFrame
    //I assume the width and height is the same,
    //Use an animation to indicate what user can do on this board.
    _orgScale = _visableSize.width/_chessBoard.boundingBox.size.width;
    _movingCursor = [CCSprite spriteWithFile:@"board-move-sign.png"];
    _movingCursor.position = ccp(_visableSize.width/2, _visableSize.height/2);
    _movingCursor.visible = false;
    [self addChild:_chessBoard];
    [self addChild:_movingCursor];
    return self;
}

- (void) pinchEvent:(id)sender
{
    EZDEBUG(@"Pinch scale:%f", _pinchRecognizer.scale);
    //_pinchOngoing = false;
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
    _touchRegion = CGRectMake(self.position.x, self.position.y, _visableSize.width, _visableSize.height);
    
    CGRect gestureFrame = [EZTouchHelper convertGL2UI:_touchRegion];
    
    self.clippingRegion = _touchRegion;
    
    EZDEBUG(@"clippingRegion:%@, gestureFrame:%@", NSStringFromCGRect(self.clippingRegion), NSStringFromCGRect(gestureFrame));

    _gestureView = [[UIView alloc] initWithFrame:gestureFrame];
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchEvent:)];
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
    _gestureView.backgroundColor = [UIColor colorWithRed:0.4 green:0.3 blue:0.3 alpha:0.5]
    ;
    
    //[_gestureView addGestureRecognizer:_panRecognizer];

    //[_gestureView addGestureRecognizer:_pinchRecognizer];
    //[[CCDirector sharedDirector].view addSubview:_gestureView];
    [[CCDirector sharedDirector].view setMultipleTouchEnabled:YES];
    //Some magic number
    //What's the meaning of the priority
    //When would I use it?
    [[CCDirector sharedDirector].touchDispatcher addStandardDelegate:self priority:StandardTouchPriority];
    //_pinchRecognizer.delegate = self;
    //_panRecognizer.delegate = self;
    
}

- (void) onExit
{
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

//Only when pinch is accepted, I will accept pan.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    EZDEBUG("Gesturer should begin");
    if(gestureRecognizer == _pinchRecognizer){
        EZDEBUG(@"pinch");
        _pinchOngoing = true;
        return true;
    }else if(_pinchOngoing){
        EZDEBUG(@"Pan accept");
        return true;
    }
    EZDEBUG(@"Pan deny");
    return false;
}


// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
//Test how to simutneously recognize to gesturer.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    EZDEBUG(@"shouldRecognizerSimultaneously");
    return TRUE;
}

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
// The meaning is only when pinch is ongoing, I will allow the Pan to get the touch.
// Otherwise it will not get touch.
// The pinch will always get touch.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    EZDEBUG(@"Should recieve touch for:%@", (gestureRecognizer == _panRecognizer)?@"pan":@"pinch");
    _pinchOngoing = false;
    _isFirstPan = TRUE;
    /**
    if(gestureRecognizer == _panRecognizer){
        EZDEBUG(@"Recieved pan");
        if(_pinchOngoing){
            EZDEBUG(@"Accepted pan");
            return TRUE;
        }
        EZDEBUG(@"Deny pan");
    }else{
        //_pinchOngoing = TRUE;
        return TRUE;
    }
     **/
    return TRUE;
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
- (BOOL) checkAllWithin:(NSSet*)touches
{
    for(UITouch* touch in touches){
        CGPoint localPt = [self locationInSelf:touch];
        if(!CGRectContainsPoint(_touchRegion, localPt)){
            return false;
        }
    }
    return true;
}


- (void) setMoveBoard:(ccTime)timeCount
{
    
    if(_allTouches.count == 1 && [_allTouches containsObject:_movingTouch]){
        [_chessBoard ccTouchCancelled:_movingTouch withEvent:nil];
        _movingState = true;
        _isFirstPan = true;
        [self showMovingCursor];
    }
}

- (void) showMovingCursor
{
    _movingCursor.visible = true;
}
//Standard touch event
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"touch began new:%i", touches.count);
    [_allTouches addObjectsFromArray:touches.allObjects];
    _touchAccepted = false;
    _multiTouchAccepted = false;
    _movingCursor.visible = false;
    _movingState = false;
    UITouch* touch = [_allTouches anyObject];
    if(_allTouches.count > 1){
        //Cancel the _chessBoard cursor first.
        [_chessBoard ccTouchCancelled:touch withEvent:event];
        EZDEBUG(@"Will treat as move board");
        if([self checkAllWithin:touches]){
            EZDEBUG(@"will handle board move");
            [self handlePan:[touch locationInView:[CCDirector sharedDirector].view]];
            _multiTouchAccepted = TRUE;
        }
    }else{
        EZDEBUG(@"Original Resize board Touch begin");
        CGPoint localPt = [self locationInSelf:touch];
        _movingTouch = touch;
        
        if(CGRectContainsPoint(_touchRegion, localPt)){
            _touchAccepted = true;
            EZDEBUG(@"Unschedule get called");
            [_chessBoard ccTouchBegan:touch withEvent:event];
            [self schedule:@selector(setMoveBoard:) interval:2];
        }
        return;
    }
     
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch moved, touch count:%i, allTouches:%i", touches.count, _allTouches.count);
    UITouch* touch = [touches anyObject];
    
    if(_allTouches.count > 1 && _multiTouchAccepted){
        [self handlePan:[touch locationInView:[CCDirector sharedDirector].view]];
    }else{
        if(_touchAccepted){
            if(_movingState){
                EZDEBUG(@"will handle as pan");
                [self handlePan:[touch locationInView:[CCDirector sharedDirector].view]];
            }else{
                [_chessBoard ccTouchMoved:touch withEvent:event];
            }
        }
    }

}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch ended:%i", touches.count);
    _movingCursor.visible = false;
    //May add animation later.
    for(UITouch* touch in touches){
        [_allTouches removeObject:touch];
    }
    
    if(_touchAccepted){
        UITouch* touch = [touches anyObject];
        if(_movingState){
            EZDEBUG(@"Handle as pan");
            [self handlePan:[touch locationInView:[CCDirector sharedDirector].view]];
        }else{
            
            EZDEBUG(@"Accepted touch end");
            [_chessBoard ccTouchEnded:touch withEvent:event];
        }
    }else{
        EZDEBUG(@"Unaccepted touch end");
    }
    _touchAccepted = false;
    _movingState = false;
    //[self schedule:@selector(setBoardBack:) interval:1];
}

//Sometimes if the condication is more flexible, make the things easier 
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Cancel get called");
    _movingCursor.visible = false;
    _movingState = false;
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
