//
//  EZAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import "EZAction.h"
#import "EZConstants.h"

@implementation EZAction
@synthesize actionType, preSetMoves, audioFiles, plantMoves, unitDelay, currentMove;
@synthesize currentAudio;

//get a copy of EZAction
//Why, because it carry the currentMove.
//I need the currentMove to to track all the things
- (EZAction*) clone
{
    EZAction* cloned = [[EZAction alloc] init];
    cloned.actionType = actionType;
    cloned.preSetMoves = preSetMoves;
    cloned.audioFiles = audioFiles;
    cloned.plantMoves = plantMoves;
    cloned.unitDelay = unitDelay;
    cloned.currentMove = currentMove;
    cloned.name = _name;
    return cloned;
}

- (void) dealloc
{
    EZDEBUG(@"dealloc:%@, pointer:%i",_name, (int)self);
}

@end
