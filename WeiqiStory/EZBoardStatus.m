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
#import "EZSoundManager.h"

//I may need to persist this class.
//The goal before lunch is to make the black and white could go accordingly
//Visible and attainable.
@interface EZBoardStatus()
{
    //Will calculate the real rect.
    CGRect boardRect;
    
    //All the moved buttons
    //We just forget all the removed buttons
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
        steps = 0;
        lineGap = gap;
        bounds = bd;
        totalLines = tl;
        boardRect = [self calcInnerRect];
        initialBlack = true;
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
        steps = 0;
        lineGap = bd.size.height/(rows-1);
        bounds = bd;
        totalLines = rows;
        boardRect = bounds;
        initialBlack = true;
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

//Is this ok to each neighbor see if any of them have more than zero connection
- (NSInteger) countConnectedNeighbor:(EZCoord*)coord isBlack:(BOOL)black checked:(NSMutableDictionary*)checked
{
    if([checked objectForKey:coord.getKey]){
        return 0;//duplicated button contribute nothing
    }
    [checked setValue:coord forKey:coord.getKey];
    
    EZChessPosition* cur = [coordToChess objectForKey:coord.getKey];
    if(!cur){//Empty space;
        return 0;
    }
    if(cur.isBlack != black){
        return 0;
    }
    
    NSArray* neighbors = [self availableNeigbor:coord];
    NSInteger res = 1;
    for(EZCoord* ncoord in neighbors){
        res += [self countConnectedNeighbor:ncoord isBlack:black checked:checked];
    }
    return res;
}

//Remove this coord plus all it's connected neighor
- (NSInteger) cascadeRemoveEaten:(EZCoord*)coord isBlack:(BOOL)black animated:(BOOL)animated removed:(EZChessPosition**)removed
{
    EZChessPosition* cur = [coordToChess objectForKey:coord.getKey];
    if(!cur){//Empty space;
        return 0;
    }
    
    if(cur.isBlack != black){
        return 0;
    }
    *removed = cur;
    [self removeEaten:coord animated:animated];
    NSArray* neighbors = [self availableNeigbor:coord];
    NSInteger res = 1;
    for(EZCoord* ncoord in neighbors){
        res += [self cascadeRemoveEaten:ncoord isBlack:black animated:animated removed:removed];
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
    //EZDEBUG(@"CheckAndRemove started");
    NSArray* neighbors = [self availableNeigbor:coord];
    NSInteger res = 0;
    EZChessPosition* removed = nil;
    for(EZCoord* ncoord in neighbors){
        //Check the neighor with reversed color
        int qi = [self detectQi:ncoord isBlack:!black];
        if(qi == 0){
            int curCount = [self cascadeRemoveEaten:ncoord isBlack:!black animated:animated removed:&removed];
            res += curCount;
            //EZDEBUG(@"Remove start:%@, removed:%i", ncoord, curCount);
        }
    }
    
    if(res == 1){
        EZDEBUG(@"Found robbery position:%@", removed.coord);
        robberyStep = steps;
        robberPosition = removed;
    }
    //EZDEBUG(@"Totally removed:%i", res);
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
- (BOOL) checkAvailableQi:(EZCoord*)coord isBlack:(BOOL)black isRobbery:(BOOL)robbery
{
    [coordToChess setValue:[[EZChessPosition alloc]initWithCoord:coord isBlack:black step:steps] forKey:coord.getKey];
    BOOL res = [self checkAvailableQiInner:coord isBlack:black isRobbery:robbery];
    //Why not remove it?
    [coordToChess removeObjectForKey:coord.getKey];
    return res;
}

- (BOOL) checkAvailableQiInner:(EZCoord *)coord isBlack:(BOOL)black isRobbery:(BOOL)robbery
{
    int qi = [self detectQi:coord isBlack:black];
    if(qi > 0){
        return true;
    }
    NSArray* neighbors = [self availableNeigbor:coord];
    
    if(!robbery){//Normal
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
        
    }else{
        NSInteger eatenCount = 0;
        for(EZCoord* ncoord in neighbors){
            //Check the neighor with reversed color
            NSMutableDictionary* checked = [[NSMutableDictionary alloc] init];
            int qi = [self detectQi:ncoord isBlack:!black];
            if(qi == 0){//Find zero Qi neighbor. Great news
                EZChessPosition* ep = [coordToChess objectForKey:ncoord.getKey];
                if(ep.isBlack == !black){//Seems it is opponent's button. We win
                    eatenCount = +[self countConnectedNeighbor:ncoord isBlack:!black checked:checked];
                }
            }
        }
        EZDEBUG(@"Eaten %i ", eatenCount);
        if(eatenCount > 1){
            EZDEBUG(@"It is not robbery, I eat more than one");
            return true;
        }
    }
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
    //EZDEBUG(@"check for occupid");
    if([coordToChess objectForKey:[NSString stringWithFormat:@"%i",bd.toNumber]]){
        return EZOccupied;
    }
    
    //EZDEBUG(@"check for robbery");
    BOOL isRobbery = false;
    if([bd.getKey isEqualToString:robberPosition.coord.getKey] && ((steps-1) == robberyStep)){
        isRobbery = true;
    }
    
    //EZDEBUG(@"check for Qi");
    if(![self checkAvailableQi:bd isBlack:black isRobbery:isRobbery]){
        if(isRobbery){
            return EZJustRobber;
        }
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
    BOOL isBlack = [self isCurrentBlack];
    if(coord.chessType == kBlackChess){
        isBlack = true;
    }else if(coord.chessType == kWhiteChess){
        isBlack = false;
    }
    ChessPutStatus putStatus = [self tryPutButton:coord isBlack:isBlack];
    if(putStatus != EZPutOk){
        if(animated){
            [[EZSoundManager sharedSoundManager] playSoundEffect:sndRefuseChessman];
        }
        return putStatus;
    }
    EZChessPosition* pos = [[EZChessPosition alloc]initWithCoord:coord isBlack:isBlack step:steps] ;
    [coordToChess setValue:pos forKey:coord.getKey];
    [plantedChess addObject:pos];
    [front putButton:coord isBlack:isBlack animated:animated];
    
    if(animated){
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndPlantChessman];
    }
    [self checkAndRemove:coord isBlack:isBlack animated:animated];
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

- (NSArray*) plantedChesses
{
    return plantedChess;
}


//great responsibility assignment.
- (EZCoord*) coordForStep:(NSInteger)step
{
    EZChessPosition* chessPos = [plantedChess objectAtIndex:step];
    EZCoord* coord = [chessPos.coord clone];
    //Why do we do this?
    //So that what do we see is what do we get. 
    coord.chessType = chessPos.isBlack?kBlackChess:kWhiteChess;
    return coord;
}

//All chess move enable you to modify it.
//This is really confusing.
//Let's stop the confusion here.
//One is stored the EZChessPosition.
//Another will return the coord to outside world.
//Great. That's the difference.
- (NSArray*) getAllChessMoves
{
    NSMutableArray* res = [[NSMutableArray alloc] initWithCapacity:plantedChess.count];
    for(int i = 0; i < plantedChess.count; i++){
        [res addObject:[self coordForStep:i]];
    }
    EZDEBUG(@"All ChessMoves:%i", res.count);
    return res;
}

//What's the purpose of this functionality?
//remove the last steps.
//The UI level should check for this.
//No defensive, help to expose bugs.
//If error it caused by UI and data inconsistent.
//This is it, let's experiment.
- (EZChessPosition*) regretOneStep:(BOOL)animated
{
    //Too defensive?
    if(plantedChess.count == 0){
        return nil;
    }
    EZChessPosition* chess = plantedChess.lastObject;
    EZDEBUG(@"Will regret, the coord is:%@, removed size is:%i",chess.coord, chess.removedChess.count);
    [plantedChess removeLastObject];
    [coordToChess removeObjectForKey:chess.coord.getKey];
    -- steps;
    [front clean:chess.coord animated:animated];
    for(EZChessPosition* removed in chess.removedChess){
        removed.eaten = NO;
        [coordToChess setValue:removed forKey:removed.coord.getKey];
        //[front putButton:removed.coord isBlack:removed.isBlack animated:NO];
        EZDEBUG(@"Will recover eaten button");
        [front recoveredButton:removed animated:false];
    }
    return chess;

}

//Will add a clean all the marks.
- (void) cleanAllMoves
{
    [plantedChess removeAllObjects];
    NSArray* postions = coordToChess.allValues;
    for(EZChessPosition* cp in postions){
        [front clean:cp.coord animated:NO];
    }
    [coordToChess removeAllObjects];
    steps = 0;
}

@end
