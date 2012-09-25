//
//  EZCleanAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import "EZCleanAction.h"
#import "EZChessBoard.h"
#import "EZActionPlayer.h"

@implementation EZCleanAction

- (id) init
{
    self = [super init];
    self.actionType = kCleanBoard;
    return self;
}


- (EZAction*) clone
{
    EZCleanAction* cloned = [[EZCleanAction alloc] init];
    cloned.preSetMoves = self.preSetMoves;
    return cloned;
}

//Currently will store all current moves in the board will recover them when get undo.
- (void) actionBody:(EZActionPlayer*)player
{
    //Will be EZCoord.
    //Should we store the color?
    //Modify it when it is necessary.
    //Kiss, is my life blood.
    if(self.actionType == kPlantMarks){
        [player.board cleanAllM]
    }else{
        self.preSetMoves = [player.board getAllChessMoves];
        EZDEBUG(@"preSetMoves:%i",self.preSetMoves.count);
        [player.board cleanAllMoves];
    }
}


- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Time to recover all cleaned staff back, moves counts:%i", self.preSetMoves.count);
    if(self.preSetMoves){
        [player.board putChessmans:self.preSetMoves animated:NO];
    }
}

@end
