//
//  EZSoundAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-28.
//
//

#import "EZSoundAction.h"
#import "EZActionPlayer.h"
#import "SBJson.h"

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

- (void) fastForward:(EZActionPlayer *)player
{
    EZDEBUG(@"I will do nothing");
}

- (NSDictionary*) actionToDict
{
    NSMutableDictionary* res = (NSMutableDictionary*)[super actionToDict];
    [res setValue:_audioFiles forKey:@"audioFiles"];
    [res setValue:@(_currentAudio) forKey:@"currentAudio"];
    [res setValue:self.class.description forKey:@"class"];
    return res;
}

- (id) initWithDict:(NSDictionary*)dict
{
    self = [super initWithDict:dict];
    //Because I turn all the NSURL to strings, so here I should to turn them back.
    NSArray* urlStrs = [dict objectForKey:@"audioFiles"];
    NSMutableArray* urls = [[NSMutableArray alloc] initWithCapacity:urlStrs.count];
    for(NSString* fileURL in urlStrs){
        [urls addObject:[NSURL URLWithString:fileURL]];
    }
    _audioFiles = urls;
    _currentAudio = ((NSNumber*)[dict objectForKey:@"currentAudio"]).intValue;
    return self;
}



@end

