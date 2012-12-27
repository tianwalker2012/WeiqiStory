//
//  EZParserStatus.h
//  EZFirstFlex
//
//  Created by xietian on 12-12-24.
//  Copyright (c) 2012年 xietian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZChessNode.h"

typedef enum {
    kParseOther,
    kParseNodeContent
} ParseStatus;

@interface EZParserStatus : NSObject

+ (EZParserStatus*) getInstance;

//Will parse another file?
+ (void) cleanStatus;

//Create a new ChessNode in the stock
+ (void) createChessNode;

+ (EZChessNode*) popChessNode;

+ (void) createNodeItem:(NSString*)nodeName;

+ (void) addNodeProperty:(NSString*)nodeProperty;


//@property (nonatomic, assign) NSInteger status;

//What's the purpose of this, act as a stack for current chess node.
@property (nonatomic, strong) NSMutableArray* nodeStack;

@property (nonatomic, strong) EZChessNode* rootNode;

@end
