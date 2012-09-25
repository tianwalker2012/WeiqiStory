//
//  EZChessMark.m
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import "EZChessMark.h"

@implementation EZChessMark

- (id) initWithNode:(CCNode*)mark coord:(EZCoord*)coord
{
    self = [super init];
    _mark = mark;
    _coord = coord;
    return self;
}

@end
