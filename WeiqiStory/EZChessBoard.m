//
//  EZChessBoard.m
//  FirstCocos2d
//
//  Created by xietian on 12-9-19.
//
//

#import "EZChessBoard.h"
#import "EZTouchHelper.h"
#import "EZConstants.h"
#import "EZCoord.h"
#import "EZImageResources.h"
#import "EZChessman.h"
#import "EZChessMark.h"
#import "EZRegretAction.h"
#import "EZChessPosition.h"
#import "EZBoardStatus.h"

@interface EZChessBoard()
{
    //All the chessman are managed by this status.
    EZBoardStatus* boardStatus;
    CCSprite* virtualWhite;
    CCSprite* virtualBlack;
    NSMutableDictionary* coordToButtons;
    NSMutableDictionary* coordToMarks;
    NSArray* chessMarkChar;
    CCSprite* cursor;
    
    //What's the purpose of this count. Make the marks can function well
    NSInteger charCount;
    
    CGPoint lastMovePoint;
}

- (void) initializeCursor;

@end


@implementation EZChessBoard
@synthesize touchRect, rows, cols, touchEnabled, showStep;
@synthesize showStepStarted;


//The touch Rect determined what's the region for chess board.
//No hurry, take time to do each things slowly and with care from your heart.
//Just like you treat a human being, you are injecting yourself into the things you are doing,
//Only by doing things this way, you could really enjoy doing it and achieve your goals
//So far, status only support cubic format of the board.
//Great.
//TODO, later the EZBoardStatus will be extended to be able to handle the non-cubic board.
-(id)initWithFile:(NSString*)filename touchRect:(CGRect)rect rows:(NSInteger)rws cols:(NSInteger)cls
{
    self = [super initWithFile:filename];
    if(self){
        //self.anchorPoint = ccp(0.5, 0.5);
        //_boardBackground = [CCSprite spriteWithFile:filename];
        //_boardBackground.position = ccp(0, 0);
        //_boardBackground.anchorPoint = ccp(0, 0);
        //self.contentSize = _boardBackground.contentSize;
        //[self addChild:_boardBackground];
        chessMarkChar = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
        charCount = 0;
        //Why am I doing this?
        //So that the edge of the board coud detect the touch too
        _chessmanType = kChessMan;
        _chessmanSetType = kDetermineByBoard;
        CGFloat extendedGap = -(rect.size.width/(rws-1))/2;
        EZDEBUG(@"The extended gap:%f", extendedGap);
        touchRect = CGRectInset(rect, extendedGap, extendedGap);
        rows = rws;
        cols = cls;
        self.touchEnabled = true;
        //I assume I can calculate the lineGap, simply by rect.size.width/rows
        coordToButtons = [[NSMutableDictionary alloc] init];
        coordToMarks = [[NSMutableDictionary alloc] init];
        //Why do we have this? provide regret for the regrets
        //Which is powerful for people change his mind quite often
        _regrets = [[NSMutableArray alloc] init];
        _allMarks = [[NSMutableArray alloc] init];
        boardStatus = [[EZBoardStatus alloc] initWithBound:rect rows:rws cols:cls];
        boardStatus.front = self;
        _snapshotStack = [[NSMutableArray alloc] init];
        _estimatedChessmanSize = CGSizeMake(rect.size.width/(rws-1), rect.size.height/(rws-1));
        [self initializeCursor];
    }
    return self;
}

//For the study mode need to get the color correct
- (void) syncChessColorWithLastMove
{
    if(self.allSteps.count > 0){
        EZChessPosition* cp = self.allSteps.lastObject;
        if(cp.isBlack == self.isCurrentBlack){
            [self toggleColor];
        }
    }
}
//Only show the start since this step.
//Including this steps
- (void) setShowStep:(BOOL)show
{
    NSArray* chessmans = coordToButtons.allValues;
    for(EZChessman* chessman in chessmans){
        if(showStepStarted > 0 && show){
            EZDEBUG(@"Will show start from the start point:%i",showStepStarted);
            NSInteger curStep = chessman.step - showStepStarted;
            if(curStep >= 0){
                chessman.showedStep = curStep;
                chessman.showStep = show;
            }else{
                chessman.showStep = NO;
            }
        } else {
            chessman.showStep = show;
        }
    }
    showStep = show;
}

