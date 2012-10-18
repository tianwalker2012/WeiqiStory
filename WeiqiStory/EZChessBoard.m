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
        chessMarkChar = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
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
        _allMarks = [[NSMutableArray alloc] init];
        boardStatus = [[EZBoardStatus alloc] initWithBound:rect rows:rws cols:cls];
        boardStatus.front = self;
        [self initializeCursor];
    }
    return self;
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

//What's the purpose of this method?
//I will put a specified mark on the board.
- (void) putMark:(CCNode*)mark coord:(EZCoord*)coord animAction:(CCAction*)action
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
    [self addChild:mark z:MarkZOrder+marks.count];
    if(action){
        [mark runAction:action];
    }
}


//Put marks on the board.
- (void) putMarks:(NSArray*) marks
{
    for(EZChessMark* mark in marks){
        [self putCharMark:mark.text fontSize:mark.fontSize coord:mark.coord animAction:nil];
    }
}

- (void) putCharMark:(NSString*)str fontSize:(NSInteger)fontSize coord:(EZCoord*)coord animAction:(CCAction*)action
{
    //NSString* markStr = [chessMarkChar objectAtIndex:(coordToMarks.count % chessMarkChar.count)];
    CCLabelTTF*  markText = [CCLabelTTF labelWithString:str fontName:@"Arial" fontSize:fontSize];
    markText.color = ChessMarkColor;
    NSMutableArray* marks = [coordToMarks objectForKey:coord.getKey];
    if(!marks){
        marks = [[NSMutableArray alloc] init];
        [coordToMarks setValue:marks forKey:coord.getKey];
    }
    //EZDEBUG(@"coordMarks size:%i, object pointer:%i, marks size:%i",coordToMarks.count, (int)coordToMarks, marks.count);
    EZChessMark* markObj = [[EZChessMark alloc] initWithText:str fontSize:fontSize coord:coord];
    markObj.mark = markText;
    [marks addObject:markObj];
    [_allMarks addObject:markObj];
    CGPoint pt = [boardStatus bcToPoint:coord];
    [markText setPosition:pt];
    [self addChild:markText z:MarkZOrder+marks.count];
    if(action){
        [markText runAction:action];
    }
    
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
    
    EZDEBUG(@"Will remove marks at %@", coord);
    NSMutableArray* marks = [coordToMarks objectForKey:coord.getKey];
    EZDEBUG(@"Fetched marks:%@",marks);
    if(marks){
        for(EZChessMark* mk in marks){
            if(action){
                CCAction* removeAction = [CCSequence actions:action, [CCCallBlock actionWithBlock:^{
                    [mk.mark removeFromParentAndCleanup:NO];
                }]];
                [mk.mark runAction:removeAction];
            }else{
                EZDEBUG(@"Will remove from parent, mark:%@",mk.mark);
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
    [marks removeObject:marks];
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
}

- (void) putButton:(EZCoord*)coord isBlack:(BOOL)isBlack animated:(BOOL)animated
{
    //Let's check it on iPad
    
    CGPoint pt = [boardStatus bcToPoint:coord];
    EZDEBUG(@"Button on:%@", NSStringFromCGPoint(pt));
    EZChessman* btn = nil;
    if(isBlack){
        btn = [[EZChessman alloc] initWithSpriteFrameName:BlackBtnName step:boardStatus.steps showStep:showStep isBlack:isBlack showedStep:boardStatus.steps - showStepStarted];
    }else{
        btn = [[EZChessman alloc] initWithSpriteFrameName:WhiteBtnName step:boardStatus.steps showStep:showStep isBlack:isBlack showedStep:boardStatus.steps - showStepStarted];
    }
    [btn setZOrder:ExistingChess];
    [btn setPosition:pt];
    [coordToButtons setValue:btn forKey:coord.getKey];
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
    [cursor setPosition:regularizedPt];
    [self addChild:cursor];
}

- (void) initializeCursor
{
    virtualWhite = [CCSprite spriteWithFile:WhiteBtnName];
    virtualBlack = [CCSprite spriteWithFile:BlackBtnName];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:virtualWhite.displayFrame name:WhiteBtnName];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:virtualBlack.displayFrame name:BlackBtnName];
    //[whiteBtn setPosition:ccp(size.width/2+36, size.height/2)];
    [virtualBlack setZOrder:OverExistingChess];
    [virtualWhite setZOrder:OverExistingChess];
    
    virtualWhite.opacity = 128;
    virtualBlack.opacity = 128;
    virtualBlack.scale = 2.0;
    virtualWhite.scale = 2.0;
}


- (void) moveCursorButton:(CGPoint)point
{
    [cursor setPosition:point];
}


//Remove the cursor as the name implied.
- (void) removeCursorButton
{
    [cursor removeFromParentAndCleanup:YES];
}



//Keep it simple and stupid, assume the addTargetedDelegate are the power equal method call
- (void) setTouchEnabled:(BOOL)touchEd
{
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
        [boardStatus regretOneStep];
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


- (void) regretMarks:(NSInteger)steps animated:(BOOL)animated
{
    for(int i = 0; i < steps; i++){
        if(_allMarks.count > 0){
            EZChessMark* cm = _allMarks.lastObject;
            [self removeMarks:cm];
        }else{
            break;
        }
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
    EZDEBUG(@"TouchRect:%@, touchPoint:%@",NSStringFromCGRect(touchRect), NSStringFromCGPoint(localPt));
    if(CGRectContainsPoint(touchRect, localPt)){
        EZDEBUG(@"Will plant chessman");
        [self putCursorButton:regularizedPt];
        return YES;
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint localPoint = [self locationInSelf:touch];
    CGPoint regularizedPt = [boardStatus adjustLocation:localPoint];
    EZDEBUG(@"Move local GL:%@, ajusted: %@", NSStringFromCGPoint(localPoint), NSStringFromCGPoint(regularizedPt));
    [self moveCursorButton:regularizedPt];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint localPoint = [self locationInSelf:touch];
    CGPoint regularizedPt = [boardStatus adjustLocation:localPoint];
    EZDEBUG(@"Touch ended at:%@, adjusted: %@", NSStringFromCGPoint(localPoint), NSStringFromCGPoint(regularizedPt));
    [self removeCursorButton];
    if(_chessmanType == kChessMan){
        EZCoord* coord = [boardStatus pointToBC:localPoint];
        //Basically, the color are determined by the
        coord.chessType = _chessmanSetType;
        [boardStatus putButtonByCoord:coord animated:YES];
    }else{
        NSString* markStr = [chessMarkChar objectAtIndex:(coordToMarks.count % chessMarkChar.count)];
        //CCLabelTTF*  markText = [CCLabelTTF labelWithString:markStr fontName:@"Arial" fontSize:40];
        EZCoord* coord = [boardStatus pointToBC:localPoint];
        //[chessBoard putMark:markText coord:[[EZCoord alloc] init:10 y:10] animAction:nil];
        //[self putCharMark:markText coord:coord animAction:nil];
        [self putCharMark:markStr fontSize:30 coord:coord animAction:nil];
    }
    
}
//Will set chessMan type.
- (void) setChessmanType:(EZChessmanType)chessmanType
{
    //What do we need to do?
    EZDEBUG(@"chessmanType:%i", chessmanType);
    if(chessmanType == kChessMark){
        
    }
    
    _chessmanType = chessmanType;
}


- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self removeCursorButton];
}


@end
