//
//  EZStackPopAction.h
//  WeiqiStory
//
//  Created by xietian on 12-12-25.
//
//

#import <Foundation/Foundation.h>
#import "EZAction.h"

@class EZBoardSnapshot;
@interface EZStackPopAction : EZAction

//the snapshot used for undo
@property (nonatomic, strong) EZBoardSnapshot* curSnapshot;

//the snapshot I will insert back
@property (nonatomic, strong) EZBoardSnapshot* stackSnapshot;

@end
