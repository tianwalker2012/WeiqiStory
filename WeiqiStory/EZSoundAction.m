//
//  EZSoundAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-28.
//
//

#import "EZSoundAction.h"
#import "EZActionPlayer.h"

@implementation EZSoundAction

- (id) init
{
    self = [super init];
    self.syncType = kAsync;
    //self.actionType = kLectures;
    return self;
}



- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Will undo audio action. I have no side effects on the board");
}


//For the subclass, override this method.
//I assume this will be ok. Let's try.
- (void) actionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"preset: put chess");
    [player playSound:[self clone] completeBlock:self.nextBlock];
    
}

- (EZSoundAction*) clone
{
    EZSoundAction* cloned = [[EZSoundAction alloc] init];
    //cloned.plantMoves = _plantMoves;
    //cloned.currentMove = _currentMove;
    cloned.audioFiles = _audioFiles;
    cloned.currentAudio = _currentAudio;
    cloned.unitDelay = self.unitDelay;
    return cloned;
}




@end

