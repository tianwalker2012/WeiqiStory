//
//  EZQueue.m
//  SqueezitProto
//
//  Created by Apple on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZQueue.h"

@interface EZQueue()
{
    NSMutableArray* queue;
}


@end

@implementation EZQueue
@synthesize limit;

- (id) initWithLimit:(NSInteger)lmt
{
    self = [super init];
    queue = [[NSMutableArray alloc] initWithCapacity:limit];
    limit = lmt;
    return self;
}
- (id) enqueue:(id)obj
{
    id res = nil;
    if(![queue containsObject:obj]){
        [queue addObject:obj];
    }
    if(queue.count > limit){
        res = [queue objectAtIndex:0];
        [queue removeObjectAtIndex:0];
    }
    return res;
}

//I assume isEqual will find the NSString is the same, even if they are not 
//The same object. Because, Key may not already the same object.
- (void) removeObject:(id)obj
{
    for(int i = 0; i< queue.count; i++){
        if([obj isEqual:[queue objectAtIndex:i]]){
            [queue removeObjectAtIndex:i];
        }
    }
}

//The key which visited most recently.
- (id) recentlyVisited
{
    if(queue.count == 0){
        return nil;
    }
    return [queue objectAtIndex:(queue.count - 1)];
}

- (BOOL) isContain:(id)obj
{
    for(id objIn in queue){
        if([objIn isEqual:obj]){
            return TRUE;
        }
    }
    return false;
}

- (void) removeAllObjects
{
    [queue removeAllObjects];
}

@end
