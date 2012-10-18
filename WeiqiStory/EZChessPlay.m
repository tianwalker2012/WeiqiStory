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
#import "SBJson.h"
#import "EZExtender.h"
#import "EZEpisode.h"
#import "EZEpisodeCell.h"
#import "EZUILoader.h"


@interface EZChessPlay()
{
    //EZActionPlayer* actPlayer;
    EZChessBoard* chessBoard;
    EZPlayerStatus* playerStatus;
    //This board is used to allow user to try out his ideas.
    //
    EZChessBoard* playBoard;
}

@end


@implementation EZChessPlay

+ (CCScene*) scene
{
    CCScene* scene = [[CCScene alloc] init];
    
    EZChessPlay* playLayer = [[EZChessPlay alloc] init];
    
    [scene addChild:playLayer z:10 tag:10];

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

//What's the purpose of this method?
//It will remove all the facility UIViews with this scene. Otherwise those View will keep show off.
- (void) removeAllView
{
    [_actionTableView removeFromSuperview];
}

- (void) addAllView
{
    [[CCDirector sharedDirector].view addSubview:_actionTableView];
}

//I assume this will be called, when current scene are get in front of the visible region
- (void) onEnter
{
    [super onEnter];
    [self addAllView];
}

//I assume this will be called when current scene are removed out of the visible region.
- (void) onExit
{
    [super onExit];
    [self removeAllView];
}


- (id) init
{
    self = [super init];
    if(self){
        CGFloat leftTableWidth = 256.0;
        CGPoint tableTopRight = CGPointMake(256.0, 0.0);
        CGPoint glTopRight = [[CCDirector sharedDirector] convertToGL:tableTopRight];
        
       
        
        chessBoard = [[EZChessBoard alloc]initWithFile:@"weiqi-board-pad.png" touchRect:CGRectMake(60, 60, 648, 648) rows:19 cols:19];
        //Will chessBoard to align with the left, will move the rest of the button to the bottom of the screen.
        //chessBoard.anchorPoint = CGPointMake(0.0, 0.0);
        [chessBoard setPosition:ccp(chessBoard.boundingBox.size.width/2+glTopRight.x, chessBoard.boundingBox.size.height/2)];
        
        
        playBoard = [[EZChessBoard alloc]initWithFile:@"weiqi-board-pad.png" touchRect:CGRectMake(60, 60, 648, 648) rows:19 cols:19];
        [playBoard setPosition:ccp(chessBoard.boundingBox.size.width/2+glTopRight.x/2, chessBoard.boundingBox.size.height/2)];
        playBoard.scale = 0.7;
        playBoard.touchEnabled = false;
        
        //Make sure I am always before the chessBoard.
        playBoard.zOrder = chessBoard.zOrder + 1;
        
        [self addChild:chessBoard];
        chessBoard.scale = 0.7;
        EZDEBUG(@"tableTopRight:%@, glTopRight:%@, boundingBox:%@, middle point x:%f",NSStringFromCGPoint(tableTopRight), NSStringFromCGPoint(glTopRight),
                NSStringFromCGRect(chessBoard.boundingBox), chessBoard.boundingBox.size.width/2+glTopRight.x
                );
        //[self initScript];
        _actPlayer = [[EZActionPlayer alloc] initWithActions:nil chessBoard:chessBoard];
        //[chessBoard setScale:0.7];
        
        [CCMenuItemFont setFontSize:32];
        //LOADSOUNDEFFECT([NSArray arrayWithObjects:@"enemy.wav",nil]);
       
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
        
        CCMenuItem* playBySelfMenu = [CCMenuItemFont itemWithString:@"开始演练" block:^(id sender){
            //I assume the chessboard should always disable the touch.
            //Why, in the play mode it is mostly look at what I am doing, right?
            CCMenuItemFont* curMenu = sender;
            if(playBoard.touchEnabled == false){//Mean not on playboard yet
                chessBoard.touchEnabled = false;
                playBoard.touchEnabled = true;
            
                [playBoard cleanAll];
                NSArray* allChessMoves = chessBoard.getAllChessMoves;
                [playBoard putChessmans:allChessMoves animated:NO];
                NSArray* allMarks = chessBoard.allMarks;
                [playBoard putMarks:allMarks];
                [self addChild:playBoard];
                [curMenu setString:@"停止演练"];
            }else {
                playBoard.touchEnabled = false;
                chessBoard.touchEnabled = true;
                [playBoard removeFromParentAndCleanup:NO];//I assume No Mean I can reuse again.
                [curMenu setString:@"开始演练"];
            }
            //chessBoard.touchEnabled = false;
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
        
        
        
        CCMenu* menu = [CCMenu menuWithItems:replayMenu, prevMenu, nextMenu, playMenu,playBySelfMenu, backToEditorMenu, nil];
        [menu alignItemsHorizontallyWithPadding:10
         ];
        
        //menu.anchorPoint = CGPointMake(0.0, 0.0);
        //menu.position = ccp(glTopRight.x+200,22);
        //EZDEBUG(@"Menu boundingBox:%@", NSStringFromCGRect(menu.boundingBox));
        //[self addChild:menu z:-2];
        
        //CCNode* menuNode = [[CCNode alloc]init];
        //menuNode.contentSize = CGSizeMake(768, 100);
        menu.anchorPoint = ccp(0,0);
        menu.position = ccp(glTopRight.x + 400, 45);
        [self addChild:menu];
        //menuNode.anchorPoint = ccp(0,0);
        //menuNode.position = ccp(glTopRight.x, 0.0);
        //[self addChild:menuNode];
        
        _actionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, leftTableWidth, 768) style:UITableViewStylePlain];
        _actionTableView.dataSource = self;
        _actionTableView.delegate = self;
        //EZDEBUG(@"The windos is:%@", [CCDirector sharedDirector].view.window);
        
        
        EZDEBUG(@"Orientation:%@", [CCDirector sharedDirector].view.orientationToStr);
        //[[CCDirector sharedDirector].view addSubview:_actionTableView];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _epsides.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EZDEBUG(@"cellForRow");
    EZEpisodeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Episode"];
    if(cell == nil){
        cell = [EZUILoader createEpisodeCell];
    }
    
    //EZAction* act = [_actPlayer.actions objectAtIndex:indexPath.row];
    EZEpisode* episode = [_epsides objectAtIndex:indexPath.row];
    //cell.textLabel.text = [NSString stringWithFormat:@"Class:%@, SyncType:%@", act.class, act.syncType==kSync?@"Sync":@"Async"];
    cell.name.text = episode.name;//[NSString stringWithFormat:@"Name:%@, intro:%@", episode.name, episode.introduction];
    cell.introduces.text = episode.introduction;
    
    //EZDEBUG(@"cell thumbNail:%@", cell.thumbNail);
    //EZDEBUG(@"Original thumbNail image:%@", cell.thumbNail.image);
    
    cell.thumbNail.image = episode.thumbNail;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //EZDEBUG(@"Selected:%i", indexPath.row);
    EZEpisode* episode = [_epsides objectAtIndex:indexPath.row];
    //EZDEBUG(@"Clean all moves");
    [chessBoard cleanAll];
    //EZDEBUG(@"Complete clean");
    _actPlayer.actions = episode.actions;
}

//Introduce. 
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
@end
