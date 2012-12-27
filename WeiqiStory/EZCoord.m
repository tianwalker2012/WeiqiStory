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

- (NSDictionary*) toDict
{
    return @{
        @"x":@(_x),
        @"y":@(_y),
        @"chessType":@(_chessType)
    };
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    //EZDEBUG(@"encodeWithCoder");
    [coder encodeInt:_x forKey:@"x"];
    [coder encodeInt:_y forKey:@"y"];
    [coder encodeInt:_chessType forKey:@"chessType"];
}



-(id)initWithCoder:(NSCoder *)decoder {
    //EZDEBUG(@"initWithCoder");
    _chessType = [decoder decodeIntForKey:@"chessType"];
    _x = [decoder decodeIntForKey:@"x"];
    _y = [decoder decodeIntForKey:@"y"];
    return self;
    
}

- (EZCoord*) initWithDict:(NSDictionary*)dict
{
    self = [super init];
    _chessType = ((NSNumber*)[dict objectForKey:@"chessType"]).intValue;
    _x = ((NSNumber*)[dict objectForKey:@"x"]).shortValue;
    _y = ((NSNumber*)[dict objectForKey:@"y"]).shortValue;
    return self;
}


@end
