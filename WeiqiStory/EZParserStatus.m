//
//  EZParserStatus.m
//  EZFirstFlex
//
//  Created by xietian on 12-12-24.
//  Copyright (c) 2012年 xietian. All rights reserved.
//

#import "EZParserStatus.h"
#import "EZConstants.h"

static EZParserStatus* instance = nil;

@implementation EZParserStatus
//Later will add multiple thread support
//Now let's just stick with the single thread cases
+ (EZParserStatus*) getInstance
{
    if(instance == nil){
        instance  = [[EZParserStatus alloc] init];
    }
    return instance;
}

//Will parse another file?
+ (void) cleanStatus
{
    instance = nil;
}

- (id) init
{
    self = [super init];
    _nodeStack = [[NSMutableArray alloc] init];
    return self;
}

+ (void) createChessNode
{
    
    EZParserStatus* status = [EZParserStatus getInstance];
    EZChessNode* chessNode = [[EZChessNode alloc] init];
    if(status.rootNode == nil){
        status.rootNode = chessNode;
    }
   
    if(status.nodeStack.count > 0){
        EZChessNode* parent = status.nodeStack.lastObject;
        [parent.nodes addObject:chessNode];
    }
    [status.nodeStack addObject:chessNode];
    
    EZDEBUG(@"Create a chessNode, current stack:%i", status.nodeStack.count);
}

+ (EZChessNode*) popChessNode
{
    EZChessNode* res = nil;
    EZParserStatus* status = [EZParserStatus getInstance];
    if(status.nodeStack.count > 0){
        res = [status.nodeStack lastObject];
        [status.nodeStack removeLastObject];
    }
    EZDEBUG(@"Remove chessNode, current stack:%i", status.nodeStack.count);
    return res;
    
}

+ (void) createNodeItem:(NSString*)nodeName
{
    EZDEBUG("Create NodeItem for name:%@", nodeName);
    EZParserStatus* status = [EZParserStatus getInstance];
    //EZDEBUG(@"status instance");
    EZChessNode* chessNode = status.nodeStack.lastObject;
    //EZDEBUG(@"chess node in stack");
    EZSGFItem* item = [[EZSGFItem alloc] init];
    item.name = nodeName;
    //EZDEBUG(@"Add chess node");
    [chessNode.nodes addObject:item];
    EZDEBUG(@"Complete add object");
}

+ (void) addNodeProperty:(NSString*)nodeProperty
{
    EZChessNode* chessNode = [EZParserStatus getInstance].nodeStack.lastObject;
    
    EZSGFItem* item = [chessNode.nodes lastObject];
    
    NSString* removed = [nodeProperty substringWithRange:NSMakeRange(1, nodeProperty.length -2)];
    EZDEBUG(@"Set Item name:%@, value:%@", item.name, removed);
    [item.properties addObject:removed];
}

@end
