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

- (void) fastForward:(EZActionPlayer *)player
{
    EZDEBUG(@"Fastforward for Combined action");
    for(EZAction* action in _actions){
        [action fastForward:player];
    }
}

- (void) pause:(EZActionPlayer *)player
{
    EZDEBUG(@"pause get called");
    if(_pauseBlock){
        _pauseBlock();
    }
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
    
    __weak EZCombinedAction* weakSelf = self;
    
    //Only block can provide this kind of power
    _pauseBlock = ^(){
        EZDEBUG(@"In pause block, i will pause and fastforward");
        //Ask the action to stop
        [action pause:player];
        for(int i = pos+1; i < weakSelf.actions.count; i++){
            EZAction* act = [weakSelf.actions objectAtIndex:i];
            [act fastForward:player];
        }
        //No need to call nextBlock, because it triggered by the player,so.
        //weakSelf.nextBlock();
    };
    
    if(action.syncType == kSync){
        [action actionBody:player];
        combinedBlock();
    }else if(action.syncType == kAsync){
        //The action will call nextBlock
        [action actionBody:player];
    }
}

- (NSDictionary*) actionToDict
{
    NSMutableDictionary* res = (NSMutableDictionary*)[super actionToDict];
    [res setValue:self.class.description forKey:@"class"];
    [res setValue:[EZAction actionsToCollections:_actions] forKey:@"actions"];
    return res;
}

- (id) initWithDict:(NSDictionary*)dict
{
    self = [super initWithDict:dict];
    _actions = [EZAction collectionToActions:[dict objectForKey:@"actions"]];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder:coder];
    //EZDEBUG(@"encodeWithCoder");
    [coder encodeObject:_actions forKey:@"actions"];
}




-(id)initWithCoder:(NSCoder *)decoder {
    //[super initWith]
    self = [super initWithCoder:decoder];
    _actions = [decoder decodeObjectForKey:@"actions"];
    return self;
    
}


@end
