//
//  EZChessNode.m
//  EZFirstFlex
//
//  Created by xietian on 12-12-23.
//  Copyright (c) 2012年 xietian. All rights reserved.
//

#import "EZChessNode.h"

@implementation EZChessNode

- (id) init
{
    self = [super init];
    _nodes = [[NSMutableArray alloc] init];
    self.type = kChessNode;
    return self;
}

//This is more robust?
- (NSString*) getProperty:(NSString*)prop
{
    for(EZSGFItem* item in _nodes){
        if([prop isEqualToString:item.name]){
            if(item.properties.count > 0){
                return [item.properties objectAtIndex:0];
            }else{
                return nil;
            }
        }
    }
    return nil;
}

@end
