//
//  EZCharMark.m
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import "EZCharMark.h"
#import "EZCoord.h"

@implementation EZCharMark

+ (id) create:(NSString*)content coord:(EZCoord*)coord
{
    EZCharMark* res = [[EZCharMark alloc] init];
    res.content = content;
    res.coord = coord;
    return res;
}

@end