- (void) setChessmanSetType:(EZChessmanSetType)chessmanSetType
{
    //EZDEBUG(@"Drag the caller:%@",[NSThread callStackSymbols]);
    _chessmanSetType = chessmanSetType;
}

- (void) setShowStepStarted:(NSInteger)started
{
    showStepStarted = started;
    if(showStep){//Ask to show the new start.
        self.showStep = NO;
        self.showStep = YES;
    }
}

//Coord is better and more stable than point
//Remove button
- (void) clean:(EZCoord*)coord animated:(BOOL)animated
{
    EZDEBUG(@"Will clean the button for coord:%@", coord);
    CCSprite* btn = [coordToButtons objectForKey:coord.getKey];
    [coordToButtons removeObjectForKey:coord.getKey];
    
    if(animated){
        //[CCCallFunc actionWithTarget:self selector:@selector(whateverYourMethodIs)]
        id animatedRemove = [CCSequence actions:[CCFadeOut actionWithDuration:1.0],[CCCallBlock actionWithBlock:^(){
            [btn removeAllChildrenWithCleanup:YES];
        }], nil];
        [btn runAction:animatedRemove];
    }else{
        [btn removeFromParentAndCleanup:YES];
    }
    
}


//Simplest case, make sure things work as expected
//This is the thing, you could visualize and improve it on daily basis.
//Focus on it and improve it on daily basis. Only turn yourself into a creator is a life you
//could find peace and happiness in the end. 
- (void) putMark:(CCNode*)mark coord:(EZCoord*)coord animAction:(CCAction*)action
{
    
    NSMutableArray* marks = [coordToMarks objectForKey:coord.getKey];
    if(!marks){
        marks = [[NSMutableArray alloc] init];
        [coordToMarks setValue:marks forKey:coord.getKey];
    }
    //EZDEBUG(@"coordMarks size:%i, object pointer:%i, marks size:%i",coordToMarks.count, (int)coordToMarks, marks.count);
    EZChessMark* chessMark = [[EZChessMark alloc] initWithNode:mark coord:coord];
    chessMark.mark = mark;
    [marks addObject:chessMark];
    [_allMarks addObject:chessMark];
    CGPoint pt = [boardStatus bcToPoint:coord];
    [mark setPosition:pt];
    
    //[mark setPosition:ccp(200, 200)];
    EZDEBUG(@"mark point:%@, mark position:%@", NSStringFromCGPoint(pt), NSStringFromCGPoint(mark.position));
    //[self addChild:]
    [self addChild:mark z:MarkZOrder+10];

}
//What's the purpose of this method?
//I will put a specified mark on the board.
- (void) putMarkOld:(CCNode*)mark coord:(EZCoord*)coord animAction:(CCAction*)action
{
    NSMutableArray* marks = [coordToMarks objectForKey:coord.getKey];
    if(!marks){
        marks = [[NSMutableArray alloc] init];
        [coordToMarks setValue:marks forKey:coord.getKey];
    }
    //EZDEBUG(@"coordMarks size:%i, object pointer:%i, marks size:%i",coordToMarks.count, (int)coordToMarks, marks.count);
    EZChessMark* markObj = [[EZChessMark alloc] initWithNode:mark coord:coord];
    [marks addObject:markObj];
    [_allMarks addObject:markObj];
    CGPoint pt = [boardStatus bcToPoint:coord];
    [mark setPosition:pt];
    
    EZDEBUG(@"mark point:%@", NSStringFromCGPoint(pt));
    [self addChild:mark z:MarkZOrder+marks.count];
    if(action){
        [mark runAction:action];
    }
}


//Put marks on the board.
- (void) putMarks:(NSArray*) marks
{
    for(EZChessMark* mark in marks){
        //[self putCharMark:mark.text fontSize:mark.fontSize coord:mark.coord animAction:nil];
        [self putMark:mark animate:nil];
    }
}

