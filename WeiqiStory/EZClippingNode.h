//
//  EZClippingLayer.h
//  WeiqiStory
//
//  Created by xietian on 12-12-3.
//
//

#import "CCNode.h"

@interface EZClippingNode : CCNode

- (id) initWithClippingRegion:(CGRect)rect;

@property (nonatomic, assign) CGRect clippingRegion;

@end
