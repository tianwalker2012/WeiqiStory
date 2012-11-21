//
//  EZLayer.h
//  WeiqiStory
//
//  Created by xietian on 12-11-15.
//
//

#import "CCLayer.h"
#import "EZConstants.h"

//Why do I need this 
@interface EZLayer : CCLayer


- (void) scheduleBlock:(EZOperationBlock) block interval:(ccTime)seconds repeat:(uint)repeat delay:(ccTime)delay;

@property (nonatomic, strong) EZOperationBlock scheduledBlock;

@end
