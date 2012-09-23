//
//  EZBlockWrapper.h
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import <Foundation/Foundation.h>

typedef void (^CallBackBlock)();


//For some execution method didn't provide block
//Use this wrapper to simply the job
@interface EZBlockWrapper : NSObject


@property (strong, nonatomic) CallBackBlock block;

- (void) runBlock;

- (id) initWithBlock:(CallBackBlock)bk;

@end
