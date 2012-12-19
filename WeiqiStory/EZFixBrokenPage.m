//
//  EZFixBrokenPage.m
//  WeiqiStory
//
//  Created by xietian on 12-12-17.
//
//

#import "EZFixBrokenPage.h"
#import "EZConstants.h"
#import "EZEpisodeVO.h"
#import "EZChessBoard.h"
#import "EZActionPlayer.h"
#import "EZProgressBar.h"
#import "EZExtender.h"
#import "EZSoundManager.h"
#import "EZBubble.h"
#import "EZBubble2.h"
#import "EZListTablePagePod.h"
#import "EZViewGesturer.h"
#import "EZCoreAccessor.h"
#import "EZEpisode.h"
#import "EZSpecificChessEditor.h"
#import "EZFileUtil.h"
//Only 2 status.
//Let's visualize what's was going on for a while.
//Should I disable the progress.
typedef enum {
    kPlayerPlaying,// the button during this stage.
    kPlayerPause//Mean not playing anything, this is play status, right?
} EZPlayStatus;

@interface EZFixBrokenPage()
{
    
}

@end

@implementation EZFixBrokenPage

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZFixBrokenPage *layer = [EZFixBrokenPage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}


- (CCScene*) createScene
{
    CCScene *scene = [CCScene node];
	
	[scene addChild: self];
    
	return scene;
    
}


