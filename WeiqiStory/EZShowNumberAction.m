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

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder:coder];
    //EZDEBUG(@"encodeWithCoder");
    //[coder encodeObject:_marks forKey:@"marks"];
    [coder encodeInt:_preShowStep forKey:@"preShowStep"];
    [coder encodeInt:_preStartStep forKey:@"preStartStep"];
    [coder encodeInt:_curShowStep forKey:@"curShowStep"];
    [coder encodeInt:_curStartStep forKey:@"curStartStep"];
    
}




-(id)initWithCoder:(NSCoder *)decoder {
    //[super initWith]
    self = [super initWithCoder:decoder];
    _preShowStep = [decoder decodeIntegerForKey:@"preShowStep"];
    _preStartStep = [decoder decodeIntegerForKey:@"preStartStep"];
    _curShowStep = [decoder decodeIntegerForKey:@"curShowStep"];
    _curStartStep = [decoder decodeIntegerForKey:@"curStartStep"];
    return self;
    
}


@end
