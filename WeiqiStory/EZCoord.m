//
//  EZBoardCoord.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZCoord.h"

@implementation EZCoord
@synthesize x, y;

- (id) init:(short)wd y:(short)ht
{
    self = [super init];
    if(self != nil){
        x = wd;
        y = ht;
    }
    
    return self;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"width:%i, height:%i",x ,y];
}

//Can be stored as a short or convert from short
+ (id) fromNumber:(short)val
{
    return [[EZCoord alloc] init:(val >> 8) y:val & 0xff];
}

- (short) toNumber
{
    return (x << 8) + y;
}

- (NSString*) getKey
{
    return [NSString stringWithFormat:@"%i", [self toNumber]];
}

@end
