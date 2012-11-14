//
//  EZLimitMap.h
//  SqueezitProto
//
//  Created by Apple on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//What's my expectation for this class?
//It have Limited size, once the limit reached, will be FIFO.
@interface EZLRUMap : NSObject

@property (assign, nonatomic) NSInteger limit;


- (id) initWithLimit:(NSInteger)limit;

//Removed object as return
- (id) setObject:(id)obj forKey:(id)aKey;
- (id) removeObjectForKey:(id)aKey;
- (id) getObjectForKey:(id)aKey;
- (void) removeAllObjects;

//You will knew what is the most recently visited
- (id) recentlyVisited;

- (NSInteger) count;

@end
