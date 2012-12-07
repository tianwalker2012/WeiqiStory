//
//  EZClippingLayer.m
//  WeiqiStory
//
//  Created by xietian on 12-12-3.
//
//

#import "EZConstants.h"
#import "EZClippingNode.h"
#import "EZChess2Image.h"

@implementation EZClippingNode

- (id) initWithClippingRegion:(CGRect)rect
{
    self = [super init];
    _clippingRegion = rect;
    return self;
}


- (void) onEnter
{
    //CGRect beforeEnterRegion = self.boundingBox;
    [super onEnter];
    //_clippingRegion = self.boundingBox;
    //EZDEBUG(@"The before enter:%@ and after enter:%@", NSStringFromCGRect(beforeEnterRegion), NSStringFromCGRect(_clippingRegion));
    
}

- (void) visit
{
    //EZDEBUG(@"Visit get called:%@", [NSThread callStackSymbols]);
    
    //CGRect clipped = [EZChess2Image rectPointToPix:_clippingRegion];
    CGRect clipped = [EZChess2Image rectPointToPix:self.boundingBox];
    glEnable(GL_SCISSOR_TEST);
    glScissor(clipped.origin.x, clipped.origin.y,  clipped.size.width, clipped.size.height);
    
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}

//The possible problem could be that the GL coordinator didn't match the point in the screen.
//Let's test them carefully.
//Let's check the CCSprite code see what's the case with the sprite.
//Why call 2 times, what's the tricks behind it?
//This is very interesting.
- (void) draw
{
    //CGRect clipped = [EZChess2Image rectPointToPix:_clippingRegion];
    CGRect clipped = [EZChess2Image rectPointToPix:self.boundingBox];
    glEnable(GL_SCISSOR_TEST);
    glScissor(clipped.origin.x, clipped.origin.y,  clipped.size.width, clipped.size.height);
    [super draw];
}


@end