//Do it on iterative basis
//why do we need the chessNode in the mark any way?
- (void) putMark:(EZChessMark*) mark animate:(id)anim
{
    CCNode* markNode = mark.mark;
    
    //Why do mark clone? so that the mark belong to different board will not interfer with each other
    mark = [mark clone];
    if(mark.type == kTextMark){
        CCLabelTTF*  markText = nil;
        //This will make sure the font size not larger than the actual chess man,
        //I should take the scale into account or what?
        CGFloat fontSize = _estimatedChessmanSize.width;
        //if(fontSize <= 0){
        //    fontSize = 30.0;
        //}
        //How to make the mark size meet the size of the chess man?
        
        markText = [CCLabelTTF labelWithString:mark.text fontName:@"Arial" fontSize:fontSize*0.9];
    
        //markText = [CCLabelTTF labelWithString:mark.text fontName:@"Arial" fontSize:fontSize];
        
    
        markText.color = ChessMarkColor;
        markNode = markText;
        mark.mark = markNode;
    }else if(mark.type == kTriangleMark){
        markNode = [CCSprite spriteWithFile:_isLargeBoard?@"triangular-large.png": @"triangular.png"];
        mark.mark = markNode;
    }
    
    NSMutableArray* marks = [coordToMarks objectForKey:mark.coord.getKey];
    if(!marks){
        marks = [[NSMutableArray alloc] init];
        [coordToMarks setValue:marks forKey:mark.coord.getKey];
    }
    //EZDEBUG(@"coordMarks size:%i, object pointer:%i, marks size:%i",coordToMarks.count, (int)coordToMarks, marks.count);
   
    [marks addObject:mark];
    [_allMarks addObject:mark];
    CGPoint pt = [boardStatus bcToPoint:mark.coord];
    [markNode setPosition:pt];
    [self addChild:markNode z:MarkZOrder+marks.count];
    //EZDEBUG(@"Add markNode:%@, to coord:%@, ZOrder:%i, FontSize:%i, point:%@", markNode, mark.coord, MarkZOrder+marks.count, mark.fontSize, NSStringFromCGPoint(pt));
    if(anim){
        [markNode runAction:anim];
    }

}

- (void) putCharMark:(NSString*)str fontSize:(NSInteger)fontSize coord:(EZCoord*)coord animAction:(CCAction*)action
{
    EZChessMark* mark = [[EZChessMark alloc] initWithText:str fontSize:fontSize coord:coord];
    [self putMark:mark animate:action];
}

- (BOOL) isCurrentBlack
{
    return boardStatus.isCurrentBlack;
}

//Change the board color
//Change the board color to fit my needs
- (void) toggleColor
{
    boardStatus.initialBlack = !boardStatus.initialBlack;
}
//If the mark exist I wll run the action,
//Of course I will attach a Remove from parent to get it remove from board when it is done.
//I will not clean it up, so It could be reused.
//Make it simple,
//Will clean al the marks
- (void) removeMark:(EZCoord*)coord animAction:(CCAction*)action
{
    
    //EZDEBUG(@"Will remove marks at %@", coord);
    NSMutableArray* marks = [coordToMarks objectForKey:coord.getKey];
    //EZDEBUG(@"Fetched marks:%@",marks);
    if(marks){
        for(EZChessMark* mk in marks){
            if(action){
                CCAction* removeAction = [CCSequence actions:action, [CCCallBlock actionWithBlock:^{
                    [mk.mark removeFromParentAndCleanup:NO];
                }]];
                [mk.mark runAction:removeAction];
            }else{
                //EZDEBUG(@"Will remove from parent, mark:%@",mk.mark);
                [mk.mark removeFromParentAndCleanup:NO];
            }
            [_allMarks removeObject:mk];
        }
        [marks removeAllObjects];
    }
}

//The key is that I didn't reuse any of the marks.
//Defer it. Focus to get the whole thing up and run.
- (void) removeMarks:(EZChessMark*)mark
{
    [_allMarks removeObject:mark];
    //[_allMarks removeObjectAtIndex:position];
    EZCoord* coord = mark.coord;
    NSMutableArray* marks = [coordToMarks objectForKey:coord];
    [marks removeObject:mark];
    [mark.mark removeFromParentAndCleanup:NO];
}
//Cool
//Now I knew why I need to store all the marks
- (void) cleanAllMarks
{
    [self regretMarks:_allMarks.count animated:NO];
}

//All the marks and moves get cleaned
- (void) cleanAll
{
    [self cleanAllMoves];
    [self cleanAllMarks];
    
    //Nothing to regret after we clean the table.
    [_regrets removeAllObjects];
}


