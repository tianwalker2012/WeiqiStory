//
//  EZButtonPosition.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EZCoord;
//This class represent a button played.
//It may on the board or removed from the board.
@interface EZChessPosition : NSObject

//At which step it is played
@property (assign, nonatomic) NSInteger step;

//Is it black.
//Actually this is duplicated data, 
//According to it's steps we could get things out.
//But we just make things simple and easier.
//So no perfectionism, only pragamtic solutions
@property (assign, nonatomic) BOOL isBlack;

//Which position it on the board
@property (strong, nonatomic) EZCoord* coord;

//Check if it get eaten or not
@property (assign, nonatomic) BOOL eaten;

//All the Chessman removed by this
@property (strong, nonatomic) NSMutableArray* removedChess;

- (id) initWithCoord:(EZCoord*)cd isBlack:(BOOL)blk step:(NSInteger)stp;

@end
