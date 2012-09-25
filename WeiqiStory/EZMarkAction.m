//
//  EZMarkAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import "EZMarkAction.h"
#import "cocos2d.h"
#import "EZCharMark.h"
#import "EZActionPlayer.h"
//#import "EZCoord.h"

@implementation EZMarkAction


- (void) undoAction:(EZActionPlayer*)player
{
    for(EZCharMark* mark in _marks){
        [player.board removeMark:mark.coord animAction:nil];
    }
}

//For the subclass, override this method.
- (void) actionBody:(EZActionPlayer*)player
{
    for(EZCharMark* mark in _marks){
        EZDEBUG(@"Add mark get called");
        CCLabelTTF*  markText = [CCLabelTTF labelWithString:mark.content fontName:@"Arial" fontSize:40];
        [player.board putMark:markText coord:mark.coord animAction:nil];
    }
}

@end
