//
//  EZSGFReader.m
//  WeiqiStory
//
//  Created by xietian on 12-12-20.
//
//

#import "EZSGFHelper.h"
#import "EZConstants.h"
#import "EZEpisodeVO.h"
#import "EZCoord.h"
#import "EZChessMark.h"
#import "EZExtender.h"
#import "EZStackPushAction.h"
#import "EZStackPopAction.h"
#import "EZChessMoveAction.h"
#import "EZTextAction.h"
#import "EZChessMark.h"
#import "EZMarkAction.h"
#import "EZChessPresetAction.h"
#import "EZSGFItem.h"
#import "EZChessNode.h"
#import "SGFParser.h"

@implementation EZSGFHelper

//Read SGF to EZEpisodeVO
+ (EZEpisodeVO*) readSGF:(NSString*)fileName
{
    EZChessNode* chessNode = [SGFParser parseSGF:fileName];
    
    return [self convertNodeToAction:chessNode];
}

//I will convert all the node to action according to my previous plan.
+ (EZEpisodeVO*) convertNodeToAction:(EZChessNode*)node
{
    EZEpisodeVO* res = [[EZEpisodeVO alloc] init];
    [self populateEpisode:res node:node];
    NSMutableArray* actions = [[NSMutableArray alloc] init];
    //EZEpisodeVO
    
    res.actions = actions;
    //Why pass first into it?
    //So that we could add basic pattern. 
    [self populateAcions:res node:node first:TRUE];

    EZDEBUG(@"Added actions:%i", actions.count);

    return res;
}

+ (void) populateAcions:(EZEpisodeVO*)epv node:(EZChessNode*)node first:(BOOL)isFirst
{
    //Why? so that the board status can be stored
    NSMutableArray* actions = (NSMutableArray*)epv.actions;
    
    [actions addObject:[EZStackPushAction new]];
    
    for(EZSGFItem* item in node.nodes){
        if(item.type == kChessNode){
            [self populateAcions:epv node:(EZChessNode*)item first:FALSE];
        }else{
            [self populateItem:item epv:epv first:isFirst];
        }
    }
    
    [actions addObject:[EZStackPopAction new]];
}

//Once I get this done, I will use a simple test to illustrate what I have done.
//Good work. Go ahead. man
+ (void) populateItem:(EZSGFItem*)item epv:(EZEpisodeVO*)epv first:(BOOL)first
{
    EZAction* res = nil;
    NSMutableArray* actions = (NSMutableArray*)epv.actions;

    if([@"C" isEqualToString:item.name]){
        EZTextAction* action = [[EZTextAction alloc] init];
        action.type = kStatusComment;
        //I assume the comment only have one child
        action.text = [item.properties lastObject];
        res = action;
    }else if([@"N" isEqualToString:item.name]){
        EZTextAction* action = [[EZTextAction alloc] init];
        action.type = kStoneComment;
        action.text = [item.properties lastObject];
        res = action;
    }else if([@"TR" isEqualToString:item.name]){
        EZMarkAction* action = [[EZMarkAction alloc] init];
        NSMutableArray* marks = [[NSMutableArray alloc] initWithCapacity:item.properties.count];
        for(NSString* str in item.properties){
            [marks addObject:[[EZChessMark alloc] initWithType:kShapeMark text:item.name coord:[self stringToCoord:item.properties.lastObject]]];
        }
        action.marks =  marks;
        res = action;
    }
    else if([@"LB" isEqualToString:item.name]){
        EZMarkAction* action = [[EZMarkAction alloc] init];
        action.marks =  [self labelToMarks:item];
        res = action;
    }else if([@"AB" isEqualToString:item.name] || [@"AW" isEqualToString:item.name]){
        EZChessPresetAction* presetAction = [[EZChessPresetAction alloc] init];
        presetAction.preSetMoves = [self itemToCoord:item];
        res = presetAction;
        if(first){
            NSMutableArray* arr = [[NSMutableArray alloc] init];
            if(epv.basicPattern){
                [arr addObjectsFromArray:epv.basicPattern];
            }
            [arr addObjectsFromArray:presetAction.preSetMoves];
            epv.basicPattern = arr;
        }
        
    }else if([@"B" isEqualToString:item.name] || [@"W" isEqualToString:item.name]){
        EZChessMoveAction* moveAction = [[EZChessMoveAction alloc] init];
        moveAction.plantMoves = [self itemToCoord:item];
        res = moveAction;
    }
    if(res){
        [actions addObject:res];
    }else{
        EZDEBUG(@"Encounter a nil item:%@", item.name);
    }
}

//I assume str will only contain the 2 alpha beta.
+ (EZCoord*) stringToCoord:(NSString*)str
{
    const char* chars = [str cStringUsingEncoding:NSUTF8StringEncoding];
    char x = chars[0] - 'a';
    char y = chars[1] - 'a';
    EZCoord* coord = [[EZCoord alloc] init:x y:y];
    return coord;
}

//Turn the label into the mark, which can be displayed on the board
//I assume the user will check the item status is LB before call me
+ (NSArray*) labelToMarks:(EZSGFItem*)item
{
    EZDEBUG(@"String to ChessMark Item name:%@", item.name);
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:item.properties.count];
    for(NSString* str in item.properties){
        NSRange range = [str rangeOfString:@":"];
        if(range.location < str.length){
            NSString* coordStr = [str substringToIndex:range.location];
            NSString* mark = [str substringFromIndex:range.location+1];
            
            const char* chars = [coordStr cStringUsingEncoding:NSUTF8StringEncoding];
            char x = chars[0] - 'a';
            char y = chars[1] - 'a';
            EZCoord* coord = [[EZCoord alloc] init:x y:y];
            EZChessMark* cm = [[EZChessMark alloc] initWithText:mark fontSize:0 coord:coord];
            [res addObject:cm];
        }
    }
    return res;
}

+ (NSArray*) itemToCoord:(EZSGFItem *)item
{
  
    //BOOL setColor = false;
    BOOL isBlack = false;
    if([@"B" isEqualToString:item.name]){
        isBlack = TRUE;
    }else if([@"W" isEqualToString:item.name]){
        isBlack = FALSE;
    }else if([@"AB" isEqualToString:item.name]){
        isBlack = TRUE;
    }else if([@"AW" isEqualToString:item.name]){
        isBlack = FALSE;
    }
    
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:item.properties.count];
    for(NSString* str in item.properties){
        EZDEBUG(@"Coord str:%@", str);
        EZCoord* coord = [self stringToCoord:str];
        coord.chessType = isBlack?kBlackChess:kWhiteChess;
        [res addObject:coord];
    }
    
    return res;
}


//What kind of message VO need to know?
//Let's pick several of them.
+ (void) populateEpisode:(EZEpisodeVO*)epv node:(EZChessNode*)node
{
    epv.name = @"Cool Name";
    epv.introduction = @"Introduce";
    
}

@end
