//
//  EZBoardCoord.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZCoord.h"

@implementation EZCoord


- (id) clone
{
    EZCoord* res = [[EZCoord alloc] initChessType:_chessType x:_x y:_y];
    return res;
}

- (id) initChessType:(EZChessmanSetType)chessType x:(short)x y:(short)y
{
    self = [super init];
    _x = x;
    _y = y;
    _chessType = chessType;
    return self;
}

- (id) init:(short)x y:(short)y
{
    return [self initChessType:kDetermineByBoard x:x y:y];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"width:%i, height:%i",_x ,_y];
}

//Can be stored as a short or convert from short
+ (id) fromNumber:(short)val
{
    return [[EZCoord alloc] init:(val >> 8) y:val & 0xff];
}

- (short) toNumber
{
    return (_x << 8) + _y;
}

- (NSString*) getKey
{
    return [NSString stringWithFormat:@"%i", [self toNumber]];
}

@end
