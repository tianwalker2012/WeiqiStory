//
//  EZPlayPage-pod4.m
//  WeiqiStory
//
//  Created by xietian on 12-11-20.
//
//

#import "EZPlayPagePod.h"
#import "EZConstants.h"
#import "EZEpisodeVO.h"
#import "EZChessBoard.h"
#import "EZActionPlayer.h"
#import "EZProgressBar.h"
#import "EZExtender.h"
#import "EZSoundManager.h"
#import "EZBubble.h"
#import "EZBubble2.h"
#import "EZResizeChessBoard.h"
#import "EZListTablePagePod.h"


//Only 2 status.
//Let's visualize what's was going on for a while.
//Should I disable the progress.
typedef enum {
    kPlayerPlaying,// the button during this stage.
    kPlayerPause//Mean not playing anything, this is play status, right?
} EZPlayStatus;

@interface EZPlayPagePod()
{

}

@end

@implementation EZPlayPagePod

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZPlayPagePod *layer = [EZPlayPagePod node];
	
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
    _studyBoardHolder.contentSize = CGSizeMake(320, 397);
    _studyBoardHolder.anchorPoint = ccp(0.5, 0);
    _studyBoardHolder.position = ccp(320/2, 0);
    
    
    //chessBoard2 = [[EZChessBoard alloc] initWithFile:@"chess-board.png" touchRect:CGRectMake(13, 13, 271, 271) rows:19 cols:19];
    _resizeBoard = [[EZResizeChessBoard alloc] initWithOrgBoard:@"chess-board.png" orgRect:CGRectMake(13, 13, 271, 271) largeBoard:@"chess-board-large.png" largeRect:CGRectMake(27, 27, 632, 632)];
    
    _chessBoard2 = _resizeBoard.orgBoard;
    
    _resizeBoard.contentSize = _resizeBoard.orgBoard.contentSize;
    _resizeBoard.anchorPoint = ccp(0.5, 0.5);
    _resizeBoard.position = ccp(320/2, 244);
    //chessBoard2.anchorPoint = ccp(0.5, 0.5);
    [_studyBoardHolder addChild:_resizeBoard z:9];
    
    CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
    boardFrame.position = ccp(320/2, 244);
    //boardFrame.anchorPoint = ccp(0.5, 0.5);
    
    //Why Frame should cover the edge of the board.
    [_studyBoardHolder addChild:boardFrame z:10];
    
    
    //[self addChild:studyBoardHolder];
    _player2 = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:_resizeBoard.orgBoard inMainBundle:epv.inMainBundle];
    
    //EZActionPlayer* playerTmp = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:resizeBoard.enlargedBoard inMainBundle:epv.inMainBundle];
    __weak EZPlayPagePod* weakSelf = self;
    
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
                                                                     if(weakSelf.currentFinger.visible){
                                                                         weakSelf.currentFinger.visible = false;
                                                                         [weakSelf.currentFinger stopAllActions];
                                                                         [weakSelf.currentFinger removeFromParentAndCleanup:NO];
                                                                     }
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
                                                                     weakSelf.resizeBoard.touchEnabled = false;
                                                                     [weakSelf.studyBoardHolder runAction:sequence];
                                                                 }
                                   ];
    
    CCMenu* quitButtonWrapper = [CCMenu menuWithItems:quitButton, nil];
    quitButtonWrapper.position = ccp(262, 47);
    //quitButtonWrapper.anchorPoint = ccp(0.5, 0.5);
    [_studyBoardHolder addChild:quitButtonWrapper];
    
    
    CCMenuItemImage* prevButton = [CCMenuItemImage itemWithNormalImage:@"prev-button.png" selectedImage:@"prev-button-pressed.png" block:^(id sender) {
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
        [_chessBoard2 regretSteps:1 animated:NO];
        EZDEBUG(@"Regret queue:%i", _chessBoard2.regrets.count);
    }];
    
    CCMenu* prevMenu = [CCMenu menuWithItems:prevButton, nil];
    //prevMenu.anchorPoint = ccp(0.5, 0.5);
    prevMenu.position = ccp(58, 47);
    [_studyBoardHolder addChild:prevMenu];
    
    //What's the meaning of nextStep?, It mean what?
    
    CCMenuItemImage* nextButton = [CCMenuItemImage itemWithNormalImage:@"next-button.png" selectedImage:@"next-button-pressed.png" block:^(id sender){
        EZDEBUG(@"Regret queue:%i", weakSelf.chessBoard2.regrets.count);
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
        [weakSelf.chessBoard2 redoRegret:NO];
    }];
    
    CCMenu* nextMenu = [CCMenu menuWithItems:nextButton, nil];
    nextMenu.position = ccp(165, 47);
    [_studyBoardHolder addChild:nextMenu];
    
    _blackFinger = [CCSprite spriteWithFile:@"point-finger-black.png"];
    _whiteFinger = [CCSprite spriteWithFile:@"point-finger-white.png"];
    
    
    _blackFinger.position = ccp(320/2, 244);
    _whiteFinger.position = ccp(320/2, 244);
    
    _resizeBoard.touchedBlock = ^(){
        if(weakSelf.currentFinger.visible){
            [weakSelf.currentFinger stopAllActions];
            [weakSelf.currentFinger removeFromParentAndCleanup:NO];
            EZDEBUG(@"After remove, what's the visible:%@", weakSelf.currentFinger.visible?@"YES":@"NO");
            weakSelf.currentFinger.visible = false;
        }
    };
    
    _fingerAnim = [CCSequence actions:[CCSpawn actions:[CCRepeat actionWithAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.3 scale:0.8], [CCScaleTo actionWithDuration:0.3 scale:1], nil] times:3], [CCFadeOut actionWithDuration:2.7], nil],
                  [CCCallBlock actionWithBlock:^(){
        [weakSelf.currentFinger removeFromParentAndCleanup:NO];
        EZDEBUG(@"After remove, what's the visible:%@", weakSelf.currentFinger.visible?@"YES":@"NO");
        weakSelf.currentFinger.visible = false;
    }] ,nil];
}

