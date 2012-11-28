//
//  EZThreadPool.h
//  SqueezitProto
//
//  Created by Apple on 12-8-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"


@interface EZThreadPool : NSObject

//If you only need one thread for all the tasks
//This one is what you shoudl have.
+ (NSThread *) getWorkerGlobalThread;


+ (EZThreadPool*) getInstance;

//I need my own worker thread,
//It will generate a new thread for you.
//This is the right method to call. 
+ (NSThread *) createWorkerThread;

//The first step to adopt to GCD
- (void) executeBlockInQueue:(EZOperationBlock)block;

- (void) executeBlockInQueue:(EZOperationBlock)block isConcurrent:(BOOL)concurrent;

@property (nonatomic, assign) dispatch_queue_t serialQueue;
@property (nonatomic, assign) dispatch_queue_t concurQueue;


@end
