//
//  EZProgressBar.m
//  WeiqiStory
//
//  Created by xietian on 12-11-1.
//
//

#import "EZProgressBar.h"
#import "EZTouchHelper.h"
#import "EZConstants.h"

@interface EZProgressBar()
{
    //Touch will only be accepted, if it is locate in this box
    CGRect touchCheck;
    
    CGPoint prevTouch;
    
    CGPoint nobMovePrev;
    
    //The boundingBox of the nob.
    CCSprite* _nob;
    
    //How many move gap we would count as one more value.
    CGFloat _valueGap;
    //Pervent the Nob from move outside of the bar.
    //Devil in the detail
    CGFloat _nobPading;
}

@end

@implementation EZProgressBar

- (id) initWithNob:(CCSprite*)nob bar:(CCSprite*)bar maxValue:(NSInteger)value changedBlock:(EZBarChangedBlock)changed
{
    self = [super init];
    
    CGRect boxNob = nob.boundingBox;
    
    _nob = nob;
    
    _maxValue = value;
    
    _changedCallback = changed;
    
    CGRect boxBar = bar.boundingBox;
    
    CGFloat width = max(boxNob.size.width, boxBar.size.width);
    CGFloat height = max(boxNob.size.height, boxBar.size.height);
    self.contentSize = CGSizeMake(width, height);
    touchCheck = CGRectMake(0, 0, width, height);
    
    //This is used to calculate the position for the Nob.
    //Position, mean for the node not played. So that the last node is just an indication of end.
    _valueGap = (self.contentSize.width - _nob.boundingBox.size.width)/_maxValue;
    
    _nobPading = _nob.boundingBox.size.width/2;
    
    self.currentValue = 0;//start from the initial position
    
    //EZDEBUG(@"Touch Check Rect is:%@", NSStringFromCGRect(touchCheck));
    
    nob.position = ccp(boxNob.size.width/2, height/2);
    bar.position = ccp(boxBar.size.width/2, height/2);
    
    [self addChild:bar z:1];
    //Make sure the nob is above the bar
    [self addChild:nob z:2];
    _disabled = false;
    
    return self;
    
}

- (void) onEnter
{
    EZDEBUG(@"onEnter get called");
    if(!_disabled){
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
    }
}

- (void) onExit
{
    EZDEBUG(@"onExit get called");
    if(!_disabled){
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }
}


//I want to make this can be tested independently.
//Without GUI.
//Do this when encounter issue ok.
- (NSInteger) calcValueForDelta:(CGFloat)delta
{
    //No zero division protection.
    //Will move to the larger or smaller value
    //Attract the the nearest value, adjust the sentivity level, the higher the more sensitivity it is
    int sensitiveLevel = 2;
    if(abs(delta) >= (_valueGap/sensitiveLevel) && abs(delta) < _valueGap){
        if(delta > 0){
            delta = _valueGap;
        }else{
            delta = -_valueGap;
        }
    }
    
    NSInteger added = (NSInteger)(delta/_valueGap);
    
    NSInteger newValue = _currentValue + added;
    
    //EZDEBUG(@"added:%i, delta:%f, valueGap:%f, newValue:%i maxValue:%i", added, delta, _valueGap, newValue, _maxValue);
    
    if(newValue > _maxValue){
        newValue = _maxValue;
    }else if(newValue < 0){
        newValue = 0;
    }
    return newValue;
}

- (void) setCurrentValue:(NSInteger)currentValue
{
    if(currentValue < 0){
        currentValue = 0;
    }else if(currentValue > _maxValue){//Bug was here
        currentValue = _maxValue;
    }
    
    if(_currentValue == currentValue){
        return;
    }
    _currentValue = currentValue;
    _nob.position = [self positionForValue:currentValue];

}

//Cacluate the position of nob for the new value
- (CGPoint) positionForValue:(NSInteger)value
{
    //_valueGap = (touchCheck.size.width - _nob.boundingBox.size.width)/_maxValue;
    CGFloat posX = _nobPading + value * _valueGap;
    return ccp(posX, self.contentSize.height/2);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint locPt = [self locationInSelf:touch];
    //Make the touch box larger than it suppose to be.
    CGRect nobBox = CGRectInset(_nob.boundingBox, -10, -10);
    //EZDEBUG(@"LocalPoint:%@, rect is:%@", NSStringFromCGPoint(locPt), NSStringFromCGRect(nobBox));
    
    if(!CGRectContainsPoint(nobBox, locPt)){
        EZDEBUG(@"Deny touch event. nobBox:%@, locationPoint:%@", NSStringFromCGRect(nobBox), NSStringFromCGPoint(locPt));
        return false;
    }
    EZDEBUG(@"Accept the touch event");
    prevTouch = locPt;
    nobMovePrev = locPt;
    return true;
}


- (void) adjustNobPosition:(CGFloat) deltaMove
{
    CGFloat begin = _nob.boundingBox.size.width/2;
    CGFloat end = self.contentSize.width - _nob.boundingBox.size.width/2;
    
    CGFloat movedX = _nob.position.x + deltaMove;
    
    EZDEBUG(@"movedX:%f, begin:%f, end:%f, deltaMove:%f", movedX, begin, end, deltaMove);
    
    if(movedX < begin){
        movedX = begin;
    }else if(movedX > end){
        movedX = end;
    }
   
    _nob.position = ccp(movedX, _nob.position.y);
}
// touch updates:
//Only when the touch get accepted, this method will get called.
//So we can move the nob freely.
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint curPt = [self locationInSelf:touch];
    
    CGFloat delta = curPt.x - prevTouch.x;
    CGFloat deltaMove = curPt.x - nobMovePrev.x;
    //Make the nob move with my drag activity.
    [self adjustNobPosition:deltaMove];
    
    nobMovePrev = curPt;
    
    NSInteger newValue = [self calcValueForDelta:delta];
    
    EZDEBUG(@"curPt:%@, prevPt:%@, newValue:%i, _curentValue:%i",NSStringFromCGPoint(curPt), NSStringFromCGPoint(prevTouch), newValue, _currentValue);
    
    
    if(newValue != _currentValue){
        //EZDEBUG(@"change value");
        if(_changedCallback){
            _changedCallback(_currentValue, newValue);
        }
        //will change the nob position accordingly
        self.currentValue = newValue;
        prevTouch = curPt;
    }
    //prevTouch = curPt;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //[self ccTouchMoved:touch withEvent:event];
    //self.currentValue = _currentValue;
    //Position to proper position
    _nob.position = [self positionForValue:_currentValue];
    EZDEBUG(@"Touch ended");
}
//When this will be get called?
//Should I treat it with the previous value?
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

@end
