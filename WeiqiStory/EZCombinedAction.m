//
//  DefaulAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-26.
//
//

#import "EZCombinedAction.h"

@interface EZCombinedAction()


@end

@implementation EZCombinedAction

- (id) init
{
    self = [super init];
    self.syncType = kAsync;
    return self;
}

//will do it from beginning to the end.
//Undo will do it with reversed version
- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Will undo %i actions", _actions.count);
    for(int i=_actions.count-1; i >= 0; i--){
        EZAction* action = [_actions objectAtIndex:i];
        [action undoAction:player];
    }
    EZDEBUG(@"End of undo actions");
}


//For the subclass, override this method.
- (void) actionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"Combined action started, action Count:%i",_actions.count);
    [self doActionAt:0 player:player];
}


- (void) doActionAt:(NSInteger)pos player:(EZActionPlayer*)player
{
    EZDEBUG(@"Will do action at pos:%i", pos);
    if(pos >= _actions.count){
        EZDEBUG(@"Completed all steps");
        self.nextBlock();
        return;
    }
    EZAction* action = [_actions objectAtIndex:pos];
    EZOperationBlock combinedBlock = ^(){
        [self doActionAt:pos+1 player:player];
    };
    action.nextBlock = combinedBlock;
    
    if(action.syncType == kSync){
        [action actionBody:player];
        combinedBlock();
    }else if(action.syncType == kAsync){
        //The action will call nextBlock
        [action actionBody:player];
    }
}

@end
