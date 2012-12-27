//
//  EZChessNode.h
//  EZFirstFlex
//
//  Created by xietian on 12-12-23.
//  Copyright (c) 2012年 xietian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZSGFItem.h"
//What's the purpose of this class?
//This class represent the whole chess manual
//Or a variation in the chess manul, or so called sub chessmanual.
@interface EZChessNode : EZSGFItem

//I differentiate the nodes and other properties
@property (nonatomic, strong) NSMutableArray* nodes;

@end
