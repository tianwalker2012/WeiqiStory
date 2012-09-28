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
    cloned.unitDelay = _unitDelay;
    cloned.name = _name;
    cloned.syncType = _syncType;
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
    _nextBlock = ^(){
        if(player.playingStatus == kPlaying){
            [player resume];
        }else{
            [player stepCompleted];
        }
    };
    
    [self actionBody:player];
    
    //Mean I will call directly.
    if(_syncType == kSync){
        _nextBlock();
    }
}

- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"undoAction:Please override me");
   /**
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
    **/

}

- (void) actionBody:(EZActionPlayer *)player
{
    EZDEBUG(@"Should override");
}

//For the subclass, override this method.
//I assume this will be ok. Let's try. 
- (void) oldActionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"Please override me");
    /**
    EZAction* cloned = [self clone];
    switch (_actionType) {
        case kPreSetting:
            [player.board putChessmans:_preSetMoves animated:NO];
            //self.nextBlock();
            break;
            
        case kLectures:{
            
            [player playSound:cloned completeBlock:self.nextBlock];
            break;
            
        }
        case kPlantMoves:{
            cloned.currentMove = 0;
            [player playMoves:cloned completeBlock:self.nextBlock withDelay:cloned.unitDelay];
            break;
        }
        default:{
            break;
        }
    }
     **/
}

@end
