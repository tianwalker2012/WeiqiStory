//
//  EZCleanAction.m
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import "EZCleanAction.h"
#import "EZChessBoard.h"
#import "EZActionPlayer.h"

@interface EZCleanAction()
{
    NSArray* cleanedMarks;
}

@end

@implementation EZCleanAction

- (id) init
{
    self = [super init];
    //self.actionType = kCleanBoard;
    self.syncType = kSync;
    return self;
}


- (EZAction*) clone
{
    EZCleanAction* cloned = [[EZCleanAction alloc] init];
    cloned.cleanedMoves = self.cleanedMoves;
    cloned.cleanedMarks = self.cleanedMarks;
    return cloned;
}

//Currently will store all current moves in the board will recover them when get undo.
- (void) actionBody:(EZActionPlayer*)player
{
    //Will be EZCoord.
    //Should we store the color?
    //Modify it when it is necessary.
    //Kiss, is my life blood.
    EZDEBUG(@"Clean the board");
    if(_cleanType == kCleanMarks){
        [player.board cleanAllMarks];
        _cleanedMarks = player.board.allMarks;
    }else if(_cleanType == kCleanChessman){
        _cleanedMoves = [player.board getAllChessMoves];
        EZDEBUG(@"cleaned Moves:%i",_cleanedMoves.count);
        [player.board cleanAllMoves];
    }else{
        //cleanedMarks = player.board.
        EZDEBUG(@"clean All get called");
        _cleanedMarks = player.board.allMarks;
        [player.board cleanAllMarks];
        self.cleanedMoves = [player.board getAllChessMoves];
        [player.board cleanAllMoves];
    }
}


- (void) undoAction:(EZActionPlayer*)player
{
    EZDEBUG(@"Time to recover, chessman count:%i", self.cleanedMoves.count);
    if(self.cleanedMoves.count > 0){
        [player.board putChessmans:self.cleanedMoves animated:NO];
    }
    //Have have cleaned Marks. let's plant them back.
    if(_cleanedMarks.count > 0){
        //[player.board putCharMark:<#(NSString *)#> fontSize:<#(NSInteger)#> coord:<#(EZCoord *)#> animAction:<#(CCAction *)#>]
    }
}


-(void)encodeWithCoder:(NSCoder *)coder {
    
    //EZDEBUG(@"encodeWithCoder");
    [super encodeWithCoder:coder];
    [coder encodeInt:_cleanType forKey:@"cleanType"];
    //[coder encodeInt:_syncType forKey:@"syncType"];
    [coder encodeObject:_cleanedMarks forKey:@"cleanedMarks"];
    [coder encodeObject:_cleanedMoves forKey:@"cleanedMoves"];
    //EZDEBUG(@"Complete encode");
}



-(id)initWithCoder:(NSCoder *)decoder {
    self =  [super initWithCoder:decoder];
    //EZDEBUG(@"initWithCoder");
    _cleanType = [decoder decodeIntForKey:@"cleanType"];
    _cleanedMarks = [decoder decodeObjectForKey:@"cleanedMarks"];
    _cleanedMoves = [decoder decodeObjectForKey:@"cleanedMoves"];
    //EZDEBUG(@"complete initWithCoder");
    return self;
    
}


//Each action should override this method.
//Make sure itself could be recoverred and persisted fully without losing information.
//I will only store the cleanType.
//Why not store all the things, so that I could save all the things?
//Keep it simple and stupid.
//I may using the native persistent framework, if it is convinient and necessary.
- (NSDictionary*) actionToDict
{
    NSMutableDictionary* res = (NSMutableDictionary*)[super actionToDict];
    [res setValue:self.class.description forKey:@"class"];
    [res setValue:@(_cleanType) forKey:@"cleanType"];
    [res setValue:[self marksToArray:_cleanedMarks] forKey:@"cleanedMarks"];
    [res setValue:[self coordsToArray:_cleanedMoves] forKey:@"cleanedMoves"];
    return res;
}

- (id) initWithDict:(NSDictionary*)dict
{
    self = [super initWithDict:dict];
    _cleanType = ((NSNumber*)[dict objectForKey:@"cleanType"]).intValue;
    _cleanedMarks = [self arrayToMarks:[dict objectForKey:@"cleanedMarks"]];
    _cleanedMoves = [self arrayToCoords:[dict objectForKey:@"cleanedMoves"]];
    return self;
}

@end
