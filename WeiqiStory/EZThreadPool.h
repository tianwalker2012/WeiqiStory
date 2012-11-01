//
//  EZThreadPool.h
//  SqueezitProto
//
//  Created by Apple on 12-8-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZThreadPool : NSObject

//If you only need one thread for all the tasks
//This one is what you shoudl have.
+ (NSThread *) getWorkerGlobalThread;


//I need my own worker thread,
//It will generate a new thread for you.
//This is the right method to call. 
+ (NSThread *) createWorkerThread;

@end
