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

@end