//this is like a display logic.
//Should have nothing to do with the whether this button should appear or not.
//Yes, fix it first. This is annoy bugs right? Sure, let fix them.
//Finally, I have cases for merge 2 branch together.
//Enjoy it my dear.
- (void) recoveredButton:(EZChessPosition*)chessPos animated:(BOOL)animated
{
    NSString* chessmanFile = nil;
    if(chessPos.isBlack){
        chessmanFile = _blackChessName?_blackChessName:BlackBtnName;
    }else{
        chessmanFile = _whiteChessName?_whiteChessName:WhiteBtnName;
    }
    
    EZChessman* btn = [[EZChessman alloc] initWithSpriteFrameName:chessmanFile step:chessPos.step showStep:showStep isBlack:chessPos.isBlack showedStep:chessPos.step - showStepStarted];
    CGPoint pt = [boardStatus bcToPoint:chessPos.coord];
    [btn setZOrder:ExistingChess];
    [btn setPosition:pt];
    [coordToButtons setValue:btn forKey:chessPos.coord.getKey];
    //EZDEBUG(@"btn:%@", btn);
    if(animated){
        [btn setScale:1.3];
        [self addChild:btn];
        id scaleDown = [CCScaleTo actionWithDuration:0.3f scale:1.0f];
        [btn runAction:scaleDown];
    }else{
        //Simply add them if without animation
        [self addChild:btn];
    }

    
}

- (void) putButton:(EZCoord*)coord isBlack:(BOOL)isBlack animated:(BOOL)animated
{
    //Let's check it on iPad
    
    CGPoint pt = [boardStatus bcToPoint:coord];
    //EZDEBUG(@"Button on:%@", NSStringFromCGPoint(pt));
    EZChessman* btn = nil;
    if(isBlack){
        btn = [[EZChessman alloc] initWithSpriteFrameName:_blackChessName?_blackChessName:BlackBtnName step:boardStatus.steps showStep:showStep isBlack:isBlack showedStep:boardStatus.steps - showStepStarted];
    }else{
        btn = [[EZChessman alloc] initWithSpriteFrameName:_whiteChessName?_whiteChessName:WhiteBtnName step:boardStatus.steps showStep:showStep isBlack:isBlack showedStep:boardStatus.steps - showStepStarted];
    }
    [btn setZOrder:ExistingChess];
    [btn setPosition:pt];
    [coordToButtons setValue:btn forKey:coord.getKey];
    //EZDEBUG(@"btn:%@", btn);
    if(animated){
        [btn setScale:1.3];
        [self addChild:btn];
        id scaleDown = [CCScaleTo actionWithDuration:0.3f scale:1.0f];
        [btn runAction:scaleDown];
    }else{
        //Simply add them if without animation
        [self addChild:btn];
    }
}

//What's responsibility of this method?
//Make the cursor.
//Use the chessman for current stage.
- (void) putCursorButton:(CGPoint)regularizedPt
{
    //if(_chessmanType == kChessMan){
    cursor = nil;
    if(_chessmanSetType == kDetermineByBoard){
        if(boardStatus.isCurrentBlack){
            cursor = virtualBlack;
        }else{
            cursor = virtualWhite;
        }
    }else if(_chessmanSetType == kBlackChess){
        cursor = virtualBlack;
    }else{
        cursor = virtualWhite;
    }
    [cursor removeFromParentAndCleanup:NO];
    if(_cursorHolder){
        CGPoint globalPoint = [self convertToWorldSpace:regularizedPt];
        CGPoint holderPoint = [_cursorHolder convertToNodeSpace:globalPoint];
        //Make the entrance is possible.
        
        [cursor setPosition:holderPoint];
        [_cursorHolder addChild:cursor];
    }else{
        [cursor setPosition:regularizedPt];
        [self addChild:cursor];
    }
}

