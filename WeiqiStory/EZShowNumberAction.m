//
//  EZShowNumberAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-27.
//
//

#import "EZShowNumberAction.h"
#import "EZActionPlayer.h"


@implementation EZShowNumberAction

- (id) init
{
    self = [super init];
    //self.actionType = kShowNumberAction;
    self.syncType = kSync;
    return self;
}

//Well done.
//Enjoy and test it. 
- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Will recover");
    [player.board setShowStep:_preShowStep];
    [player.board setShowStepStarted:_preStartStep];
}

//For the subclass, override this method.
- (void) actionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"Will show hand");
    _preShowStep = player.board.showStep;
    _preStartStep = player.board.showStepStarted;
    
    [player.board setShowStep:_curShowStep];
    [player.board setShowStepStarted:_curStartStep];
}

@end
