//
//  EZBoardStatus.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZBoardStatus.h"
#import "EZCoord.h"
#import "EZConstants.h"
#import "EZChessPosition.h"

//I may need to persist this class.
//The goal before lunch is to make the black and white could go accordingly
//Visible and attainable.
@interface EZBoardStatus()
{
    //Will calculate the real rect.
    CGRect boardRect;
    
    //All the moved buttons
    //We just forget all the remoed buttons
    NSMutableDictionary* coordToChess;

    //All the moves will be recorded here.
    NSMutableArray* plantedChess;
}

- (CGRect) calcInnerRect;

- (short) lengthToGap:(CGFloat)len gap:(CGFloat)gap lines:(NSInteger)lines;

//Recursive method to find all the Qi for current position
- (NSInteger) innerQiDetector:(EZCoord*)coord isBlack:(BOOL)black checked:(NSMutableDictionary*)checked;

@end

@implementation EZBoardStatus
@synthesize lineGap, totalLines, bounds;

@synthesize steps, front, initialBlack;

@synthesize robberyStep, robberPosition;
//I made an assumption, that is the board is center aligned.
//And the board are smaller or equal with the bounds. 
//If this assumption are voilated, something wired may happen.\
//Assume each cell is cubic.
- (id) initWithSize:(CGRect)bd lineGap:(CGFloat)gap totalLines:(NSInteger)tl
{
    self = [super init];
    if(self){
        lineGap = gap;
        bounds = bd;
        totalLines = tl;
        boardRect = [self calcInnerRect];
        initialBlack = true;
        steps = 0;
        coordToChess = [[NSMutableDictionary alloc] initWithCapacity:100];
        plantedChess = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

//Take what passed inside as it is.
- (id) initWithBound:(CGRect)bd rows:(NSInteger)rows cols:(NSInteger)cols
{
    self = [super init];
    if(self){
        lineGap = bd.size.height/(rows-1);
        bounds = bd;
        totalLines = rows;
        boardRect = bounds;
        steps = 0;
        coordToChess = [[NSMutableDictionary alloc] initWithCapacity:100];
        plantedChess = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

//What's the purpose of this method?
//Detect if the connected button have Qi or not.
//Return the number of Qi for this chunk of Buttons.
//We can use recursive way to get the problem solved
//
- (NSInteger) detectQi:(EZCoord*)coord isBlack:(BOOL)black
{
    NSMutableDictionary* checked = [[NSMutableDictionary alloc] init];
    return [self innerQiDetector:coord isBlack:black checked:checked];
}


- (NSArray*) availableNeigbor:(EZCoord*)coord
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:4];
    short minusX = coord.x - 1;
    short minusY = coord.y - 1;
    short plusX = coord.x + 1;
    short plusY = coord.y + 1;
    if(minusX >= 0){//X direction is possible
        [res addObject:[[EZCoord alloc] init:minusX y:coord.y]];
    }    
    if(minusY >= 0){
        [res addObject:[[EZCoord alloc] init:coord.x y:minusY]];
    }
    if(plusX < totalLines){
        [res addObject:[[EZCoord alloc] init:plusX y:coord.y]];
    }
    if(plusY < totalLines){
        [res addObject:[[EZCoord alloc] init:coord.x y:plusY]];
    }
    
    return res;
}

//Complete the recursive version of the Qi detector.
- (NSInteger) innerQiDetector:(EZCoord*)coord isBlack:(BOOL)black checked:(NSMutableDictionary*)checked
{
    if([checked objectForKey:coord.getKey]){
        return 0;//duplicated button contribute nothing
    }
    [checked setValue:coord forKey:coord.getKey];
    
    EZChessPosition* bt = [coordToChess objectForKey:coord.getKey];
    if(!bt){
        return 1;
    }
    //This condition is a little bit confusing.
    //Let's refracor it later.
    //Now for time being keep it as it is.
    if(bt.isBlack == black){
        int qiCount = 0;
        NSArray* neighbors = [self availableNeigbor:coord];
        for(EZCoord* ncoord in neighbors){
            qiCount += [self innerQiDetector:ncoord isBlack:black checked:checked];
        }
        return qiCount;
    }else{
        return 0;
    }
}

//Later will add good animation effect to the remove,
//Not keep it simple and stupid,
//Make it run.
- (void) removeEaten:(EZCoord*)coord animated:(BOOL)animated
{
    EZChessPosition* res = [coordToChess objectForKey:coord.getKey];
    res.eaten = true;
    EZChessPosition* lastMove = plantedChess.lastObject;
    [lastMove.removedChess addObject:res];
    //EZDEBUG(@"Add removed: %@ to %@", res.coord, lastMove.coord);
    [coordToChess removeObjectForKey:coord.getKey];
    [front clean:coord animated:animated];
    //return res;
}

//Remove this coord plus all it's connected neighor
- (NSInteger) cascadeRemoveEaten:(EZCoord*)coord isBlack:(BOOL)black animated:(BOOL)animated
{
    EZChessPosition* cur = [coordToChess objectForKey:coord.getKey];
    if(!cur){//Empty space;
        return 0;
    }
    
    if(cur.isBlack != black){
        return 0;
    }
    
    [self removeEaten:coord animated:animated];
    NSArray* neighbors = [self availableNeigbor:coord];
    NSInteger res = 1;
    for(EZCoord* ncoord in neighbors){
        res += [self cascadeRemoveEaten:ncoord isBlack:black animated:animated];
    }
    if(res == 1){
        robberyStep = steps;
        robberPosition = cur;
    }
    return res;
}

//What's the purpose of this functionality?
//It will be called after a button is planted.
//It will check if anybody will get removed
//If have will remove them.
//Returned value will be all removed buttons
- (NSInteger) checkAndRemove:(EZCoord*)coord isBlack:(BOOL)black animated:(BOOL)animated
{
    EZDEBUG(@"CheckAndRemove started");
    NSArray* neighbors = [self availableNeigbor:coord];
    NSInteger res = 0;
    for(EZCoord* ncoord in neighbors){
        //Check the neighor with reversed color
        int qi = [self detectQi:ncoord isBlack:!black];
        if(qi == 0){
            int curCount = [self cascadeRemoveEaten:ncoord isBlack:!black animated:animated];
            res += curCount;
            //EZDEBUG(@"Remove start:%@, removed:%i", ncoord, curCount);
        }
    }
    EZDEBUG(@"Totally removed:%i", res);
    return res;
}

//What's the purpose of this method.
//Who will call this method?
//Before plant a button, this method will be called
//It will return truth
//If 1. We have availableQi
//Or 2. We can eat opponents
//Don't worry about robbery.
//Robbery check have done before calling this.
//I am imagine just plant this and check if we have Qi.
//Or if we can remove any thing.
//Cool.
//If we remove the side effect checkAndRemove we are perfect.
//Assume this button is not in the coord yet.
- (BOOL) checkAvailableQi:(EZCoord*)coord isBlack:(BOOL)black
{
    [coordToChess setValue:[[EZChessPosition alloc]initWithCoord:coord isBlack:black step:steps] forKey:coord.getKey];
    int qi = [self detectQi:coord isBlack:black];
    if(qi > 0){
        return true;
    }
    NSArray* neighbors = [self availableNeigbor:coord];
    for(EZCoord* ncoord in neighbors){
        //Check the neighor with reversed color
        int qi = [self detectQi:ncoord isBlack:!black];
        if(qi == 0){//Find zero Qi neighbor. Great news
            EZChessPosition* ep = [coordToChess objectForKey:ncoord.getKey];
            if(ep.isBlack == !black){//Seems it is opponent's button. We win
                return true;
            }
        }
    }
    [coordToChess removeObjectForKey:coord.getKey];
    return false;
}

- (CGRect) calcInnerRect
{
    CGFloat width = (totalLines-1)* lineGap;
    return CGRectMake(bounds.origin.x + (bounds.size.width - width)/2, bounds.origin.y + (bounds.size.height - width)/2, width, width);
}

//Cool, Let's test it later.
//Feed my rabbit now.
- (CGPoint) adjustLocation:(CGPoint)point
{
    return [self bcToPoint:[self pointToBC:point]];
}


- (short) lengthToGap:(CGFloat)len gap:(CGFloat)gap lines:(NSInteger)lines
{
    short wd = len/gap;
    //NSInteger xInt = len;
    short remain = (NSInteger)len % (NSInteger)gap;
    if(remain > (gap/2)){
        ++wd; 
    }
    if(wd < 0){
        wd = 0;
    }else if(wd >= lines){
        wd = lines - 1;
    }
    return wd;
}

- (EZCoord*) pointToBC:(CGPoint)rawPt
{
    CGPoint pt  = CGPointMake(rawPt.x - boardRect.origin.x, rawPt.y - boardRect.origin.y);
    short wd = [self lengthToGap:pt.x gap:lineGap lines:totalLines];
    short ht = [self lengthToGap:pt.y gap:lineGap lines:totalLines];
    return [[EZCoord alloc] init:wd y:ht];
}

- (CGPoint) bcToPoint:(EZCoord*)bd
{
    return CGPointMake(boardRect.origin.x + bd.x * lineGap, boardRect.origin.y + bd.y * lineGap);
}


//Check if the position are legal to put button or not.
//No internal status will be updated
//Check 3 cases, now keep it simple and stupid
- (ChessPutStatus) tryPutButton:(EZCoord*) bd isBlack:(BOOL)black
{
    EZDEBUG(@"check for occupid");
    if([coordToChess objectForKey:[NSString stringWithFormat:@"%i",bd.toNumber]]){
        return EZOccupied;
    }
    
    EZDEBUG(@"check for robbery");
    if([bd.getKey isEqualToString:robberPosition.coord.getKey] && ((steps-1) == robberyStep)){
        return EZJustRobber;
    }
    
    EZDEBUG(@"check for Qi");
    if(![self checkAvailableQi:bd isBlack:black]){
        return EZLackQi;
    }
    
    return EZPutOk;
}

//Simplify the usage.
- (ChessPutStatus) putButton:(CGPoint)point animated:(BOOL)animated
{
    EZCoord* coord = [self pointToBC:point];
    return [self putButtonByCoord:coord animated:animated];
    
}

//If successful, will update the steps and change the internal status accordingly.
//The It will call EZBoardFront to plant the button on screen accordingly.
- (ChessPutStatus) putButtonByCoord:(EZCoord*)coord animated:(BOOL)animated
{
    EZDEBUG(@"put button on:%@",coord);
    ChessPutStatus putStatus = [self tryPutButton:coord isBlack:[self isCurrentBlack]];
    if(putStatus != EZPutOk){
        return putStatus;
    }
    
    EZChessPosition* pos = [[EZChessPosition alloc]initWithCoord:coord isBlack:[self isCurrentBlack] step:steps] ;
    [coordToChess setValue:pos forKey:coord.getKey];
    [plantedChess addObject:pos];
    [front putButton:coord isBlack:[self isCurrentBlack] animated:animated];
    [self checkAndRemove:coord isBlack:self.isCurrentBlack animated:animated];
    ++steps;
    
    
    //EZDEBUG(@"complete put button");
    return putStatus;
}

- (BOOL) isCurrentBlack
{
    BOOL isBlackChess = TRUE;
    if(steps % 2 == 0){
        isBlackChess = initialBlack; 
    }else{
        isBlackChess = !initialBlack;
    }
    return isBlackChess;
}

//What's the purpose of this functionality?
//remove the last steps.
//The UI level should check for this.
//No defensive, help to expose bugs.
//If error it caused by UI and data inconsistent.
//This is it, let's experiment.
- (void) regretOneStep
{
    //Too defensive?   
    if(plantedChess.count == 0){
        return;
    }
    EZChessPosition* chess = plantedChess.lastObject;
    EZDEBUG(@"Will regret, the coord is:%@, removed size is:%i",chess.coord, chess.removedChess.count);
    [plantedChess removeLastObject];
    [coordToChess removeObjectForKey:chess.coord.getKey];
    -- steps;
    [front clean:chess.coord animated:NO];
    for(EZChessPosition* removed in chess.removedChess){
        removed.eaten = NO;
        [coordToChess setValue:removed forKey:removed.coord.getKey];
        [front putButton:removed.coord isBlack:removed.isBlack animated:NO];
    }
}

@end
