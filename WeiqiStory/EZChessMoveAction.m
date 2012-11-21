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


//Why do I undo the behavior?
//I undo it because, I want the board to have a consistent status
//It depends on which status the pause will be on?
//If it means this steps already completed or simpley 
- (void) pause:(EZActionPlayer*)player
{
    //Not the move stopped
    EZDEBUG(@"PlantMoveAction get called");
    [player stopPlayMoves];
    
    //clean the effects.
    [self undoAction:player];
    
    //Keep the status on board consistent
    [self fastForward:player];
}


- (void) undoAction:(EZActionPlayer*)player
{
    
    EZDEBUG(@"Will undo PlantMove Action, beginat:%i, startWith:%i, regret:%i", _beginStep, player.board.allSteps.count, (player.board.allSteps.count - _beginStep));
    //[player cleanActionMove:(player.board.allSteps.count - _beginStep)];
    [player.board regretSteps:player.board.allSteps.count - _beginStep animated:NO];
}


//For the subclass, override this method.
//I assume this will be ok. Let's try.
- (void) actionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"Will plant moves");
    EZChessMoveAction* cloned = (EZChessMoveAction*)[self clone];
    
    //I need to memorize the beginning steps, because I will in charge of the undo.
    //Cool.
    self.beginStep = player.board.allSteps.count;
    //self.beginStep = player.board.allSteps.count;
    [player playMoves:cloned completeBlock:self.nextBlock withDelay:cloned.unitDelay];
}

- (void) fastForward:(EZActionPlayer *)player
{
    EZDEBUG(@"board is:%@, moves count:%i", player.board, _plantMoves.count);
    [player.board putChessmans:_plantMoves animated:NO];
}

- (EZChessMoveAction*) clone
{
    EZChessMoveAction* cloned = [[EZChessMoveAction alloc] init];
    cloned.plantMoves = _plantMoves;
    cloned.currentMove = _currentMove;
    cloned.unitDelay = self.unitDelay;
    return cloned;
}

//Each action should override this method.
//Make sure itself could be recoverred and persisted fully without losing information.
- (NSDictionary*) actionToDict
{
    NSMutableDictionary* res = (NSMutableDictionary*)[super actionToDict];
    [res setValue:[self.class description] forKey:@"class"];
    [res setValue:[self coordsToArray:_plantMoves] forKey:@"plantMoves"];
    [res setValue:@(_currentMove) forKey:@"currentMove"];
    return res;
}

- (id) initWithDict:(NSDictionary*)dict
{
    self = [super initWithDict:dict];
    _plantMoves = [self arrayToCoords:[dict objectForKey:@"plantMoves"]];
    _currentMove  = ((NSNumber*)[dict objectForKey:@"currentMove"]).intValue;
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder:coder];
    //EZDEBUG(@"encodeWithCoder");
    [coder encodeObject:_plantMoves forKey:@"plantMoves"];
    ///[coder encodeObject:_currentMove ]
    [coder encodeInt:_currentMove forKey:@"currentMove"];
}




-(id)initWithCoder:(NSCoder *)decoder {
    //[super initWith]
    self = [super initWithCoder:decoder];
    _plantMoves = [decoder decodeObjectForKey:@"plantMoves"];
    //_currentMove = [decoder decodeIntForKey:@"currentMove"];
    return self;
    
}


@end
