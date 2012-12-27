//
//  EZSimpleSGFParser.m
//  SGFParser
//
//  Created by xietian on 12-12-25.
//  Copyright (c) 2012年 xietian. All rights reserved.
//

#import "EZSimpleSGFParser.h"
#import "SGFLexer.h"
#import "EZSGFParser.h"
#import "EZConstants.h"
#import "EZParserStatus.h"

@implementation EZSimpleSGFParser

+ (EZChessNode*) parseSGFFull:(NSString*)fileName
{
    //Clean the status of previos node
    [EZParserStatus cleanStatus];
    EZChessNode* node = parseFullPath(fileName);
    //[self iterateNode:node];
    return node;
}

//Assume you give the relative bundle path.
+ (EZChessNode*) parseSGF:(NSString *)fileName
{
    NSString* fullPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"sgf"];
    EZDEBUG(@"Second FullPath is:%@, fileName:%@", fullPath, fileName);
    EZChessNode* node = parseFullPath(fullPath);
    //[self iterateNode:node];
    return node;
}

@end
