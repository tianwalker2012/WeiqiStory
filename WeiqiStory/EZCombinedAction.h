//
//  DefaulAction.h
//  WeiqiStory
//
//  Created by xietian on 12-9-26.
//
//

#import "EZAction.h"
#import "EZConstants.h"

//What's the purpose of the defaul actions?
//The default actions will do to things,
//Use clean actions to clean all the staff.
//Then restore the default setting.
@interface EZCombinedAction : EZAction

@property(strong, nonatomic) NSArray* actions;

@property(strong, nonatomic) EZOperationBlock pauseBlock;

@end
