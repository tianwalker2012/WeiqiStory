//
//  EZButtonPosition.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZChessPosition.h"

@implementation EZChessPosition
@synthesize coord, isBlack, step, eaten, removedChess;

- (id) initWithCoord:(EZCoord*)cd isBlack:(BOOL)blk step:(NSInteger)stp
{
    self = [super init];
    if(self){
        coord = cd;
        isBlack = blk;
        step = stp;
        eaten = false;
        removedChess = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
