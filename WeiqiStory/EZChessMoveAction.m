//
//  EZChessMoveAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-28.
//
//

#import "EZChessMoveAction.h"
#import "EZActionPlayer.h"


@implementation EZChessMoveAction

- (id) init
{
    self = [super init];
    self.syncType = kAsync;
    //self.actionType = kPlantMoves;
    return self;
}



- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Will undo PlantMove Action");
    [player cleanActionMove:_plantMoves];
}


//For the subclass, override this method.
//I assume this will be ok. Let's try.
- (void) actionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"Will plant moves");
    EZChessMoveAction* cloned = (EZChessMoveAction*)[self clone];
    [player playMoves:cloned completeBlock:self.nextBlock withDelay:cloned.unitDelay];
}

- (EZChessMoveAction*) clone
{
    EZChessMoveAction* cloned = [[EZChessMoveAction alloc] init];
    cloned.plantMoves = _plantMoves;
    cloned.currentMove = _currentMove;
    cloned.unitDelay = self.unitDelay;
    return cloned;
}


@end
