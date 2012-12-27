//
//  EZStackPushAction.h
//  WeiqiStory
//
//  Created by xietian on 12-12-25.
//
//

#import <Foundation/Foundation.h>
#import "EZAction.h"
//What's the purpose of this class?
//Store the current board status to the stack
//Later the StackPopAction will push the
//Status out.
//I need to have a boardStatus object.
//Which can simplify my operation a lot.
@interface EZStackPushAction : EZAction

@end
