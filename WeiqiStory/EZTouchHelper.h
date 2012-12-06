//
//  EZTouchHelper.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//Why do I need this class?
//I want to define method which hide the coordinator transformation.
//Just Paul Graham have told us, work from bottom up. 
//Tailor the language to make your life gradually easier.
//I guess Sprite can also sense the touch event, right?
@interface UITouch(EZWeiqi)

//Return the point in GL
- (CGPoint) locationInGL;

@end

@interface CCNode(EZWeiqi)

- (CGPoint) locationInSelf:(UITouch*)touch;

@end


@interface EZTouchHelper : NSObject

//Convert GL rectangular to UI rectangular
+ (CGRect) convertGL2UI:(CGRect)glRect;

//Convert UI rectangular to GL rectangular
+ (CGRect) convertUI2GL:(CGRect)uiRect;


+ (CGPoint) center:(CGRect)rect;

+ (CGRect) changeAnchor:(CGRect)orgRect orgAnchor:(CGPoint)orgAnchor changedAnchor:(CGPoint)changedAnchor;


//The position I will adjust to make the mover cover the covered.
//Naming is good, right?
//Ya, Ok, let's move to the implementation
+ (CGPoint) adjustRect:(CGRect)mover coveredRect:(CGRect)covered;


@end
