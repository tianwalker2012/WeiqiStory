//
//  EZLayer.m
//  WeiqiStory
//
//  Created by xietian on 12-11-15.
//
//

#import "EZLayer.h"

@implementation EZLayer

- (id) init
{
    self = [super init];
    return self;
}

- (void) innerSchedule:(ccTime)time
{
    if(_scheduledBlock){
        _scheduledBlock();
    }
}

- (void) scheduleBlock:(EZOperationBlock) block interval:(ccTime)seconds repeat:(uint)repeat delay:(ccTime)delay
{
    self.scheduledBlock = block;
    [self schedule:@selector(innerSchedule:) interval:seconds repeat:repeat delay:delay];
}


@end
