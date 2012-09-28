//
//  EZChessPresetAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-28.
//
//

#import "EZChessPresetAction.h"
#import "EZActionPlayer.h"

@implementation EZChessPresetAction

- (id) init
{
    self = [super init];
    self.syncType = kSync;
    //self.actionType = kPreSetting;
    return self;
}



- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Will undo preset Action");
    [player cleanActionMove:_preSetMoves];
}


//For the subclass, override this method.
//I assume this will be ok. Let's try.
- (void) actionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"preset: put chess");
    [player.board putChessmans:_preSetMoves animated:NO];

}


@end
