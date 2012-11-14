//
//  EZQueue.h
//  SqueezitProto
//
//  Created by Apple on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZQueue : NSObject

@property (assign, nonatomic) NSInteger limit;


- (id) initWithLimit:(NSInteger)limit;
- (id) enqueue:(id)obj;
- (BOOL) isContain:(id)obj;
- (void) removeAllObjects;
- (void) removeObject:(id)obj;

//The key which visited most recently.
- (id) recentlyVisited;

@end
