//
//  EZShape.h
//  WeiqiStory
//
//  Created by xietian on 12-12-28.
//
//

#import "CCNode.h"
#import <math.h>
typedef enum {
    kShapeTriangle,
    kShapeCycle,
    kShapeRectangle
} EZShapeType;

@interface EZShape : CCNode

@property (nonatomic, assign) EZShapeType type;
@property (nonatomic, assign) ccColor4F lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

+ (NSArray*) calculateTriangle:(CGRect)box;

@end