- (void) initializeCursor
{
    virtualWhite = [CCSprite spriteWithFile:@"point-finger-white.png"];
    virtualBlack = [CCSprite spriteWithFile:@"point-finger-black.png"];
    
    CCSprite* whiteButton = [CCSprite spriteWithFile:_whiteChessName?_whiteChessName:WhiteBtnName];
    CCSprite* blackButton = [CCSprite spriteWithFile:_blackChessName?_blackChessName:BlackBtnName];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:whiteButton.displayFrame name:_whiteChessName?_whiteChessName:WhiteBtnName];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:blackButton.displayFrame name:_blackChessName?_blackChessName: BlackBtnName];
    //[whiteBtn setPosition:ccp(size.width/2+36, size.height/2)];
    [virtualBlack setZOrder:OverExistingChess];
    [virtualWhite setZOrder:OverExistingChess];
    
    virtualWhite.opacity = 128;
    virtualBlack.opacity = 128;
    virtualBlack.scale = 1.4;
    virtualWhite.scale = 1.4;
}

- (void) setBlackChessName:(NSString *)blackChessName
{
    _blackChessName = blackChessName;
    [self initializeCursor];
}

- (void) setWhiteChessName:(NSString *)whiteChessName
{
    _whiteChessName = whiteChessName;
    [self initializeCursor];
}

- (void) moveCursorButton:(CGPoint)point
{
    if(_cursorHolder){
        CGPoint globalPoint = [self convertToWorldSpace:point];
        CGPoint holderPoint = [_cursorHolder convertToNodeSpace:globalPoint];
        [cursor setPosition:holderPoint];
    }else{
        [cursor setPosition:point];
    }
}


//Remove the cursor as the name implied.
- (void) removeCursorButton
{
    [cursor removeFromParentAndCleanup:YES];
}



//Keep it simple and stupid, assume the addTargetedDelegate are the power equal method call
- (void) setTouchEnabled:(BOOL)touchEd
{
    if(touchEnabled == touchEd){
        EZDEBUG(@"Don't repeat doing the same thing");
        return;
    }
    if(touchEd){
        [[[CCDirector sharedDirector]  touchDispatcher] addTargetedDelegate:self priority:10 swallowsTouches:YES];
    }else{
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }
    touchEnabled = touchEd;
}


- (void) putChessman:(EZCoord*)coord  animated:(BOOL)animated
{
    [boardStatus putButtonByCoord:coord animated:animated];
}


- (void) putChessmans:(NSArray*)coords animated:(BOOL)animated
{
    for(EZCoord* coord in coords){
        [self putChessman:coord animated:animated];
    }
}

- (NSArray*) getAllChessMoves
{
    return [boardStatus getAllChessMoves];
}

- (void) cleanAllMoves
{
    [boardStatus cleanAllMoves];
}

//How many steps I will regret.
- (void) regretSteps:(NSInteger)steps
{
    [self regretSteps:steps animated:false];
}

//Will get all the steps ever put on this board
- (NSArray*) allSteps
{
    return boardStatus.plantedChesses;
}

- (EZCoord*) coordForStep:(NSInteger)step
{
    return [boardStatus coordForStep:step];
}

- (void) regretChess:(NSInteger)steps  animated:(BOOL)animated
{
    for(int i = 0; i < steps; i++){
        EZChessPosition* cp = [boardStatus regretOneStep:animated];
        EZRegretAction* regAct = [[EZRegretAction alloc] init];
        regAct.position = cp;
        [_regrets addObject:regAct];
    }
}

- (void) regretSteps:(NSInteger)steps animated:(BOOL)animated
{
    if(_chessmanType == kChessMan){
        [self regretChess:steps animated:animated];
    }else{
        [self regretMarks:steps animated:animated];
    }
}

//Now we can officially regret what we regret for. 
- (void) redoRegret:(BOOL)animated
{
    if(_regrets.count > 0){
        EZRegretAction* act = [_regrets lastObject];
        [act redo:self animated:animated];
        [_regrets removeLastObject];
    }
}


- (void) regretMarks:(NSInteger)steps animated:(BOOL)animated
{
    NSMutableArray* removedMarks = [[NSMutableArray alloc] initWithCapacity:steps];

    for(int i = 0; i < steps; i++){
        if(_allMarks.count > 0){
            EZChessMark* cm = _allMarks.lastObject;
            [self removeMarks:cm];
            [removedMarks addObject:cm];

        }else{
            break;
        }
    }

    
    if(removedMarks.count > 0){
        EZRegretAction* regAct = [[EZRegretAction alloc] init];
        regAct.chessMarks = removedMarks;
        [_regrets addObject:regAct];
    }

}

