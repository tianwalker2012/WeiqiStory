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

- (NSDictionary*) actionToDict
{
    NSMutableDictionary* res = (NSMutableDictionary*)[super actionToDict];
    [res setValue:@(_preShowStep) forKey:@"preShowStep"];
    [res setValue:@(_preStartStep) forKey:@"preStartStep"];
    
    [res setValue:@(_curShowStep) forKey:@"curShowStep"];
    [res setValue:@(_curStartStep) forKey:@"curStartStep"];
    [res setValue:self.class.description forKey:@"class"];
    return res;
}

- (id) initWithDict:(NSDictionary*)dict
{
    self = [super initWithDict:dict];
    _preShowStep = ((NSNumber*)[dict objectForKey:@"preShowStep"]).intValue;
    _preStartStep = ((NSNumber*)[dict objectForKey:@"preStartStep"]).intValue;
    _curShowStep = ((NSNumber*)[dict objectForKey:@"curShowStep"]).intValue;
    _curStartStep = ((NSNumber*)[dict objectForKey:@"curStartStep"]).intValue;
    return self;
}

@end
