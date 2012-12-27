//
//  EZResponsiveRegion.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZResponsiveRegion.h"
#import "EZTouchHelper.h"
#import "EZConstants.h"


//Make sure the normal will be covered by the pressed. 
#define normalZOrder  1
#define pressedZOrder  2

@interface EZResponsiveRegion()


@end



@implementation EZResponsiveRegion
@synthesize active, normal, pressed, inactive, pressedOps, center;

-(id)initWithRect:(CGRect)rect{
	self = [super init];
	if(self){
		bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
		center = CGPointMake(rect.size.width/2, rect.size.height/2);
		position_ = rect.origin;
        active = true;
	}
	return self;
}
- (void) setNormal:(CCSprite *)nm
{
    normal = nm;
    [normal setZOrder:normalZOrder];
}

- (void) setPressed:(CCSprite *)pd
{
    pressed = pd;
    [pressed setZOrder:pressedZOrder];
}

//When this will get called
//I guess swallow will not allow it parents to get the event.
//When will the onEnterTransition Method get called?
//Will this get called on like the viewWillDisplay on the UIVIew controller?
//Don't assume this will happen, one simple test will prove this.
- (void) onEnterTransitionDidFinish
{
    EZDEBUG(@"onEnterTransitionDidFinish");
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:YES];
}


- (void) onExit
{
    EZDEBUG(@"onExit");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

- (void) setActive:(BOOL)ac
{
    if(ac){
        [current removeFromParentAndCleanup:YES];
        current = normal;
    }else{
        [current removeFromParentAndCleanup:YES];
        current = inactive;
    }
    [self addChild:current];
}


//What's the purpose of this method?
//Check if the point are in this region. 
- (BOOL) regionCheck:(UITouch*) touch
{
    CGPoint selfPoint = [self locationInSelf:touch];
    //EZDEBUG(@"global:%@ , selfPoint:%@, Bounds:%@",NSStringFromCGPoint(globalPoint), NSStringFromCGPoint(selfPoint), NSStringFromCGRect(bounds));
    if(selfPoint.x > bounds.origin.x && selfPoint.x < bounds.size.width){
        if(selfPoint.y > bounds.origin.y && selfPoint.y < bounds.size.height){
            //EZDEBUG(@"Fall in the region");
            return TRUE;
        }
    }
    //EZDEBUG(@"Fall out of region");
    return FALSE;
}

//Why need to return yes or no
//Return YES mean I didn't handle this event, give it to next handler.
//No Mean I processed, Give it to me
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    EZDEBUG(@"Get called");
    if(![self regionCheck:touch]){
        return NO;
    }
    //EZDEBUG(@"After region check, pressed:%i", (int)pressed);
	if (active) {
        [self addChild:pressed];
    }
    //EZDEBUG(@"After add child");
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
	if (!active) return;
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
	if (!active) return;
    EZDEBUG(@"Ended get called, remove pressed");
    [pressed removeFromParentAndCleanup:YES];
    if(pressedOps){
        pressedOps();
    }
	
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    EZDEBUG(@"Cancelled");
    [pressed removeFromParentAndCleanup:YES];
	//[self ccTouchEnded:touch withEvent:event];
}



@end

