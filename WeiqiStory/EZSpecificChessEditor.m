//
//  EZSpecificChessEditor.m
//  WeiqiStory
//
//  Created by xietian on 12-12-18.
//
//

#import "EZSpecificChessEditor.h"
#import "EZChessEditor.h"
#import "EZChessBoard.h"
#import "EZConstants.h"
#import "EZEditorStatus.h"
#import "EZActionPlayer.h"
#import "EZCoord.h"
#import "EZChessPlay.h"
#import "EZCleanAction.h"
#import "EZEpisodeInputer.h"
#import "EZExtender.h"
#import <QuartzCore/QuartzCore.h>
#import "EZChess2Image.h"
#import "EZEpisode.h"
#import "EZChessPresetAction.h"
#import "EZEpisodeVO.h"
#import "EZEpisodeUploader.h"
#import "EZAudioFile.h"
#import "EZPlayPage.h"
#import "EZFixBrokenPage.h"

@interface EZSpecificChessEditor()
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
    
    NSMutableArray* episodes;
    
    //EZEpisodeVO* currentEpisode;
    
    NSArray* basicPattern;
    
    CCLabelTTF* statusLabel;
    
    NSMutableArray* audioFiles;
    
}

@end


@implementation EZSpecificChessEditor


+ (CCScene*) scene
{
    CCScene* scene = [[CCScene alloc] init];
    
    EZSpecificChessEditor* editor = [[EZSpecificChessEditor alloc] init];
    
    [scene addChild:editor];
    
    return scene;
}