//Following is the code for the touch event.
//Let's copy it form the EZBoard
//Return YES, mean I will process this touch event.
//It depends on which event type you register this Sprite for.
//Only for exclusive type of event, the YES or NO will affect if CDDirector will pass the event to
//Next component or not.
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint localPt = [self locationInSelf:touch];
    CGPoint regularizedPt = [boardStatus adjustLocation:localPt];
    lastMovePoint = regularizedPt;
    EZDEBUG(@"TouchRect:%@, touchPoint:%@",NSStringFromCGRect(touchRect), NSStringFromCGPoint(localPt));
    if(CGRectContainsPoint(touchRect, localPt)){
        //EZDEBUG(@"Will plant chessman");
        [self putCursorButton:regularizedPt];
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint localPoint = [self locationInSelf:touch];
    CGPoint regularizedPt = [boardStatus adjustLocation:localPoint isMove:true];
    EZDEBUG(@"Move local GL:%@, ajusted: %@", NSStringFromCGPoint(localPoint), NSStringFromCGPoint(regularizedPt));
    [self moveCursorButton:regularizedPt];
    lastMovePoint = regularizedPt;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint localPoint = [self locationInSelf:touch];
    //CGPoint regularizedPt = [boardStatus adjustLocation:localPoint isMove:true];
    EZCoord* coord = [boardStatus pointToBC:lastMovePoint];
    //I assume every touch will have move, otherwise I will be failed.
    //Let's check this out.
    EZDEBUG(@"Touch ended at:%@, last move Point:%@", NSStringFromCGPoint(localPoint), NSStringFromCGPoint(lastMovePoint));
    [self removeCursorButton];
    if(_chessmanType == kChessMan){
        
        //Basically, the color are determined by the
        coord.chessType = _chessmanSetType;
        [boardStatus putButtonByCoord:coord animated:YES];
    }else{
        NSString* markStr = [chessMarkChar objectAtIndex:(_allMarks .count % chessMarkChar.count)];
        [self putCharMark:markStr fontSize:30 coord:coord animAction:nil];
    }
    
}
//Will set chessMan type.
- (void) setChessmanType:(EZChessmanType)chessmanType
{
    //What do we need to do?
    //EZDEBUG(@"chessmanType:%i", chessmanType);
    if(chessmanType == kChessMark){
        
    }
    
    _chessmanType = chessmanType;
}


- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self removeCursorButton];
}


//Push current status to the stack, which can be recovered later.
- (void) pushStatus
{
    EZBoardSnapshot* snapshot = [self getSnapshot];
    [_snapshotStack addObject:snapshot];
}

- (void) popStatusWithoutApplying
{
     if(_snapshotStack.count > 0){
         [_snapshotStack removeAllObjects];
     }
}

//Pop the current status from the stack so that the stored status could be recovered.
- (void) popStatus
{
    EZDEBUG(@"I will pop snapshot, current stack count:%i",_snapshotStack.count);
    if(_snapshotStack.count > 0){
        EZBoardSnapshot* snapshot = [_snapshotStack lastObject];
        [self playSnapshot:snapshot];
        [_snapshotStack removeLastObject];
    }
}

//Get the snapshot of the board
- (EZBoardSnapshot*) getSnapshot
{
    //TODO
    EZBoardSnapshot* res = [[EZBoardSnapshot alloc] init];
    NSMutableArray* coords = [[NSMutableArray alloc] initWithCapacity:self.allSteps.count];
    for(EZChessPosition* cp in self.allSteps){
        [coords addObject:cp.coord];
    }
    
    NSArray* marks = [NSArray arrayWithArray:self.allMarks];
    
    res.coords = coords;
    res.marks = marks;
    res.showStep = showStep;
    res.showStepStarted = showStepStarted;
    return res;
}

//This is a total operation. mean the whole status will get recovered.
- (void) playSnapshot:(EZBoardSnapshot*)snapshot
{
    //This will clean all the marks and the moves and the regret stack.
    //Basically, it have nothing left after the cleanAll.
    EZDEBUG(@"I will recover all the status to the board");
    [self cleanAll];
    self.showStep = snapshot.showStep;
    self.showStepStarted = snapshot.showStepStarted;
    [self putChessmans:snapshot.coords animated:NO];
    [self putMarks:snapshot.marks];
}

@end