- (void) onExit
{
    //if(chessBoard2.touchEnabled){
        //Make sure, it get removed from the event chains
        //chessBoard2.touchEnabled = false;
    //}
    if(_resizeBoard.touchEnabled){
        _resizeBoard.touchEnabled = false;
    }
}




//We will only support potrait orientation
- (id) initWithEpisode:(EZEpisodeVO*)epv
{
    self = [super init];
    if(self){
        //timer = [[CCTimer alloc] initWithTarget:self selector:@selector(generatedBubble) interval:1 repeat:kCCRepeatForever delay:1];
        [self scheduleBlock:^(){
            [EZBubble generatedBubble:self z:9];
        } interval:1.0 repeat:kCCRepeatForever delay:0.5];
        
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
        messageRegion.position = ccp(192, 440);
        
        _episodeName = [[CCLabelTTF alloc] initWithString:epv.name fontName:@"Adobe Kaiti Std" fontSize:16];
        _episodeName.anchorPoint = ccp(0, 0);
        _episodeName.position = ccp(20, messageRegion.contentSize.height - _episodeName.contentSize.height - 8);
        [messageRegion addChild:_episodeName];
        
        _episodeIntro = [[CCLabelTTF alloc] initWithString:epv.introduction fontName:@"Adobe Kaiti Std" fontSize:16];
        _episodeIntro.anchorPoint = ccp(0, 0);
        _episodeIntro.position = ccp(20, -5);
        
        /**
         infomationRegion = [[CCLabelTTF alloc] initWithString:@"无用之用是为大用" fontName:@"Adobe Kaiti Std" fontSize:32];
         infomationRegion.anchorPoint = ccp(0, 0.5);
         infomationRegion.position = ccp(messageRegion.contentSize.width/3, messageRegion.contentSize.height/2);
         [messageRegion addChild:infomationRegion];
         **/
        [messageRegion addChild:_episodeIntro];
        
        
        
        [self addChild:background];
        
        NSInteger deviceType = [[CCFileUtils sharedFileUtils] runningDevice];
        if(deviceType == kCCiPhone5){
            CCSprite* titleBar = [CCSprite spriteWithFile:@"title-bar.png"];
            titleBar.position = ccp(320/2, 515);
            [self addChild:titleBar];
        }
        
        
        [self addChild:messageRegion];
        
        
        
        //mainLayout = [CCSprite spriteWithFile:@"background-pattern.png" rect:CGRectMake(0, 0, 768, 878)];
        _mainLayout = [[CCNode alloc] init];
        _mainLayout.contentSize = CGSizeMake(320, 397);
        //studyBoardHolder.contentSize = CGSizeMake(768, 876);
        _mainLayout.anchorPoint = ccp(0.5, 0);
        _mainLayout.position = ccp(320/2, 0);
        
        [self addChild:_mainLayout z:10];
        
        CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
        boardFrame.position = ccp(320/2, 244);
        //Why Frame should cover the edge of the board.
        [_mainLayout addChild:boardFrame z:10];
        
        
        _chessBoard = [[EZChessBoard alloc]initWithFile:@"chess-board.png" touchRect:CGRectMake(13, 13, 271, 271) rows:19 cols:19];
        _chessBoard.position = ccp(320/2, 244);
        _chessBoard.touchEnabled = false;
        
        
        //[self addChild:chessBoard2];
        _player = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:_chessBoard inMainBundle:epv.inMainBundle];
        
        
        //[player2 forwardFrom:0 to:epv.actions.count];
        
        _playImg = [CCSprite spriteWithFile:@"play-button.png"];
        _pauseImg = [CCSprite spriteWithFile:@"pause-button.png"];
        
        __weak EZPlayPagePod* weakSelf = self;
        
        CCMenuItemImage* backButton = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button-pressed.png" block:^(id sender){
            [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            [weakSelf.player stop];
            [[CCDirector sharedDirector] replaceScene:[EZListTablePagePod node]];
        }];
        
        CCMenu* backMenu = [CCMenu menuWithItems:backButton, nil];
        //menu.anchorPoint = ccp(0, 0);
        backMenu.position =  ccp(42, 440);
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
        playMenu.position = ccp(44, 47);
        
        CCSprite* progressBar = [[CCSprite alloc] initWithFile:@"progress-bar.png"];
        //progressBar.position = ccp(294, 59);
        
        CCSprite* progressNob = [[CCSprite alloc] initWithFile:@"progress-nob.png"];
        //progressNob.position = ccp(294, 59);
        EZProgressBar* myBar = [[EZProgressBar alloc] initWithNob:progressNob bar:progressBar maxValue:epv.actions.count changedBlock:^(NSInteger prv, NSInteger cur) {
            EZDEBUG(@"Player2 Nob position changed from:%i to %i", prv, cur);
            //pause the player, no harm will be done
            [weakSelf.player pause];
            [playButton setNormalSpriteFrame:weakSelf.playImg.displayFrame];
            [weakSelf.player forwardFrom:prv to:cur];
        }];
        
        [_player.stepCompletionBlocks addObject:^(id sender){
            //Update the progressBar accordingly.
            EZDEBUG(@"One step Completed");
            EZActionPlayer* curPlayer = sender;
            myBar.currentValue = curPlayer.currentAction;
        }];
        
        myBar.position = ccp(78, 37);
        [_mainLayout addChild:myBar];
        
        if(epv.actions.count > 0){
            [_player playOneStep:0 completeBlock:nil];
        }
        
        CCMenuItemImage* studyButton = [CCMenuItemImage itemWithNormalImage:@"study-button.png" selectedImage:@"study-button.png"
                                                                      block:^(id sender){
                                                                          [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
                                                                          [weakSelf.player pause];
                                                                          [playButton setNormalSpriteFrame:weakSelf.playImg.displayFrame];
                                                                          
                                                                          //More straightforward.
                                                                          if(!weakSelf.studyBoardHolder){
                                                                              [self initStudyBoard2:epv];
                                                                          }else{
                                                                              weakSelf.resizeBoard.touchEnabled = YES;
                                                                          }
                                                                          //[self addChild:chessBoard2];
                                                                          //[studyBoardHolder setScale:0.2];
                                                                          //studyBoardHolder.position = ccp(studyBoardHolder.position.x, -studyBoardHolder.position.y);
                                                                          id animation = [CCScaleTo actionWithDuration:0.3 scaleX:0.05 scaleY:1];
                                                                          
                                                                          id completed = [CCCallBlock actionWithBlock:^(){
                                                                              EZDEBUG(@"start show study board");
                                                                              [weakSelf.mainLayout removeFromParentAndCleanup:NO];
                                                                              weakSelf.studyBoardHolder.scaleX = 0.05;
                                                                              //why make it 100, so typo.
                                                                              [weakSelf addChild:weakSelf.studyBoardHolder z:10];
                                                                              id scaleDown = [CCScaleTo actionWithDuration:0.3f scaleX:1 scaleY:1];
                                                                              //id moveTo = [CCMoveTo actionWithDuration:0.3f position:ccp(0, 0)];
                                                                              [weakSelf.studyBoardHolder runAction:scaleDown];
                                                                          }];
                                                                          id sequence = [CCSequence actions:animation, completed, nil];
                                                                          [weakSelf.mainLayout runAction:sequence];
                                                                          
                                                                          [weakSelf.chessBoard2 cleanAll];
                                                                          [weakSelf.resizeBoard.enlargedBoard cleanAll];
                                                                          [weakSelf.player2 forwardFrom:0 to:weakSelf.player.currentAction];
                                                                          
                                                                          //mean
                                                                          //This is still not very precise,
                                                                          //Even no check at all will give a 50% correct rate.
                                                                          //Which boost my confidence.
                                                                          if(weakSelf.player.currentAction == 1){
                                                                              //Only handle 2 simplst cases
                                                                              if([epv.introduction isEqualToString:@"黑先"] != weakSelf.chessBoard2.isCurrentBlack){
                                                                                  [weakSelf.chessBoard2 toggleColor];
                                                                              }
                                                                          }else{
                                                                              [weakSelf.chessBoard2 syncChessColorWithLastMove];
                                                                          }
                                                                          
                                                                          if(weakSelf.chessBoard2.isCurrentBlack){
                                                                              weakSelf.currentFinger = weakSelf.blackFinger;
                                                                          }else{
                                                                              weakSelf.currentFinger = weakSelf.whiteFinger;
                                                                          }
                                                                          
                                                                          _currentFinger.visible = true;
                                                                          [weakSelf.studyBoardHolder addChild:weakSelf.currentFinger z:FingerZOrder];
                                                                          
                                                                          [weakSelf.currentFinger runAction:weakSelf.fingerAnim];
                                                                          //Make sure the inner board and outboard color is consistent.
                                                                          //It is all because initially, I didn't get all the
                                                                          //BoardFront interface well define.
                                                                          //Otherwise it could be much simpler to add functionality like this.
                                                                          EZDEBUG(@"Raise study panel successfully");
                                                                      }
                                        ];
        CCMenu* studyMenu = [CCMenu menuWithItems:studyButton, nil];
        studyMenu.position = ccp(262, 47);
        
        [_mainLayout addChild:_chessBoard z:9];
        
        [_mainLayout addChild:playMenu];
        
        //[self addChild:progressBar];
        //[self addChild:progressNob];
        [_mainLayout addChild:studyMenu];
        
        
    }
    
    return self;
}


@end