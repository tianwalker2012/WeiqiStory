//
//  EZShowNumberAction.h
//  WeiqiStory
//
//  Created by xietian on 12-9-27.
//
//

#import "EZAction.h"

//What's the purpose of this action?
//It will record when to start showing the number for the button.

@interface EZShowNumberAction : EZAction

@property (nonatomic, assign) NSInteger curStartStep;
@property (nonatomic, assign) NSInteger preStartStep;
@property (nonatomic, assign) BOOL preShowStep;
@property (nonatomic, assign) BOOL curShowStep;

@end
