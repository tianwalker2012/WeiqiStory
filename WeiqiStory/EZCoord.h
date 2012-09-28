//
//  EZBoardCoord.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kDetermineByBoard =0,//Default value.
    kWhiteChess,
    kBlackChess
} EZChessmanSetType;

@interface EZCoord : NSObject


@property(assign, nonatomic) short x;
@property(assign, nonatomic) short y;
@property (assign, nonatomic) EZChessmanSetType chessType;

- (id) init:(short)width y:(short)height;

- (id) clone;

- (id) initChessType:(EZChessmanSetType)chessType x:(short)x y:(short)y;

//Can be stored as a short or convert from short
+ (id) fromNumber:(short)val;

- (short) toNumber;

- (NSString*) getKey;

@end
