//
//  EZStackPopAction.m
//  WeiqiStory
//
//  Created by xietian on 12-12-25.
//
//

#import "EZStackPopAction.h"
#import "EZActionPlayer.h"
#import "EZChessBoard.h"

@implementation EZStackPopAction


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
    EZDEBUG(@"Pop status");
    EZChessBoard* board = (EZChessBoard*)player.board;
    _curSnapshot = [board getSnapshot];
    _stackSnapshot = board.snapshotStack.lastObject;
    [board popStatus];
}


- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Undo action");
    EZChessBoard* board = (EZChessBoard*)player.board;
    [board playSnapshot:_curSnapshot];
    [board.snapshotStack addObject:_stackSnapshot];
}


@end
