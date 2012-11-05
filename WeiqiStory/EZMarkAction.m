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


//This will never get called.
//Because the EZAction have call actionBody already.
//Let's check debug output carefully.
- (void) fastForward:(EZActionPlayer *)player
{
    [self actionBody:player];
}

//Will turn the action into dictionary
- (NSDictionary*) actionToDict
{
    NSMutableDictionary* res = (NSMutableDictionary*)[super actionToDict];
    [res setValue:self.class.description forKey:@"class"];
    [res setValue:[self marksToArray:_marks] forKey:@"marks"];
    
    return res;
    
    return res;
}

- (id) initWithDict:(NSDictionary*)dict
{
    self =  [super initWithDict:dict];
    _marks = [self arrayToMarks:[dict objectForKey:@"marks"]];
    return self;
}


-(void)encodeWithCoder:(NSCoder *)coder {
    
    [super encodeWithCoder:coder];
    //EZDEBUG(@"encodeWithCoder");
    [coder encodeObject:_marks forKey:@"marks"];
}




-(id)initWithCoder:(NSCoder *)decoder {
    //[super initWith]
    self = [super initWithCoder:decoder];
    _marks = [decoder decodeObjectForKey:@"marks"];
    return self;
    
}



@end
