//
//  EZExtender.h
//  WeiqiStory
//
//  Created by xietian on 12-9-23.
//
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"
//This is a files which contain a bunch of extension I used to extend the functionality of the NSObject.


@interface NSObject(EZPrivate)

- (void) performBlock:(EZOperationBlock)block withDelay:(NSTimeInterval)delay;

- (void) executeBlock:(EZOperationBlock)block;

- (void) executeBlockInBackground:(EZOperationBlock)block inThread:(NSThread*)thread;

- (void) executeBlockInMainThread:(EZOperationBlock)block;

@end

