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

- (id) initWithText:(NSString*)text fontSize:(NSInteger)fontSize coord:(EZCoord*)coord 
{
    self = [super init];
    _text = text;
    _coord = coord;
    _fontSize = fontSize;
    return self;
}

@end
