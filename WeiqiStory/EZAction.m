//
//  EZAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import "EZAction.h"
#import "EZConstants.h"
#import "EZActionPlayer.h"
#import "EZCoord.h"
#import "EZChessMark.h"

@implementation EZAction

//get a copy of EZAction
//Why, because it carry the currentMove.
//I need the currentMove to to track all the things
- (EZAction*) clone
{
    EZAction* cloned = [[EZAction alloc] init];
    cloned.unitDelay = _unitDelay;
    cloned.name = _name;
    cloned.syncType = _syncType;
    return cloned;
}

- (void) dealloc
{
    EZDEBUG(@"dealloc:%@, pointer:%i",_name, (int)self);
}


//After refractoring it.
//the code is much more clean and more understandable to me. 
- (void) doAction:(EZActionPlayer*)player
{
    _nextBlock = ^(){
        if(player.playingStatus == kPlaying){
            [player resume];
        }else{
            [player stepCompleted];
        }
    };
    
    [self actionBody:player];
    
    //Mean I will call directly.
    if(_syncType == kSync){
        _nextBlock();
    }
}

- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"undoAction:Please override me");
   /**
    EZDEBUG(@"Will undo action for type:%i,name:%@",_actionType, _name);
    switch (_actionType) {
        case kPreSetting:{
            [player cleanActionMove:_preSetMoves];
            break;
        }
            
        case kPlantMoves:{
            [player cleanActionMove:_plantMoves];
            break;
        }
        default:
            break;
    }
    **/

}

- (void) actionBody:(EZActionPlayer *)player
{
    EZDEBUG(@"Should override");
}

//For the subclass, override this method.
//I assume this will be ok. Let's try. 
- (void) oldActionBody:(EZActionPlayer*)player
{
    EZDEBUG(@"Please override me");
    /**
    EZAction* cloned = [self clone];
    switch (_actionType) {
        case kPreSetting:
            [player.board putChessmans:_preSetMoves animated:NO];
            //self.nextBlock();
            break;
            
        case kLectures:{
            
            [player playSound:cloned completeBlock:self.nextBlock];
            break;
            
        }
        case kPlantMoves:{
            cloned.currentMove = 0;
            [player playMoves:cloned completeBlock:self.nextBlock withDelay:cloned.unitDelay];
            break;
        }
        default:{
            break;
        }
    }
     **/
}


//What's the purpose of this method?
//Turn a array of json string into a list of Actions.
//This method will be called recursively.
//Mean from inside it will call this method again and again.
+ (NSArray*) collectionToActions:(id)jsonCollections
{
    EZDEBUG(@"collectionToActions get called, type:%@, count:%i",[[jsonCollections class] description], [jsonCollections count]);
    NSMutableArray* res = [[NSMutableArray alloc] init];
    if([[jsonCollections class] isSubclassOfClass:[NSArray class]]){
        
        for(id item in jsonCollections){
            [res addObjectsFromArray:[EZAction collectionToActions:item]];
        }
        //return res;
    }else if([[jsonCollections class] isSubclassOfClass:[NSDictionary class]]){
        //Mean this is a normal object.
        //[res addObject:[self collectionToActions:<#(id)#>]
        [res addObject:[EZAction dictToAction:jsonCollections]];
    }
    EZDEBUG(@"Returned collections:%i", res.count);
    return res;
}

//Reverse what the collections are doing.
//My goal of this morning it to get this method implemented.
+ (id) actionsToCollections:(NSArray*)actions
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:actions.count];
    for(EZAction* act in actions){
        [res addObject:act.actionToDict];
    }
    return res;
}

//It will instantiate a new action out of the NSDictionary.
+ (id) dictToAction:(NSDictionary*)dict
{
    NSString* classType = [dict objectForKey:@"class"];
    Class cls = NSClassFromString(classType);
    id res = [[cls alloc] initWithDict:dict];
    return res;
}


//Each action should override this method.
//Make sure itself could be recoverred and persisted fully without losing information.
- (NSDictionary*) actionToDict
{
    //EZDEBUG(@"Please override me");
    NSMutableDictionary* res = [[NSMutableDictionary alloc] init];
    if(_name){
        [res setValue:_name forKey:@"name"];
    }
    
    [res setValue:@(_unitDelay) forKey:@"unitDelay"];
    [res setValue:@(_syncType) forKey:@"syncType"];
    return res;
}

//Every class should override this to get the own override method
- (id) initWithDict:(NSDictionary*)dict
{
    self = [super init];
    _name = [dict objectForKey:@"name"];
    _unitDelay = ((NSNumber*)[dict objectForKey:@"unitDelay"]).floatValue;
    _syncType = ((NSNumber*)[dict objectForKey:@"syncType"]).intValue;
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    
    //EZDEBUG(@"encodeWithCoder");
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeFloat:_unitDelay forKey:@"unitDelay"];
    [coder encodeInt:_syncType forKey:@"syncType"];
    //EZDEBUG(@"Complete encode");
}




-(id)initWithCoder:(NSCoder *)decoder {
    //[super initWith]
    self = [super init];
    //EZDEBUG(@"initWithCoder:%i",(int)self);
    _name = [decoder decodeObjectForKey:@"name"];
    //EZDEBUG(@"Decoded name:%@", _name);
    _unitDelay = [decoder decodeFloatForKey:@"unitDelay"];
    _syncType = [decoder decodeIntForKey:@"syncType"];
    //EZDEBUG(@"Complete initCoder");
    return self;
    
}

//I assume this would make whole chain complete.
- (id)proxyForJson
{
    return [self actionToDict];
}

- (NSArray*) coordsToArray:(NSArray*)coords
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:coords.count];
    for(EZCoord* coord in coords){
        [res addObject:[coord toDict]];
    }
    return res;
}

- (NSArray*) arrayToCoords:(NSArray*)dicts
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:dicts.count];
    for(NSDictionary* dict in dicts){
        [res addObject:[[EZCoord alloc] initWithDict:dict]];
    }
    return res;
}

- (NSArray*) marksToArray:(NSArray*)marks
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:marks.count];
    for(EZChessMark* mark in marks){
        [res addObject:mark.toDict];
    }
    return res;
}

- (NSArray*) arrayToMarks:(NSArray*)dicts
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:dicts.count];
    
    for(NSDictionary* dict in dicts){
        
        [res addObject:[[EZChessMark alloc] initWithDict:dict]];
        
    }
    
    return res;
}

//I assume the kSync type is just call the actionBody is good enough
- (void) fastForward:(EZActionPlayer*)player
{
    EZDEBUG(@"Fastforward");
    if(_syncType == kSync){
        [self actionBody:player];
    }else{
        EZDEBUG(@"kAsync type should override me");
    }
}

- (void) pause:(EZActionPlayer*)player
{
    EZDEBUG(@"Pause get called, do nothing");
}

@end
