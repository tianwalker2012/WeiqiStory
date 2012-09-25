//
//  EZAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import "EZAction.h"
#import "EZConstants.h"
#import "EZActionPlayer.h"

@implementation EZAction

//get a copy of EZAction
//Why, because it carry the currentMove.
//I need the currentMove to to track all the things
- (EZAction*) clone
{
    EZAction* cloned = [[EZAction alloc] init];
    cloned.actionType = _actionType;
    cloned.preSetMoves = _preSetMoves;
    cloned.audioFiles = _audioFiles;
    cloned.plantMoves = _plantMoves;
    cloned.unitDelay = _unitDelay;
    cloned.currentMove = _currentMove;
    cloned.name = _name;
    return cloned;
}

- (void) dealloc
{
    EZDEBUG(@"dealloc:%@, pointer:%i",_name, (int)self);
}


//After refractoring it.
//the code is much more clean and more understandable to me. 
- (void) doAction:(EZActionPlayer*)player
{
    CallbackBlock block = ^(){
        if(player.playingStatus == kPlaying){
            [player resume];
        }else{
            [player stepCompleted];
        }
    };
    EZAction* cloned = [self clone];
    
    switch (_actionType) {
        case kPreSetting:
            [player.board putChessmans:_preSetMoves animated:NO];
            block();
            break;
            
        case kLectures:{
           
            [player playSound:cloned completeBlock:block];
            break;
            
        }
        case kPlantMoves:{
            cloned.currentMove = 0;
            [player playMoves:cloned completeBlock:block withDelay:cloned.unitDelay];
            break;
        }
        default:{
            //EZAction* cloned = [self clone];
            //Whether we need to use cloned version, this decision should maked by the Action subclass itself.
            [self actionBody:player];
            block();
            break;
        }
    }

}

- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Will undo action for type:%i,name:%@",_actionType, _name);
    switch (_actionType) {
        case kPreSetting:{
            [player cleanActionMove:_preSetMoves];
            break;
        }
            
        case kPlantMoves:{
            [player cleanActionMove:_plantMoves];
            break;
        }
        default:
            break;
    }

}


//For the subclass, override this method.
- (void) actionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"Please override me. Type:%i", _actionType);
}

@end
