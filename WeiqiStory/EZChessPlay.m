//
//  EZChessPlay.m
//  FirstCocos2d
//
//  Created by xietian on 12-9-19.
//
//

#import "EZChessPlay.h"
#import "EZChessBoard.h"
#import "EZCoord.h"
#import "EZConstants.h"
#import "EZSoundManager.h"
#import "EZAction.h"
#import "EZActionPlayer.h"
#import "EZPlayerStatus.h"

@interface EZChessPlay()
{
    //EZActionPlayer* actPlayer;
    EZChessBoard* chessBoard;
    EZPlayerStatus* playerStatus;
}

@end


@implementation EZChessPlay

+ (CCScene*) scene
{
    CCScene* scene = [[CCScene alloc] init];
    
    EZChessPlay* playLayer = [[EZChessPlay alloc] init];
    
    [scene addChild:playLayer];

    return scene;
}

+ (CCScene*) sceneWithActions:(NSArray*)actions
{
    CCScene* scene = [[CCScene alloc] init];
    
    EZChessPlay* playLayer = [[EZChessPlay alloc] init];
    
    [playLayer.actPlayer setActions:actions];
    
    [scene addChild:playLayer];
    
    return scene;

}

/**
- (void) initScript
{
    EZAction* preAction = [[EZAction alloc] init];
    preAction.actionType = kPreSetting;
    preAction.preSetMoves = [NSArray arrayWithObjects:[[EZCoord alloc]init:15 y:12],[[EZCoord alloc] init:14 y:13], [[EZCoord alloc] init:13 y:14], nil];
    
    EZAction* action = [[EZAction alloc] init];
    action.actionType = kLectures;
    action.audioFiles = [NSArray arrayWithObjects:@"chess-plant.wav",@"chess-plant.wav",nil];
    
    EZAction* action1 = [[EZAction alloc] init];
    action1.actionType = kPlantMoves;
    action1.plantMoves = @[[[EZCoord alloc]init:4 y:12],[[EZCoord alloc] init:5 y:13], [[EZCoord alloc] init:6 y:14]];
    action1.unitDelay = 1.0f;
    
    EZAction* action2 = [[EZAction alloc] init];
    action2.actionType = kPlantMoves;
    action2.plantMoves = @[[[EZCoord alloc]init:2 y:15],[[EZCoord alloc] init:7 y:19], [[EZCoord alloc] init:17 y:2]];
    action2.unitDelay = 1.0f;
    
    EZAction* actionV1 = [[EZAction alloc] init];
    actionV1.actionType = kLectures;
    actionV1.audioFiles = [NSArray arrayWithObjects:@"enemy.wav",nil];
    
    
    EZAction* action3 = [[EZAction alloc] init];
    action3.actionType = kPlantMoves;
    action3.plantMoves = @[[[EZCoord alloc]init:9 y:13]];
    action3.unitDelay = 1.0f;
    
    EZDEBUG(@"Start playing actions");
    

}
**/
 
//What's the meaning init?
//Initialize the the class.
- (id) init
{
    self = [super init];
    if(self){
        chessBoard = [[EZChessBoard alloc]initWithFile:@"weiqi-board-pad.png" touchRect:CGRectMake(60, 60, 648, 648) rows:19 cols:19];
        [chessBoard setPosition:ccp(chessBoard.boundingBox.size.width/2, chessBoard.boundingBox.size.height/2)];
        [self addChild:chessBoard];
        
        //[self initScript];
        _actPlayer = [[EZActionPlayer alloc] initWithActions:nil chessBoard:chessBoard];
        /**
        CCSprite* board2 = [CCSprite spriteWithFile:@"weiqi-board-pad.png" rect:CGRectMake(800, 500, 100, 100)];
        board2.position = CGPointMake(500, 500);
        [self addChild:board2];
        **/
        
        //One test cover all the functionality
        
         //I will use this to test my preset on the beginning of the game.
        [chessBoard putChessmans:[NSArray arrayWithObjects:[[EZCoord alloc] init:1 y:2],[[EZCoord alloc] init:2 y:5],[[EZCoord alloc]init:8 y:9], nil] animated:NO];
        [chessBoard setScale:0.7];
        
        [CCMenuItemFont setFontSize:32];
        LOADSOUNDEFFECT([NSArray arrayWithObjects:@"enemy.wav",nil]);
        CCMenuItem* introduction = [CCMenuItemFont itemWithString:@"第一幕" block:^(id sender){
            [chessBoard putChessmans:[NSArray arrayWithObjects:[[EZCoord alloc] init:5 y:5],[[EZCoord alloc] init:6 y:6],[[EZCoord alloc]init:7 y:7], nil] animated:NO];
            EZDEBUG(@"Start play sound effects");
            PLAYSOUNDEFFECT(firstVoice.wav);
        }];
        CCMenuItem* regret = [CCMenuItemFont itemWithString:@"悔棋" block:^(id sender){
            [chessBoard regretSteps:1 animated:NO];
        }];
        
        CCMenuItem* showSteps = [CCMenuItemFont itemWithString:@"显示手数" block:^(id sender){
            chessBoard.showStep = !chessBoard.showStep;
        }];
        
        CCMenuItem* showStepStart = [CCMenuItemFont itemWithString:@"从10开始显示" block:^(id sender){
            chessBoard.showStep = YES;
            chessBoard.showStepStarted = 10;
        }];
        
        
        CCMenuItem* prevMenu = [CCMenuItemFont itemWithString:@"后退" block:^(id sender){
            [_actPlayer prev];
        }];
        
        CCMenuItem* replayMenu = [CCMenuItemFont itemWithString:@"重放" block:^(id sender){
            [_actPlayer replay];
        }];
        
        CCMenuItem* nextMenu = [CCMenuItemFont itemWithString:@"前进" block:^(id sender){
            EZDEBUG(@"Will play next");
            [_actPlayer next];
        }];
        
        CCMenuItem* backToEditorMenu = [CCMenuItemFont itemWithString:@"回到编辑界面" block:^(id sender){
            [[CCDirector sharedDirector] popScene];
            //Important, otherwise will not get event.
            chessBoard.touchEnabled = false;
        }];
        
        playerStatus = [[EZPlayerStatus alloc] initWithPlay:nil prev:prevMenu next:nextMenu replay:replayMenu];
        CCMenuItem* playMenu = [CCMenuItemFont itemWithString:@"播放" block:^(id sender){
            [playerStatus play];
        }];
        
        
        playerStatus.playButton = playMenu;
        playerStatus.player = _actPlayer;
        
        _actPlayer.completedHandler = playerStatus;
        
        
        
        CCMenu* menu = [CCMenu menuWithItems:introduction,regret,showSteps,showStepStart,replayMenu, prevMenu, nextMenu, playMenu, backToEditorMenu, nil];
        [menu alignItemsVerticallyWithPadding:40];
        
        menu.position = ccp(900, 400);
        [self addChild:menu z:-2];
    }
    return self;
}

@end