- (void) initStudyBoard2:(EZEpisodeVO*)epv
{
    
    //studyBoardHolder = [CCSprite spriteWithFile:@"background-pattern.png" rect:CGRectMake(0, 0, 768, 878)];
    //studyBoardHolder.contentSize = CGSizeMake(768, 876);
    _studyBoardHolder = [[CCNode alloc] init];
    _studyBoardHolder.contentSize = CGSizeMake(768, 876);
    _studyBoardHolder.anchorPoint = ccp(0.5, 0);
    _studyBoardHolder.position = ccp(768/2, 0);
    
    
    _chessBoard2 = [[EZChessBoard alloc] initWithFile:@"chess-board.png" touchRect:CGRectMake(27, 27, 632, 632) rows:19 cols:19];
    _chessBoard2.position = ccp(384, 512);
    [_studyBoardHolder addChild:_chessBoard2 z:9];
    
    CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
    boardFrame.position = ccp(384, 512);
    //Why Frame should cover the edge of the board.
    //The purpose is to make the cursor be above the Frame.
    //Once it done, I will start to fix the memory leakage issue.
    //That is block refer to the self point.
    _chessBoard2.cursorHolder = boardFrame;
    [_studyBoardHolder addChild:boardFrame z:10];
    
    
    //[self addChild:studyBoardHolder];
    _player2 = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:_chessBoard2 inMainBundle:epv.inMainBundle];
    __weak EZFixBrokenPage* weakSelf = self;
    CCMenuItemImage* quitButton = [CCMenuItemImage itemWithNormalImage:@"study-over-button.png" selectedImage:@"study-over-button.png"
                                                                 block:^(id sender){
                                                                     [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
                                                                     /**
                                                                      id action = [CCScaleTo actionWithDuration:0.3 scaleX:1 scaleY:0.1];
                                                                      //id action = [CCMoveTo actionWithDuration:0.3 position:ccp(0, -studyBoardHolder.position.y)];
                                                                      CCAction* removeAction = [CCSequence actions:action,[CCCallBlock actionWithBlock:^(){
                                                                      [studyBoardHolder removeFromParentAndCleanup:NO];
                                                                      }], nil];
                                                                      **/
                                                                     id animation = [CCScaleTo actionWithDuration:0.3 scaleX:0.05 scaleY:1];
                                                                     
                                                                     id completed = [CCCallBlock actionWithBlock:^(){
                                                                         EZDEBUG(@"start show study board");
                                                                         //studyBoardHolder.scaleX = 0.05;
                                                                         //[self addChild:studyBoardHolder z:100];
                                                                         [weakSelf addChild:weakSelf.mainLayout z:10];
                                                                         id scaleDown = [CCScaleTo actionWithDuration:0.3f scaleX:1 scaleY:1];
                                                                         //id moveTo = [CCMoveTo actionWithDuration:0.3f position:ccp(0, 0)];
                                                                         [weakSelf.mainLayout runAction:scaleDown];
                                                                         [weakSelf.studyBoardHolder removeFromParentAndCleanup:NO];
                                                                     }];
                                                                     id sequence = [CCSequence actions:animation, completed, nil];
                                                                     weakSelf.chessBoard2.touchEnabled = false;
                                                                     [weakSelf.studyBoardHolder runAction:sequence];
                                                                 }
                                   ];
    
    CCMenu* quitButtonWrapper = [CCMenu menuWithItems:quitButton, nil];
    quitButtonWrapper.position = ccp(663, 75);
    [weakSelf.studyBoardHolder addChild:quitButtonWrapper];
    
    
    CCMenuItemImage* prevButton = [CCMenuItemImage itemWithNormalImage:@"prev-button.png" selectedImage:@"prev-button-pressed-pad.png" block:^(id sender) {
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
        [weakSelf.chessBoard2 regretSteps:1 animated:NO];
        EZDEBUG(@"Regret queue:%i", weakSelf.chessBoard2.regrets.count);
    }];
    
    CCMenu* prevMenu = [CCMenu menuWithItems:prevButton, nil];
    prevMenu.position = ccp(125, 75);
    [_studyBoardHolder addChild:prevMenu];
    
    //What's the meaning of nextStep?, It mean what?
    
    CCMenuItemImage* nextButton = [CCMenuItemImage itemWithNormalImage:@"next-button.png" selectedImage:@"next-button-pressed-pad.png" block:^(id sender){
        EZDEBUG(@"Regret queue:%i", weakSelf.chessBoard2.regrets.count);
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
        [weakSelf.chessBoard2 redoRegret:NO];
    }];
    
    CCMenu* nextMenu = [CCMenu menuWithItems:nextButton, nil];
    nextMenu.position = ccp(429, 75);
    [_studyBoardHolder addChild:nextMenu];
    
    _blackFinger = [CCSprite spriteWithFile:@"point-finger-black.png"];
    _whiteFinger = [CCSprite spriteWithFile:@"point-finger-white.png"];
    
    
    _blackFinger.position = ccp(384, 512);
    _whiteFinger.position = ccp(384, 512);
    
    _fingerAnim = [CCSequence actions:[CCSpawn actions:[CCRepeat actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.3 scale:0.8], [CCScaleTo actionWithDuration:0.3 scale:1.3], nil] times:3], [CCFadeOut actionWithDuration:2.7], nil],
                   [CCCallBlock actionWithBlock:^(){
        [weakSelf.currentFinger removeFromParentAndCleanup:NO];
        EZDEBUG(@"After remove, what's the visible:%@", weakSelf.currentFinger.visible?@"YES":@"NO");
        weakSelf.currentFinger.visible = false;
    }] ,nil];
    
}

- (void) onEnter
{
    [super onEnter];
    //[[CCDirector sharedDirector].view addSubview:_gesturerView];
}

- (void) onExit
{
    [super onExit];
    if(_chessBoard2.touchEnabled){
        //Make sure, it get removed from the event chains
        _chessBoard2.touchEnabled = false;
    }
    //[_gesturerView removeFromSuperview];
}


//Will be called by the commonPage when swipe get called
//I am make sure the epv is a valid one
- (void) swipeTo:(EZEpisodeVO*)epv currentPos:(NSInteger)currentPos isNext:(BOOL)isNext
{
    EZFixBrokenPage* nextPage = [[EZFixBrokenPage alloc] initWithEpisode:epv currentPos:currentPos];
    if(isNext){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[nextPage createScene]]];
    }else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene:[nextPage createScene]]];
    }
}


