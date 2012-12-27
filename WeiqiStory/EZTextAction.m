//
//  EZTextAction.m
//  WeiqiStory
//
//  Created by xietian on 12-12-25.
//
//

#import "EZTextAction.h"
#import "EZActionPlayer.h"

@implementation EZTextAction

//What do I mean by kAsync, mean I don't block the steps behind me
//Is this right?
//This is right for time being.
- (id) init
{
    self = [super init];
    self.syncType = kSync;
    //self.actionType = kPlantMoves;
    return self;
}

//What I am suppose to do?
//I am suppose to clear myself from the window and show the previous Comment text
- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Undo for text action");
    if(_type == kStoneComment){
        if(_prevText)
            [player.textShower showMoveComment:_prevText];
    }else{
        if(_prevText){
            [player.textShower showComment:_prevText];
        }
        
    }
}

//For the subclass, override this method.
//If I am a sync type I don't need to worry about how to draw. 
- (void) actionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"Show the comments");
    if(_type == kStoneComment){
        _prevText = [player.textShower getMoveComment];
        [player.textShower showMoveComment:_text];
    }else{
        _prevText = [player.textShower getComment];
        [player.textShower showComment:_text];
    }
}



-(void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder:coder];
    //EZDEBUG(@"encodeWithCoder");
    [coder encodeObject:_text  forKey:@"text"];
    
}




-(id)initWithCoder:(NSCoder *)decoder {
    //[super initWith]
    self = [super initWithCoder:decoder];
    _text = [decoder decodeObjectForKey:@"text"];
    //_currentMove = [decoder decodeIntForKey:@"currentMove"];
    return self;
    
}



@end