- (CCScene*) createScene
{
    CCScene* scene = [[CCScene alloc] init];
    [scene addChild:self];
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


//What's the meaning init?
//Initialize the the class.
- (id) initWithEpisode:(EZEpisodeVO*)epv playedPos:(NSInteger)pos
{
    self = [super init];
    if(self){
        [self setUpStatus];
        audioFiles = [[NSMutableArray alloc] init];
        chessBoard = [[EZChessBoard alloc]initWithFile:@"weiqi-board-pad.png" touchRect:CGRectMake(60, 60, 648, 648) rows:19 cols:19];
        [chessBoard setPosition:ccp(chessBoard.boundingBox.size.width/2, chessBoard.boundingBox.size.height/2)];
        [self addChild:chessBoard];
        
        previewBoard = [[EZChessBoard alloc] initWithFile:@"weiqi-board-pad.png" touchRect:CGRectMake(60, 60, 648, 648) rows:19 cols:19];
        [previewBoard setPosition:ccp(previewBoard.boundingBox.size.width/4, previewBoard.boundingBox.size.height/4)];
        [previewBoard setScale:0.5];
        previewBoard.touchEnabled = false;
        statusLabel = [CCLabelTTF labelWithString:@"Status label" fontName:@"Arial" fontSize:30];
        
        NSInteger popupZOrder = 200;
        episodes = [[NSMutableArray alloc] init];
        //[self addChild:previewBoard z:popupZOrder];
        
        //Will change the chessBoard later
        
        _currentEpisode = epv;
        _removedPos = pos-1;
        _changedActions = [[NSMutableArray alloc] initWithArray:epv.actions];
        //[_changedActions removeObjectAtIndex:_removedPos];
        
        actPlayer = [[EZActionPlayer alloc] initWithActions:nil chessBoard:previewBoard inMainBundle:false];
        
        
        //I assume not record any audio here.
        currActPlayer = [[EZActionPlayer alloc] initWithActions:_changedActions chessBoard:chessBoard inMainBundle:YES];
        
        //The pos will not including this pos.
        [currActPlayer forwardFrom:0 to:_removedPos];
        
        EZAction* removedAction = [_changedActions objectAtIndex:_removedPos];
        //[_changedActions removeObjectAtIndex:_removedPos];
        
        [statusLabel setString:[NSString stringWithFormat:@"%@,Pos:%i, totla:%i,removed class:%@",epv.name, _removedPos, epv.actions.count, [removedAction class]]];
        //One test cover all the functionality
        
        [chessBoard setScale:0.7];
        
        [CCMenuItemFont setFontSize:32];
        
        editorStatus = [[EZEditorStatus alloc] init];
        editorStatus.chessBoard = chessBoard;
        editorStatus.player = currActPlayer;
        
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
            EZDEBUG(@"Save get called, %i, kLetures:%i", editorStatus.curEditType, kLectures);
            if(editorStatus.curEditType == kLectures){
                EZAudioFile* audioFile = [[EZAudioFile alloc] init];
                audioFile.fileName = editorStatus.audioFileName;
                //audioFile.inMainBundle = false;
                //audioFile.downloaded = false;
                //[currentEpisode.audioFiles addObject:editorStatus.audioFileName];
                EZDEBUG(@"Add audioFile to list");
                [audioFiles addObject:audioFile];
                EZDEBUG(@"Add audio file:%@, total count:%i", editorStatus.audioFileName, audioFiles.count);
            }
            [editorStatus save];
            //What if I added more steps
            [_changedActions insertObject:[editorStatus.actions lastObject] atIndex:_removedPos++];
            EZDEBUG(@"Quit save");
        }];
        
        
        CCMenuItem* saveAsBegin = [CCMenuItemFont itemWithString:@"保存为本节开始" block:^(id sender){
            EZDEBUG(@"Save as the begining of episode");
            [editorStatus saveAsEpisodeBegin];
            basicPattern = chessBoard.getAllChessMoves;
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
            [editorStatus addCleanAction:kCleanAll];
            [statusLabel setString:@"Added clean actions"];
            [chessBoard cleanAllMoves];
            EZDEBUG(@"Added clean Action");
        }];
        
        CCMenuItem* delete = [CCMenuItemFont itemWithString:[NSString stringWithFormat:@"删除Action,Pos:%i",_removedPos] block:^(id sender){
            //[editorStatus removeLast];
            //[sender setString:[NSString stringWithFormat:@"删除Action,Pos:%i",editorStatus.actions.count]];
            EZDEBUG(@"Let's remove the current actions, %i", _removedPos);
            [_changedActions removeObjectAtIndex:_removedPos];
        }];
        
        
        CCMenuItem* preView = [CCMenuItemFont itemWithString:@"预览Action" block:^(id sender){
            EZDEBUG(@"Will play:%i",editorStatus.actions.count);
            actPlayer.actions = editorStatus.actions;
            [self addChild:previewBoard z:popupZOrder];
            [previewBoard cleanAll];
            if((editorStatus.actions.count - 1) > 0){
                [actPlayer forwardFrom:0 to:editorStatus.actions.count - 1];
            }
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
            //CCScene* playFace = [EZChessPlay sceneWithActions:editorStatus.actions];
            //EZChessPlay* playUI = (EZChessPlay*)[playFace getChildByTag:10];
            //playUI.epsides = episodes;
            //[[CCDirector sharedDirector] pushScene:playFace];
            _currentEpisode.inMainBundle = true;
            _currentEpisode.actions = _changedActions;
            EZFixBrokenPage* playPage = [[EZFixBrokenPage alloc] initWithEpisode:_currentEpisode currentPos:0];
            [[CCDirector sharedDirector] pushScene:[playPage createScene]];
        }];
        
        /**
         CCMenuItem* storeCurrentView = [CCMenuItemFont itemWithString:@"保存当前界面" block:^(id sender){
         EZDEBUG(@"Add a chessboard");
         EZCoord* coord = [[EZCoord alloc] initChessType:kWhiteChess x:0 y:0];
         EZCoord* coord1 = [[EZCoord alloc] initChessType:kWhiteChess x:18 y:18];
         
         EZCoord* coord2 = [[EZCoord alloc] initChessType:kWhiteChess x:0 y:18];
         EZCoord* coord3 = [[EZCoord alloc] initChessType:kWhiteChess x:18 y:0];
         
         UIImage* image = [EZChess2Image generateChessBoard:@[coord, coord1, coord2, coord3] size:CGSizeMake(200, 200)];
         UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
         //imageView.contentMode = UIViewContentModeCenter;
         imageView.contentStretch = CGRectMake(0.2, 0.2, 0.8, 0.8);
         imageView.frame = CGRectMake(0, 0, 300, 300);
         [[CCDirector sharedDirector].view addSubview:imageView];
         }];
         **/
        /**
         CCMenuItem* showScreenShot = [CCMenuItemFont itemWithString:@"保存截屏" block:^(id sender){
         EZDEBUG(@"Save screen shot");
         [CCDirector sharedDirector].takeOneShot = true;
         [self performBlock:^(){
         EZDEBUG(@"Collect result");
         UIImage* image = [CCDirector sharedDirector].screenShot;
         UIImage* shrinkedImg = [EZChess2Image shrinkImage:image size:CGSizeMake(400, 300)];
         UIImageView* imageView = [[UIImageView alloc] initWithImage:shrinkedImg];
         [[CCDirector sharedDirector].view addSubview:imageView];
         } withDelay:0.2];
         }];
         **/
        CCMenuItem* uploadAll = [CCMenuItemFont itemWithString:@"上传全部" block:^(id sender){
            EZDEBUG(@"Upload all");
            //[self setStatus:[NSString stringWithFormat:@"Will upload %i",  episodes.count]];
            EZEpisodeUploader* uploader = [[EZEpisodeUploader alloc] init];
            uploader.uploadBaseURL = UploadBaseURL;
            uploader.downloadBaseURL = DownloadBaseURL;
            [uploader uploadEpisodes:episodes completBlk:nil];
            EZDEBUG(@"upload done....");
        }];
        CCMenuItem* saveEpisode = [CCMenuItemFont itemWithString:@"保存本集" block:^(id sender){
            NSString* orient = [[CCDirector sharedDirector].view orientationToStr];
            EZDEBUG(@"Store current episode, direction:%@", orient);
            
            EZEpisodeVO* episode = [[EZEpisodeVO alloc] init];
            episode.basicPattern = basicPattern;//((EZChessPresetAction*)editorStatus.presetAction).preSetMoves;
            ///episode
            episode.actions = [NSArray arrayWithArray:editorStatus.actions];
            
            episode.audioFiles = [NSArray arrayWithArray:audioFiles];
            EZDEBUG(@"AudioFile count:%i", episode.audioFiles.count);
            
            [audioFiles removeAllObjects];
            
            EZEpisodeInputer* episodeInputer = [[EZEpisodeInputer alloc] initWithNibName:@"EZEpisodeInputer" bundle:nil];
            EZDEBUG(@"Nib loaded successfully");
            episodeInputer.modalPresentationStyle = UIModalPresentationFormSheet;
            episodeInputer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            episodeInputer.confirmBlock = ^(id sender){
                EZDEBUG(@"Confirm get called");
                EZEpisodeInputer* ein = sender;
                episode.name = ein.name.text;
                episode.introduction = ein.description.text;
                [episodes addObject:episode];
                [editorStatus clean];
                [chessBoard cleanAll];
                chessBoard.showStep = false;
                CCMenuItemFont* itemFont = (CCMenuItemFont*)showHand;
                [itemFont setString:@"不显示手数"];
                
                //[chessBoard cleanAllMarks];
                EZDEBUG(@"Current episode number:%i, name:%@, intro:%@", episodes.count, episode.name, episode.introduction);
                [ein.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            };
            episodeInputer.cancelBlock = ^(id sender){
                EZDEBUG(@"Cancel get called");
                EZEpisodeInputer* ein = sender;
                [ein.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            };
            //Store the data to database.
            [episode persist];
            
            
            [[CCDirector sharedDirector] presentViewController:episodeInputer animated:YES completion:nil];
            statusLabel.string = [NSString stringWithFormat:@"All episode count:%i", episodes.count];
            
        }];
        [editorStatus setBtnPreset:startPresetting audio:recording plantMove:startPlainMove save:save remove:nil preview:preView previewAll:nil];
        //editorStatus.statusText = statusText;
        editorStatus.statusLabel = statusLabel;
        [statusLabel setPosition:ccp(500, 34)];
        [self addChild:statusLabel];
        
        
        CCMenuItem* deleteAllEpisode = [CCMenuItemFont itemWithString:@"删除已上传数据" block:^(id sender){
            EZDEBUG(@"Upload all");
            [episodes removeAllObjects];
        }];
        
        CCMenu* menu = [CCMenu menuWithItems:recording,startPresetting,startPlainMove,save,regretMove,toggleMark,showHand,preView,delete,addPreset,saveAsBegin,selectChessColor,toggleBoardColor,saveEpisode,uploadAll,goToPlayer,deleteAllEpisode,nil];
        
        [menu alignItemsVerticallyWithPadding:5];
        
        menu.position = ccp(900, 400);
        [self addChild:menu z:-2];
    }
    return self;
}




@end
