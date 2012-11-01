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
