//
//  EZStackPushAction.m
//  WeiqiStory
//
//  Created by xietian on 12-12-25.
//
//

#import "EZStackPushAction.h"
#import "EZActionPlayer.h"
#import "EZChessBoard.h"

@implementation EZStackPushAction


- (id) init
{
    self = [super init];
    self.syncType = kSync;
    return self;
}
//Currently will store all current moves in the board will recover them when get undo.
- (void) actionBody:(EZActionPlayer*)player
{
    //Will be EZCoord.
    //Should we store the color?
    //Modify it when it is necessary.
    //Kiss, is my life blood.
    EZDEBUG(@"Push status");
    EZChessBoard* board = (EZChessBoard*)player.board;
    [board pushStatus];
}


- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Undo action");
    EZChessBoard* board = (EZChessBoard*)player.board;
    [board popStatusWithoutApplying];
}


@end
