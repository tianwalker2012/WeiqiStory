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


@end