//We will only support potrait orientation
- (id) initWithEpisode:(EZEpisodeVO*)epv currentPos:(NSInteger)pos;
{
    self = [super initWithPos:pos];
    if(self){
        //timer = [[CCTimer alloc] initWithTarget:self selector:@selector(generatedBubble) interval:1 repeat:kCCRepeatForever delay:1];
        __weak EZFixBrokenPage* weakSelf = self;
        [self scheduleBlock:^(){
            [EZBubble generatedBubble:weakSelf z:9];
        } interval:1.0 repeat:kCCRepeatForever delay:0.5];
        
        EZDEBUG(@"Total Action count:%i", epv.actions.count);
        self.currentEpisodePos = pos;
        _bubble = [CCSprite spriteWithFile:@"bubble-pad.png"];
        _broken = [CCSprite spriteWithFile:@"bubble-broken.png"];
        _playButtonStatus = kPlayerPause;
        _episode = epv;
        //CGSize winsize = [CCDirector sharedDirector].winSize;
        //CCSprite* background = [[CC]]
        _volumePressed = false;
        CCSprite* background = [[CCSprite alloc] initWithFile:@"background-pattern.png"];
        background.anchorPoint = ccp(0, 0);
        background.position = ccp(0, 0);
        
        
        CCSprite* messageRegion = [[CCSprite alloc] initWithFile:@"message-region.png"];
        messageRegion.position = ccp(461, 950);
        
        _episodeName = [[CCLabelTTF alloc] initWithString:epv.name fontName:@"Adobe Kaiti Std" fontSize:24];
        _episodeName.anchorPoint = ccp(0, 0);
        _episodeName.position = ccp(62, messageRegion.contentSize.height - _episodeName.contentSize.height - 15);
        [messageRegion addChild:_episodeName];
        
        _episodeIntro = [[CCLabelTTF alloc] initWithString:epv.introduction fontName:@"Adobe Kaiti Std" fontSize:24];
        _episodeIntro.anchorPoint = ccp(0, 0);
        _episodeIntro.position = ccp(62, 0);
        
        /**
         infomationRegion = [[CCLabelTTF alloc] initWithString:@"无用之用是为大用" fontName:@"Adobe Kaiti Std" fontSize:32];
         infomationRegion.anchorPoint = ccp(0, 0.5);
         infomationRegion.position = ccp(messageRegion.contentSize.width/3, messageRegion.contentSize.height/2);
         [messageRegion addChild:infomationRegion];
         **/
        [messageRegion addChild:_episodeIntro];
        
        
        
        [self addChild:background];
        [self addChild:messageRegion];
        
        
        
        //mainLayout = [CCSprite spriteWithFile:@"background-pattern.png" rect:CGRectMake(0, 0, 768, 878)];
        _mainLayout = [[CCNode alloc] init];
        _mainLayout.contentSize = CGSizeMake(768, 878);
        //studyBoardHolder.contentSize = CGSizeMake(768, 876);
        _mainLayout.anchorPoint = ccp(0.5, 0);
        _mainLayout.position = ccp(768/2, 0);
        
        [self addChild:_mainLayout z:10];
        
        CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
        boardFrame.position = ccp(384, 512);
        //Why Frame should cover the edge of the board.
        [_mainLayout addChild:boardFrame z:10];
        
        
        _chessBoard = [[EZChessBoard alloc]initWithFile:@"chess-board.png" touchRect:CGRectMake(27, 27, 632, 632) rows:19 cols:19];
        _chessBoard.position = ccp(384, 512);
        _chessBoard.touchEnabled = false;
        
        
        //[self addChild:chessBoard2];
        self.player = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:_chessBoard inMainBundle:epv.inMainBundle];
        
        
        //[player2 forwardFrom:0 to:epv.actions.count];
        
        _playImg = [CCSprite spriteWithFile:@"play-button.png"];
        _pauseImg = [CCSprite spriteWithFile:@"pause-button.png"];
        
        CCMenuItemImage* backButton = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button-pressed.png" block:^(id sender){
            [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            [weakSelf.player stop];
            [[CCDirector sharedDirector] replaceScene:[EZListTablePagePod node]];
            //[[CCDirector sharedDirector] popScene];
        }];
        
        CCMenu* backMenu = [CCMenu menuWithItems:backButton, nil];
        //menu.anchorPoint = ccp(0, 0);
        backMenu.position =  ccp(96, 950);
        [self addChild:backMenu];
        
        CCMenuItemImage* playButton = [CCMenuItemImage itemWithNormalImage:@"play-button.png" selectedImage:@"play-button-pressed.png"
                                                                     block:^(id sender) {
                                                                         [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
                                                                         CCMenuItemImage* imageItem = sender;
                                                                         EZDEBUG(@"play clicked, play status:%i", weakSelf.playButtonStatus);
                                                                         if(!weakSelf.player.isPlaying){
                                                                             //It is end and user click play button again.
                                                                             if(weakSelf.player.isEnd){
                                                                                 [weakSelf.player rewind];
                                                                             }
                                                                             weakSelf.playButtonStatus = kPlayerPlaying;
                                                                             //Play mean play from current action.
                                                                             [imageItem setNormalSpriteFrame:weakSelf.pauseImg.displayFrame];
                                                                             [weakSelf.player play:^(){
                                                                                 EZDEBUG(@"play completed, I will set button to play again.");
                                                                                 //CCMenuItemImage* imageItem = sender;
                                                                                 //TODO will add clicked frame too.
                                                                                 weakSelf.playButtonStatus = kPlayerPause;
                                                                                 //[player rewind];
                                                                                 [imageItem setNormalSpriteFrame:weakSelf.playImg.displayFrame];
                                                                             }];
                                                                         }else{//I am thinking about one case, not yet stopped, but play button get hit again.Let's experiment them. Only real case can help me solve it
                                                                             EZDEBUG(@"Paused");
                                                                             [weakSelf.player pause];
                                                                             weakSelf.playButtonStatus = kPlayerPause;
                                                                             [imageItem setNormalSpriteFrame:weakSelf.playImg.displayFrame];
                                                                         }
                                                                         
                                                                     }
                                       ];
        CCMenu* playMenu = [CCMenu menuWithItems:playButton, nil];
        playMenu.position = ccp(125, 75);
        
        CCSprite* progressBar = [[CCSprite alloc] initWithFile:@"progress-bar.png"];
        //progressBar.position = ccp(294, 59);
        
        CCSprite* progressNob = [[CCSprite alloc] initWithFile:@"progress-nob.png"];
        
        __weak CCMenuItemImage* weakPlay = playButton;
        //progressNob.position = ccp(294, 59);
        EZProgressBar* myBar = [[EZProgressBar alloc] initWithNob:progressNob bar:progressBar maxValue:epv.actions.count changedBlock:^(NSInteger prv, NSInteger cur) {
            EZDEBUG(@"Player2 Nob position changed from:%i to %i", prv, cur);
            //pause the player, no harm will be done
            [weakSelf.player pause];
            [weakPlay setNormalSpriteFrame:weakSelf.playImg.displayFrame];
            [weakSelf.player forwardFrom:prv to:cur];
            
        }];
        
        [weakSelf.player.stepCompletionBlocks addObject:^(id sender){
            //Update the progressBar accordingly.
            EZDEBUG(@"One step Completed");
            EZActionPlayer* curPlayer = sender;
            myBar.currentValue = curPlayer.currentAction;
            _episodeName.string = [NSString  stringWithFormat:@"Step:%i", curPlayer.currentAction];
            if(curPlayer.currentAction < curPlayer.actions.count){
                id act = [curPlayer.actions objectAtIndex:curPlayer.currentAction];
                _episodeIntro.string = [NSString stringWithFormat:@"name:%@, action class:%@",epv.introduction, [act class]];
            }
        }];
        
        
        
        myBar.position = ccp(200, 60);
        [_mainLayout addChild:myBar];
        
        if(epv.actions.count > 0){
            [self.player playOneStep:0 completeBlock:nil];
        }
        
        CCMenuItemImage* studyButton = [CCMenuItemImage itemWithNormalImage:@"study-button.png" selectedImage:@"study-button-pad.png"
                                                                      block:^(id sender){
                                                                          [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
                                                                          [weakSelf.player pause];
                                                                          [playButton setNormalSpriteFrame:weakSelf.playImg.displayFrame];
                                                                          EZSpecificChessEditor* spc = [[EZSpecificChessEditor alloc] initWithEpisode:epv playedPos:weakSelf.player.currentAction];
                                                                          [[CCDirector sharedDirector] replaceScene:[spc createScene]];
                                                                          
                                                                      }
                                        ];
        CCMenu* studyMenu = [CCMenu menuWithItems:studyButton, nil];
        studyMenu.position = ccp(663, 75);
        
        CCMenuItemFont* store = [CCMenuItemFont itemWithString:@"保存" block:
                                                                     ^(id sender){
                                                                         [epv persist];
                                                                         EZDEBUG(@"Store success, epv action number:%i", epv.actions.count);
                                                                      }
                                        ];
        store.color = ccc3(0,0,0);

        
        CCMenuItemFont* exportAll = [CCMenuItemFont itemWithString:@"输出" block:^(id sender){
            NSArray* arr = [[EZCoreAccessor getClientAccessor] fetchAll:[EZEpisode class] sortField:nil];
            
            //EZEpisode* specified = [[EZCoreAccessor getClientAccessor] fetchByID:epv.PO.objectID];
            //EZDEBUG(@"Fetched back by id action length:%i", specified.actions.count);
            
            
            
            EZDEBUG(@"Total length is:%i", arr.count);
            NSMutableArray* stored = [[NSMutableArray alloc] initWithCapacity:arr.count];
            for(EZEpisode* ep in arr){
                //EZDEBUG(@"Current Episode name:%i:%@, audioCount:%i", count++, ep.name, ep.audioFiles.count);
                //EZDEBUG(@"ep.name:%@",ep.name);
                EZEpisodeVO* epvo = [[EZEpisodeVO alloc] initWithPO:ep];
                //if([ep.objectID isEqual:epv.PO.objectID]){
                //    EZDEBUG(@"Readback from DB, action count is:%i", ep.actions.count);
                //}
                [stored addObject:epvo];
            }
            
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:stored];
            NSString* completeFileName = @"modified.ar";
            NSURL* fileURL = [EZFileUtil fileToURL:completeFileName dirType:NSDocumentDirectory];
            [data writeToURL:fileURL atomically:YES];
            EZDEBUG("Write to file:%@", completeFileName);
            }];
        exportAll.color = ccc3(0,0,0);
        CCMenu* storeAndExport = [CCMenu menuWithItems:store,exportAll,nil];
        storeAndExport.position = ccp(540, 75);
        
        [storeAndExport alignItemsVerticallyWithPadding:10];
        [_mainLayout addChild:storeAndExport];
        
        
        [_mainLayout addChild:_chessBoard z:9];
        
        [_mainLayout addChild:playMenu];
        
        //[self addChild:progressBar];
        //[self addChild:progressNob];
        [_mainLayout addChild:studyMenu];
        
        //EZViewGesturer* viewGesturer = [[EZViewGesturer alloc] init];
        
        
        
    }
    
    return self;
}


- (void) dealloc
{
    EZDEBUG(@"EZFixBrokenPage Released");
}

@end
