//
//  EZExtender.m
//  WeiqiStory
//
//  Created by xietian on 12-9-23.
//
//

#import "EZExtender.h"


@interface BlockCarrier : NSObject

@property (strong, nonatomic) EZOperationBlock block;

- (id) initWithBlock:(EZOperationBlock)block;

- (void) runBlock;

@end




@implementation NSObject(EZPrivate)

- (void) performBlock:(EZOperationBlock)block withDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(executeBlock:) withObject:block afterDelay:delay];
}

- (void) executeBlock:(EZOperationBlock)block
{
    if(block){
        block();
    }
}

//If Most of the time it is ok
- (void) executeBlockInBackground:(EZOperationBlock)block inThread:(NSThread *)thread
{
    //[EZTaskHelper executeBlockInBG:block];
    //BlockCarrier* bc = [[BlockCarrier alloc] initWithBlock:block];
    if(thread == nil){
        [self performSelectorInBackground:@selector(executeBlock) withObject:block];
    }else{
        [self performSelector:@selector(executeBlock:) onThread:thread withObject:block waitUntilDone:NO];
    }
}

//Polish the code whenever you could. 
- (void) executeBlockInMainThread:(EZOperationBlock)block
{
    [self performSelectorOnMainThread:@selector(executeBlock:) withObject:block waitUntilDone:NO];
}

@end
