//
//  EZShapeMarkAction.h
//  WeiqiStory
//
//  Created by xietian on 12-12-28.
//
//

#import "EZAction.h"
#import "EZShape.h"


@class EZCoord;
@interface EZShapeMarkAction : EZAction

@property (nonatomic, assign) EZShapeType shapeType;

@property (nonatomic, strong) NSArray* coords;
@end
