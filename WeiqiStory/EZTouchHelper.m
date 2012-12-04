//
//  EZTouchHelper.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTouchHelper.h"
#import "EZConstants.h"
@implementation EZTouchHelper

+ (CGRect) convertGL2UI:(CGRect)glRect
{
    CGPoint pos = [[CCDirector sharedDirector] convertToUI:glRect.origin];
    
    pos.y = pos.y - glRect.size.height;
    
    return CGRectMake(pos.x, pos.y, glRect.size.width, glRect.size.height);
}

//Convert UI rectangular to GL rectangular
+ (CGRect) convertUI2GL:(CGRect)uiRect
{
    CGPoint pos = [[CCDirector sharedDirector] convertToGL:uiRect.origin];
    
    pos.y = pos.y - uiRect.size.height;
    
    return CGRectMake(pos.x, pos.y, uiRect.size.width, uiRect.size.height);
}

@end

@implementation UITouch(EZWeiqi)


//Return the point in GL
- (CGPoint) locationInGL
{
    return [[CCDirector sharedDirector] convertToGL:[self locationInView:[CCDirector sharedDirector].view]];
}

- (CGPoint) locationInCool
{
    EZDEBUG(@"Position Name");
    return [[CCDirector sharedDirector] convertToGL:[self locationInView:self.view]];
    
}

- (CGPoint) locationInFunny
{
    EZDEBUG(@"Funny");
    return [[CCDirector sharedDirector] convertToGL:[self locationInView:self.view]];
    
}

@end


@implementation CCNode(EZWeiqi)

- (CGPoint) locationInSelf:(UITouch*)touch
{
    return [self convertToNodeSpace:[touch locationInGL]];
}

@end