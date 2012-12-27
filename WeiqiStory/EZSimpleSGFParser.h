//
//  EZSimpleSGFParser.h
//  SGFParser
//
//  Created by xietian on 12-12-25.
//  Copyright (c) 2012年 xietian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZChessNode.h"
#import "EZSGFItem.h"

@interface EZSimpleSGFParser : NSObject

//Assume you give the full path
+ (EZChessNode*) parseSGFFull:(NSString*)fileName;

//Assume you give the relative bundle path.
+ (EZChessNode*) parseSGF:(NSString *)fileName;

@end
