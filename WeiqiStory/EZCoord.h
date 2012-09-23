//
//  EZBoardCoord.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZCoord : NSObject


@property(assign, nonatomic) short x;
@property(assign, nonatomic) short y;

- (id) init:(short)width y:(short)height;

//Can be stored as a short or convert from short
+ (id) fromNumber:(short)val;

- (short) toNumber;

- (NSString*) getKey;

@end
