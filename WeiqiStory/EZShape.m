//
//  EZShape.m
//  WeiqiStory
//
//  Created by xietian on 12-12-28.
//
//

#import "EZShape.h"
#import "cocos2d.h"
#import "EZConstants.h"


@implementation EZShape



- (id) init
{
    self = [super init];
    _lineWidth = 4;
    _lineColor = ccc4f(1, 0.8, 0.48, 1.0);
    return self;
}
//I assume this is a cube.
//So make it as simple as possible.
+ (NSArray*) calculateTriangle:(CGRect)box
{
    CGFloat length = box.size.height;
    
    //Mean 60 degree
    CGFloat angel = M_PI/6;
    CGFloat cosLength = cosf(angel) * length;
    CGFloat shift = (length - cosLength)*0.5;
    
    CGFloat highY = shift + cosLength;
    
    return @[[NSValue valueWithCGPoint:ccp(box.origin.x, box.origin.y + shift)], [NSValue valueWithCGPoint:ccp(box.origin.x+ length*0.5, box.origin.y + highY)], [NSValue valueWithCGPoint:ccp(box.origin.x + length, box.origin.y + shift)]];
    
}


- (void) draw
{
    //glEnable(GL_LINE_SMOOTH);
    glLineWidth(_lineWidth);
    
    NSArray* points = [EZShape calculateTriangle:self.boundingBox];
    
    EZDEBUG(@"BoundingBox is:%@", NSStringFromCGRect(self.boundingBox));
    
    NSValue* nv = [points objectAtIndex:0];
    CGPoint firstP = [nv CGPointValue];

    for(NSValue* val in points){
        if(nv != val){
            CGPoint startP = [nv CGPointValue];
            CGPoint endP = [val CGPointValue];
            ccDrawLine(startP, endP);
            nv = val;
        }
    }
    
    CGPoint last = [nv CGPointValue];
    ccDrawLine(last, firstP);
    [super draw];
    
}

@end
