//
//  EZHttpListener.h
//  WeiqiStory
//
//  Created by xietian on 12-10-16.
//
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"

@interface EZHttpListener : NSObject<NSURLConnectionDataDelegate>

@property (strong, nonatomic) EZEventBlock connectBlock;
@property (strong, nonatomic) EZEventBlock resultBlock;

@end
