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


+ (CGPoint) center:(CGRect)rect
{
    return CGPointMake(rect.origin.x + 0.5*rect.size.width, rect.origin.y + 0.5*rect.size.height);
}

//Let change the anchor accordingly. 
+ (CGRect) changeAnchor:(CGRect)orgRect orgAnchor:(CGPoint)orgAnchor changedAnchor:(CGPoint)changedAnchor
{
    EZDEBUG(@"Orginal anchor:%@, changedAnchor:%@, orgRect:%@", NSStringFromCGPoint(orgAnchor), NSStringFromCGPoint(changedAnchor), NSStringFromCGRect(orgRect));
    CGFloat deltaAnchorX = changedAnchor.x - orgAnchor.x;
    CGFloat deltaAnchorY = changedAnchor.y - orgAnchor.y;
    CGFloat changePosX = orgRect.origin.x + deltaAnchorX*orgRect.size.width;
    CGFloat changePosY = orgRect.origin.y + deltaAnchorY*orgRect.size.height;
    return  CGRectMake(changePosX, changePosY, orgRect.size.width, orgRect.size.height);
}


//The position I will adjust to make the mover cover the covered.
//Naming is good, right?
//Ya, Ok, let's move to the implementation
+ (CGPoint) adjustRect:(CGRect)mover coveredRect:(CGRect)covered
{
    //The caller will make sure the mover is larger than the covered, otherwise, I can not do anything about it.
    assert((mover.size.width >= covered.size.width) && (mover.size.height >= covered.size.height));
    CGPoint res = mover.origin;
    
    if(mover.origin.x > covered.origin.x){
        res.x = covered.origin.x;
    }
    if(mover.origin.y > covered.origin.y){
        res.y = covered.origin.y;
    }
    
    CGFloat moverWidth = res.x + mover.size.width;
    CGFloat moverHeight = res.y + mover.size.height;

    CGFloat moverDeltaX = moverWidth - covered.origin.x - covered.size.width;
    CGFloat moverDeltaY = moverHeight - covered.origin.y - covered.size.height;

    if(moverDeltaX < 0){
        res.x -= moverDeltaX;
    }

    if(moverDeltaY < 0){
        res.y -= moverDeltaY;
    }

    EZDEBUG(@"mover:%@, covered:%@, adjusted point:%@", NSStringFromCGRect(mover), NSStringFromCGRect(covered), NSStringFromCGPoint(res));
    return res;

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