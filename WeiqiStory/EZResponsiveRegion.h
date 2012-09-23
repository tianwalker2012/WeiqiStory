//
//  EZResponsiveRegion.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "EZConstants.h"

//Why do I pick a ugly name like this?
//Because I used Button as the name for qi zi. 
//Time to correct this error, right. 
//Or it will make things worser in the future. 
//Fix it now. 
//Initially, I think layer could help me achieve this.
//Then It turns out, Region could not. 
//What I need actually is the a responsive region.
//Then I could put a button, or a chess board or other things
//I use targeted touch delegate because this could simplify the mutliple touch process. 
//What if I want process multiple touch?
//Let's address this later. 
//Collect the low hanging fruit first. 
@interface EZResponsiveRegion : CCNode<CCTargetedTouchDelegate>
{
    CGRect bounds;
    //CGPoint center;
    CCSprite* current;
}


@property (assign, nonatomic) BOOL active;
@property (readonly, nonatomic) CGPoint center;

//Let it grow organically. 
//We can use animation to make the effects better, right?
//Ya, Let's keep it simple and stupid. 
//Add the animation later. 
@property (strong, nonatomic) CCSprite* normal;
@property (strong, nonatomic) CCSprite* pressed;
@property (strong, nonatomic) CCSprite* inactive;
@property (strong, nonatomic) EZOperationBlock pressedOps;


- (id) initWithRect:(CGRect)rect;

//What's the purpose of this method?
//Check if the point are in this region. 
- (BOOL) regionCheck:(UITouch*) touch;

@end
