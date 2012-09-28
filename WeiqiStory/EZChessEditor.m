//
//  EZChessEditor.m
//  WeiqiStory
//
//  Created by xietian on 12-9-23.
//
//

#import "EZChessEditor.h"
#import "EZChessBoard.h"
#import "EZConstants.h"
#import "EZEditorStatus.h"
#import "EZActionPlayer.h"
#import "EZCoord.h"
#import "EZChessPlay.h"
#import "EZCleanAction.h"

@interface EZChessEditor()
{
    EZChessBoard* chessBoard;
    
    EZChessBoard* previewBoard;
    
    EZEditorStatus* editorStatus;
    CCLabelAtlas* statusText;
    EZActionPlayer* actPlayer;
    
    //The ActPlayer will work on current actor.
    //So that once I add clean or preset, I could immediately see the effects.
    EZActionPlayer* currActPlayer;
    EZAction* presetAction;
    
}

@end


@implementation EZChessEditor


+ (CCScene*) scene
{
    CCScene* scene = [[CCScene alloc] init];
    
    EZChessEditor* editor = [[EZChessEditor alloc] init];
    
    [scene addChild:editor];
    
    return scene;
}


- (void) setUpStatus
{
    CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
	statusText = [[CCLabelAtlas alloc]  initWithString:@"status" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
	
    
	[CCTexture2D setDefaultAlphaPixelFormat:currentFormat];
    
	[statusText setPosition:ccp(500,34)];
    [self addChild:statusText];

}

- (void) initScript
{
    
}

- (void) playMostRecent
{
    
}
//What's the meaning init?
//Initialize the the class.
- (id) init
{
    self = [super init];
    if(self){
        [self setUpStatus];
        chessBoard = [[EZChessBoard alloc]initWithFile:@"weiqi-board-pad.png" touchRect:CGRectMake(60, 60, 648, 648) rows:19 cols:19];
        [chessBoard setPosition:ccp(chessBoard.boundingBox.size.width/2, chessBoard.boundingBox.size.height/2)];
        [self addChild:chessBoard];
        
        previewBoard = [[EZChessBoard alloc] initWithFile:@"weiqi-board-pad.png" touchRect:CGRectMake(60, 60, 648, 648) rows:19 cols:19];
        [previewBoard setPosition:ccp(previewBoard.boundingBox.size.width/4, previewBoard.boundingBox.size.height/4)];
        [previewBoard setScale:0.5];
        previewBoard.touchEnabled = false;
        CCLabelTTF* statusLabel = [CCLabelTTF labelWithString:@"Status label" fontName:@"Arial" fontSize:30];
        
        NSInteger popupZOrder = 200;
        //[self addChild:previewBoard z:popupZOrder];
        
        //Will change the chessBoard later
        actPlayer = [[EZActionPlayer alloc] initWithActions:nil chessBoard:previewBoard];
                
        
        currActPlayer = [[EZActionPlayer alloc] initWithActions:nil chessBoard:chessBoard];
        //One test cover all the functionality
        
        [chessBoard setScale:0.7];
        
        [CCMenuItemFont setFontSize:32];
        
        editorStatus = [[EZEditorStatus alloc] init];
        editorStatus.chessBoard = chessBoard;
        
        //LOADSOUNDEFFECT([NSArray arrayWithObjects:@"enemy.wav",nil]);
        CCMenuItem* recording = [CCMenuItemFont itemWithString:@"录音" block:^(id sender){
            [editorStatus start:kLectures];
        }];
        CCMenuItem* startPresetting = [CCMenuItemFont itemWithString:@"开始预设" block:^(id sender){
            [editorStatus start:kPreSetting];
        }];
        
        CCMenuItem* startPlainMove = [CCMenuItemFont itemWithString:@"开始落子" block:^(id sender){
            [editorStatus start:kPlantMoves];
        }];
        
        
        CCMenuItem* save = [CCMenuItemFont itemWithString:@"保存" block:^(id sender){
            [editorStatus save];
        }];
        
        //One menu handle all the color switch
        CCMenuItemFont* selectChessColor = [CCMenuItemFont itemWithString:@"正常落子" block:^(id sender){
                if(chessBoard.chessmanSetType == kDetermineByBoard){
                    [sender setString:@"落黑子"];
                    chessBoard.chessmanSetType = kBlackChess;
                }else if(chessBoard.chessmanSetType == kBlackChess){
                    [sender setString:@"落白子"];
                    chessBoard.chessmanSetType = kWhiteChess;
                }else{
                    [sender setString:@"正常落子"];
                    chessBoard.chessmanSetType = kDetermineByBoard;
                }
        }];
        
        CCMenuItem* toggleBoardColor = [CCMenuItemFont itemWithString:chessBoard.isCurrentBlack?@"下一手黑色":@"下一手白色" block:^(id sender){
            [chessBoard toggleColor];
            //[statusLabel setString:[NSString stringWithFormat:@"Next chess color:%@",chessBoard.isCurrentBlack?@"Black":@"White"]];
            [sender setString:chessBoard.isCurrentBlack?@"下一手黑色":@"下一手白色"];
        }];
        
        CCMenuItem* toggleMark = [CCMenuItemFont itemWithString:@"落子类型：棋子" block:^(id sender){
            if(chessBoard.chessmanType == kChessMan){
                [sender setString:@"落子类型：Mark"];
                chessBoard.chessmanType = kChessMark;
            }else{
                [sender setString:@"落子类型：棋子"];
                chessBoard.chessmanType = kChessMan;
            }
        }];
        
        CCMenuItem* showHand = [CCMenuItemFont itemWithString:editorStatus.showStep?@"显示手数":@"不显示手数" block:^(id sender){
            editorStatus.showStep = !editorStatus.showStep;
            [sender setString:editorStatus.showStep?@"显示手数":@"不显示手数"];
            [editorStatus insertShowHand];
            [chessBoard setShowStepStarted:chessBoard.allSteps.count];
            [chessBoard setShowStep:editorStatus.showStep];
        }];
        
        
        CCMenuItem* addPreset = [CCMenuItemFont itemWithString:@"回到本节开始" block:^(id sender){
            [editorStatus insertPreset];
            currActPlayer.actions = @[editorStatus.presetAction];
            [currActPlayer playOneStep:0 completeBlock:nil];
            
        }];
        
       
        
        
        CCMenuItem* addCleanAction = [CCMenuItemFont itemWithString:@"增加清盘动作" block:^(id sender){
            [editorStatus addCleanAction];
            [statusLabel setString:@"Added clean actions"];
            [chessBoard cleanAllMoves];
            EZDEBUG(@"Added clean Action");
        }];
        
        CCMenuItem* delete = [CCMenuItemFont itemWithString:@"删除当前Action" block:^(id sender){
            [editorStatus removeLast];
        }];
        
        
        CCMenuItem* preView = [CCMenuItemFont itemWithString:@"预览当前Action" block:^(id sender){
            EZDEBUG(@"Will play:%i",editorStatus.actions.count);
            actPlayer.actions = editorStatus.actions;
            [self addChild:previewBoard z:popupZOrder];
            [actPlayer playFrom:(editorStatus.actions.count -1) completeBlock:^(){
                EZDEBUG(@"Complete board get called");
                [previewBoard removeFromParentAndCleanup:NO];
            }];
            
        }];
        
       /**
        CCMenuItem* preViewAll = [CCMenuItemFont itemWithString:@"预览全部" block:^(id sender){
            EZDEBUG(@"Review all");
            actPlayer.actions = editorStatus.actions;
            [previewBoard addChild:previewBoard z:popupZOrder];
            [actPlayer playFrom:0 completeBlock:^(){
                EZDEBUG(@"Complete play for whole board");
                [previewBoard removeFromParentAndCleanup:NO];
            }];
            
        }];
        **/
        CCMenuItem* regretMove = [CCMenuItemFont itemWithString:@"回退一步棋" block:^(id sender){
            EZDEBUG(@"Back on step");
            [chessBoard regretSteps:1 animated:YES];
        }];
        
        
        /**
        CCMenuItem* addView = [CCMenuItemFont itemWithString:@"增加新窗口" block:^(id sender){
            
            UIView* simpleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            simpleView.backgroundColor = [UIColor redColor];
            [[CCDirector sharedDirector].view.window addSubview:simpleView];
        }];
        **/
        
        /**
        CCMenuItem* addMark = [CCMenuItemFont itemWithString:@"增加Mark" block:^(id sender){
            EZDEBUG(@"Add mark get called");
            CCLabelTTF*  markText = [CCLabelTTF labelWithString:@"C" fontName:@"Arial" fontSize:40];
            [chessBoard putMark:markText coord:[[EZCoord alloc] init:10 y:10] animAction:nil];
        }];
        
        CCMenuItem* removeMark = [CCMenuItemFont itemWithString:@"删除Mark" block:^(id sender){
            EZDEBUG(@"Add mark get called");
            [chessBoard removeMark:[[EZCoord alloc] init:10 y:10] animAction:nil];
        }];
         **/
       
        CCMenuItem* goToPlayer = [CCMenuItemFont itemWithString:@"去播放界面" block:^(id sender){
            EZDEBUG(@"Will go to player interface");
            CCScene* playFace = [EZChessPlay sceneWithActions:editorStatus.actions];
            [[CCDirector sharedDirector] pushScene:playFace];
        }];
        [editorStatus setBtnPreset:startPresetting audio:recording plantMove:startPlainMove save:save remove:delete preview:preView previewAll:nil];
        //editorStatus.statusText = statusText;
        editorStatus.statusLabel = statusLabel;
        [statusLabel setPosition:ccp(500, 34)];
        [self addChild:statusLabel];
        CCMenu* menu = [CCMenu menuWithItems:recording,startPresetting,startPlainMove,save,selectChessColor,toggleBoardColor,toggleMark,showHand,addPreset,addCleanAction, preView,delete,regretMove,goToPlayer,nil];
        
        [menu alignItemsVerticallyWithPadding:15];
        
        menu.position = ccp(900, 400);
        [self addChild:menu z:-2];
    }
    return self;
}


@end
