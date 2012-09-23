//
//  EZBlockWrapper.m
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import "EZBlockWrapper.h"

@implementation EZBlockWrapper
@synthesize block;

- (id) initWithBlock:(CallBackBlock)bk
{
    self = [super init];
    block = bk;
    return self;
}

- (void) runBlock
{
    if(block){
        block();
    }
}

@end
