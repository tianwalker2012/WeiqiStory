//
//  EZProgressBar.h
//  WeiqiStory
//
//  Created by xietian on 12-11-1.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef void (^ EZBarChangedBlock)(NSInteger prv, NSInteger cur);


//Why don't I inheriate from the CCNode?
//Ya, Why not.
//First of all, let's see how to use it.
//Give it too images.
//It will try to determine it's dimension by the image I give to it.
//It will have maxValue
//It will have current value.
//It will have callback when the value changed.
//Should I provide the old value to the callback.
//Let's provide, you have the freedom not use it.
//Let's assume how to use it
//initWithNob:(CCSprite*)nob bar:(CCSprite*)bar maxValue:(NSIntger)vale changeBlock:^(){}
@interface EZProgressBar : CCNode<CCTargetedTouchDelegate>

- (id) initWithNob:(CCSprite*)nob bar:(CCSprite*)bar maxValue:(NSInteger)value changedBlock:(EZBarChangedBlock)changed;

//Whether to disable it or not.
@property (nonatomic, assign) BOOL disabled;

@property (nonatomic, assign) NSInteger currentValue;

@property (nonatomic, assign) NSInteger maxValue;

@property (nonatomic, strong) EZBarChangedBlock changedCallback;

//I will record the value which beginning of the touch event.
@property (nonatomic, assign) CGFloat prevPlayedValue;

//Will not accept touch if this value is false,
//Why?
//The processing will take a long time, if interruptted in the middle of the process the board will be inconsistent.
//So, I will not accept the touch event in the middle of the processing. 
@property (nonatomic, assign) BOOL acceptTouch;

@end
