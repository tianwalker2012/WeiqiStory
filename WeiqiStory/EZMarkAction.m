//
//  EZMarkAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import "EZMarkAction.h"
#import "cocos2d.h"
#import "EZChessMark.h"
#import "EZActionPlayer.h"
//#import "EZCoord.h"

@implementation EZMarkAction


- (id) init
{
    self = [super init];
    self.syncType = kSync;
    return self;
}

- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Will undo all the marks, current count:%i", _marks.count);
    for(EZChessMark* mark in _marks){
        [player.board removeMark:mark.coord animAction:nil];
    }
}

//For the subclass, override this method.
- (void) actionBody:(EZActionPlayer*)player
{
    for(EZChessMark* mark in _marks){
        EZDEBUG(@"Add mark get called, character:%@", mark.text);
        [player.board putCharMark:mark.text fontSize:mark.fontSize coord:mark.coord animAction:false];
    }
}

@end
