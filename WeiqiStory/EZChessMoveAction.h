//
//  EZChessMoveAction.h
//  WeiqiStory
//
//  Created by xietian on 12-9-28.
//
//

#import "EZAction.h"

@interface EZChessMoveAction : EZAction

@property (strong, nonatomic) NSArray* plantMoves;
@property (assign, nonatomic) NSInteger currentMove;

//If I have to undo myself,
//I only clean up to the beginSteps.
//Why?
//Because I may get aborted right in the middle of things.
@property (assign, nonatomic) NSInteger beginStep;


@end
