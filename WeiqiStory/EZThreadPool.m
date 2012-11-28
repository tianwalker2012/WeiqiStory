//
//  EZThreadPool.m
//  SqueezitProto
//
//  Created by Apple on 12-8-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZThreadPool.h"

//Why I create this thread pool,
//I have a very specific problem to address. 
//If multiple thread access the core data API will cause the dead lock.
//So what should we do?
//Move them to the same background thread, It have no chance to deadlock.


static EZThreadPool* sharedPool;

@implementation EZThreadPool

+ (void) createWorker:(id)__unused object {
    do {
        @autoreleasepool{
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

//This code just copied from the TapKuLibrary.
//Why not just use it directly. Not necessary.
//Only this part is what I need.
+ (NSThread *) getGlobalWorkerThread {
    static NSThread *_workerThread = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _workerThread = [[NSThread alloc] initWithTarget:self selector:@selector(createWorker:) object:nil];
        [_workerThread start];
    });
    
    return _workerThread;
}

//I need my own worker thread,
//It will generate a new thread for you.
//This is the right method to call.
+ (NSThread *) createWorkerThread
{
    NSThread* res = nil;
    res = [[NSThread alloc] initWithTarget:self selector:@selector(createWorker:) object:nil];
    [res start];
    return res;
}

- (id) init
{
    self = [super init];
    _serialQueue = dispatch_queue_create("my_queue_serial", DISPATCH_QUEUE_SERIAL);
    _concurQueue = dispatch_queue_create("my_queue_concur", DISPATCH_QUEUE_CONCURRENT);
    return self;
}

+ (EZThreadPool*) getInstance
{
    if(sharedPool == nil){
        sharedPool = [[EZThreadPool alloc] init];
    }
    
    return sharedPool;
}
//This is for the task not blocking.
//Concurrent mean I hope nothing block in my way.
//System will fork a new thread to process your request if something block in your way.
- (void) executeBlockInQueue:(EZOperationBlock)block  isConcurrent:(BOOL)concurrent
{
    if(concurrent){
        dispatch_async(_concurQueue, block);
    }else{
        dispatch_async(_serialQueue, block);
    }    
}


//
- (void) executeBlockInQueue:(EZOperationBlock)block
{
    [self executeBlockInQueue:block isConcurrent:NO];
}

@end
