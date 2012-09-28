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

@interface EZCleanAction()
{
    NSArray* cleanedMarks;
}

@end

@implementation EZCleanAction

- (id) init
{
    self = [super init];
    //self.actionType = kCleanBoard;
    self.syncType = kSync;
    return self;
}


- (EZAction*) clone
{
    EZCleanAction* cloned = [[EZCleanAction alloc] init];
    cloned.cleanedMoves = self.cleanedMoves;
    cloned.cleanedMarks = self.cleanedMarks;
    return cloned;
}

//Currently will store all current moves in the board will recover them when get undo.
- (void) actionBody:(EZActionPlayer*)player
{
    //Will be EZCoord.
    //Should we store the color?
    //Modify it when it is necessary.
    //Kiss, is my life blood.
    EZDEBUG(@"Clean the board");
    if(_cleanType == kCleanMarks){
        [player.board cleanAllMarks];
        _cleanedMarks = player.board.allMarks;
    }else if(_cleanType == kCleanChessman){
        _cleanedMoves = [player.board getAllChessMoves];
        EZDEBUG(@"cleaned Moves:%i",_cleanedMoves.count);
        [player.board cleanAllMoves];
    }else{
        //cleanedMarks = player.board.
        EZDEBUG(@"clean All get called");
        _cleanedMarks = player.board.allMarks;
        [player.board cleanAllMarks];
        self.cleanedMoves = [player.board getAllChessMoves];
        [player.board cleanAllMoves];
    }
}


- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Time to recover, chessman count:%i", self.cleanedMoves.count);
    if(self.cleanedMoves.count > 0){
        [player.board putChessmans:self.cleanedMoves animated:NO];
    }
    //Have have cleaned Marks. let's plant them back.
    if(_cleanedMarks.count > 0){
        //[player.board putCharMark:<#(NSString *)#> fontSize:<#(NSInteger)#> coord:<#(EZCoord *)#> animAction:<#(CCAction *)#>]
    }
}

@end
