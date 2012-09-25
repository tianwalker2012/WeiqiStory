//
//  EZMarkAction.h
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import "EZAction.h"
//What's my expectation for this action?
//Will plant a mark on the board.
//Currently, Will implement the Simplest way
//A label put on the board.
//Will have animation too.
@interface EZMarkAction : EZAction

@property (strong, nonatomic) NSMutableArray* marks;

@end
