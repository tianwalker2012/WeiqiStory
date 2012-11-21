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


//Only 2 status.
//Let's visualize what's was going on for a while.
//Should I disable the progress.
typedef enum {
    kPlayerPlaying,// the button during this stage.
    kPlayerPause//Mean not playing anything, this is play status, right?
} EZPlayStatus;

@interface EZPlayPagePod()
{
    EZChessBoard* chessBoard;
    
    EZChessBoard* chessBoard2;
    
    EZActionPlayer* player;
    
    EZActionPlayer* player2;
    
    CCSprite* pauseImg;
    CCSprite* playImg;
    
    //Now just put it at the rough place, later, I will adjust the layout accordingly
    CCLabelTTF* episodeName;
    CCLabelTTF* episodeIntro;
    CCLabelTTF* infomationRegion;
    
    
    //The board which will be used for the study purpose
    CCNode* studyBoardHolder;
    EZChessBoard* studyBoard;
    //Used to progress the board to current status
    EZActionPlayer* studyPlayer;
    
    CCNode* mainLayout;
    
    CCSprite* bubble;
    CCSprite* broken;
    
    //CCTimer* timer;
    
    BOOL volumePressed;
    
    NSInteger playButtonStatus;
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
    studyBoardHolder = [[CCNode alloc] init];
    studyBoardHolder.contentSize = CGSizeMake(320, 397);
    studyBoardHolder.anchorPoint = ccp(0.5, 0);
    studyBoardHolder.position = ccp(320/2, 0);
    
    
    chessBoard2 = [[EZChessBoard alloc] initWithFile:@"chess-board.png" touchRect:CGRectMake(13, 13, 271, 271) rows:19 cols:19];
    chessBoard2.position = ccp(320/2, 244);
    //chessBoard2.anchorPoint = ccp(0.5, 0.5);
    [studyBoardHolder addChild:chessBoard2 z:9];
    
    CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
    boardFrame.position = ccp(320/2, 244);
    //boardFrame.anchorPoint = ccp(0.5, 0.5);
    
    //Why Frame should cover the edge of the board.
    [studyBoardHolder addChild:boardFrame z:10];
    
    
    //[self addChild:studyBoardHolder];
    player2 = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:chessBoard2 inMainBundle:epv.inMainBundle];
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
                                                                         [self addChild:mainLayout z:10];
                                                                         id scaleDown = [CCScaleTo actionWithDuration:0.3f scaleX:1 scaleY:1];
                                                                         //id moveTo = [CCMoveTo actionWithDuration:0.3f position:ccp(0, 0)];
                                                                         [mainLayout runAction:scaleDown];
                                                                         [studyBoardHolder removeFromParentAndCleanup:NO];
                                                                     }];
                                                                     id sequence = [CCSequence actions:animation, completed, nil];
                                                                     chessBoard2.touchEnabled = false;
                                                                     [studyBoardHolder runAction:sequence];
                                                                 }
                                   ];
    
    CCMenu* quitButtonWrapper = [CCMenu menuWithItems:quitButton, nil];
    quitButtonWrapper.position = ccp(262, 47);
    //quitButtonWrapper.anchorPoint = ccp(0.5, 0.5);
    [studyBoardHolder addChild:quitButtonWrapper];
    
    
    CCMenuItemImage* prevButton = [CCMenuItemImage itemWithNormalImage:@"prev-button.png" selectedImage:@"prev-button-pressed.png" block:^(id sender) {
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
        [chessBoard2 regretSteps:1 animated:NO];
        EZDEBUG(@"Regret queue:%i", chessBoard2.regrets.count);
    }];
    
    CCMenu* prevMenu = [CCMenu menuWithItems:prevButton, nil];
    //prevMenu.anchorPoint = ccp(0.5, 0.5);
    prevMenu.position = ccp(58, 47);
    [studyBoardHolder addChild:prevMenu];
    
    //What's the meaning of nextStep?, It mean what?
    
    CCMenuItemImage* nextButton = [CCMenuItemImage itemWithNormalImage:@"next-button.png" selectedImage:@"next-button-pressed.png" block:^(id sender){
        EZDEBUG(@"Regret queue:%i", chessBoard2.regrets.count);
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
        [chessBoard2 redoRegret:NO];
    }];
    
    CCMenu* nextMenu = [CCMenu menuWithItems:nextButton, nil];
    nextMenu.position = ccp(165, 47);
    [studyBoardHolder addChild:nextMenu];
    
}

- (void) onExit
{
    if(chessBoard2.touchEnabled){
        //Make sure, it get removed from the event chains
        chessBoard2.touchEnabled = false;
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
        
        bubble = [CCSprite spriteWithFile:@"bubble-pad.png"];
        broken = [CCSprite spriteWithFile:@"bubble-broken.png"];
        playButtonStatus = kPlayerPause;
        _episode = epv;
        //CGSize winsize = [CCDirector sharedDirector].winSize;
        //CCSprite* background = [[CC]]
        volumePressed = false;
        CCSprite* background = [[CCSprite alloc] initWithFile:@"background-pattern.png"];
        background.anchorPoint = ccp(0, 0);
        background.position = ccp(0, 0);
        
        
        CCSprite* messageRegion = [[CCSprite alloc] initWithFile:@"message-region.png"];
        messageRegion.position = ccp(192, 440);
        
        episodeName = [[CCLabelTTF alloc] initWithString:epv.name fontName:@"Adobe Kaiti Std" fontSize:16];
        episodeName.anchorPoint = ccp(0, 0);
        episodeName.position = ccp(20, messageRegion.contentSize.height - episodeName.contentSize.height - 8);
        [messageRegion addChild:episodeName];
        
        episodeIntro = [[CCLabelTTF alloc] initWithString:epv.introduction fontName:@"Adobe Kaiti Std" fontSize:16];
        episodeIntro.anchorPoint = ccp(0, 0);
        episodeIntro.position = ccp(20, -5);
        
        /**
         infomationRegion = [[CCLabelTTF alloc] initWithString:@"无用之用是为大用" fontName:@"Adobe Kaiti Std" fontSize:32];
         infomationRegion.anchorPoint = ccp(0, 0.5);
         infomationRegion.position = ccp(messageRegion.contentSize.width/3, messageRegion.contentSize.height/2);
         [messageRegion addChild:infomationRegion];
         **/
        [messageRegion addChild:episodeIntro];
        
        
        
        [self addChild:background];
        [self addChild:messageRegion];
        
        
        
        //mainLayout = [CCSprite spriteWithFile:@"background-pattern.png" rect:CGRectMake(0, 0, 768, 878)];
        mainLayout = [[CCNode alloc] init];
        mainLayout.contentSize = CGSizeMake(320, 397);
        //studyBoardHolder.contentSize = CGSizeMake(768, 876);
        mainLayout.anchorPoint = ccp(0.5, 0);
        mainLayout.position = ccp(320/2, 0);
        
        [self addChild:mainLayout z:10];
        
        CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
        boardFrame.position = ccp(320/2, 244);
        //Why Frame should cover the edge of the board.
        [mainLayout addChild:boardFrame z:10];
        
        
        chessBoard = [[EZChessBoard alloc]initWithFile:@"chess-board.png" touchRect:CGRectMake(13, 13, 271, 271) rows:19 cols:19];
        chessBoard.position = ccp(320/2, 244);
        chessBoard.touchEnabled = false;
        
        
        //[self addChild:chessBoard2];
        player = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:chessBoard inMainBundle:epv.inMainBundle];
        
        
        //[player2 forwardFrom:0 to:epv.actions.count];
        
        playImg = [CCSprite spriteWithFile:@"play-button.png"];
        pauseImg = [CCSprite spriteWithFile:@"pause-button.png"];
        
        
        
        CCMenuItemImage* backButton = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button-pressed.png" block:^(id sender){
            [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            [player stop];
            [[CCDirector sharedDirector] popScene];
        }];
        
        CCMenu* backMenu = [CCMenu menuWithItems:backButton, nil];
        //menu.anchorPoint = ccp(0, 0);
        backMenu.position =  ccp(42, 445);
        [self addChild:backMenu];
        
        CCMenuItemImage* playButton = [CCMenuItemImage itemWithNormalImage:@"play-button.png" selectedImage:@"play-button-pressed.png"
                                                                     block:^(id sender) {
                                                                         [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
                                                                         CCMenuItemImage* imageItem = sender;
                                                                         EZDEBUG(@"play clicked, play status:%i", playButtonStatus);
                                                                         if(!player.isPlaying){
                                                                             //It is end and user click play button again.
                                                                             if(player.isEnd){
                                                                                 [player rewind];
                                                                             }
                                                                             playButtonStatus = kPlayerPlaying;
                                                                             //Play mean play from current action.
                                                                             [imageItem setNormalSpriteFrame:pauseImg.displayFrame];
                                                                             [player play:^(){
                                                                                 EZDEBUG(@"play completed, I will set button to play again.");
                                                                                 //CCMenuItemImage* imageItem = sender;
                                                                                 //TODO will add clicked frame too.
                                                                                 playButtonStatus = kPlayerPause;
                                                                                 //[player rewind];
                                                                                 [imageItem setNormalSpriteFrame:playImg.displayFrame];
                                                                             }];
                                                                         }else{//I am thinking about one case, not yet stopped, but play button get hit again.Let's experiment them. Only real case can help me solve it
                                                                             EZDEBUG(@"Paused");
                                                                             [player pause];
                                                                             playButtonStatus = kPlayerPause;
                                                                             [imageItem setNormalSpriteFrame:playImg.displayFrame];
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
            [player pause];
            [playButton setNormalSpriteFrame:playImg.displayFrame];
            [player forwardFrom:prv to:cur];
            
        }];
        
        [player.stepCompletionBlocks addObject:^(id sender){
            //Update the progressBar accordingly.
            EZDEBUG(@"One step Completed");
            EZActionPlayer* curPlayer = sender;
            myBar.currentValue = curPlayer.currentAction;
        }];
        
        myBar.position = ccp(78, 42);
        [mainLayout addChild:myBar];
        
        if(epv.actions.count > 0){
            [player playOneStep:0 completeBlock:nil];
        }
        
        CCMenuItemImage* studyButton = [CCMenuItemImage itemWithNormalImage:@"study-button.png" selectedImage:@"study-button.png"
                                                                      block:^(id sender){
                                                                          [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
                                                                          [player pause];
                                                                          [playButton setNormalSpriteFrame:playImg.displayFrame];
                                                                          
                                                                          //More straightforward.
                                                                          if(!studyBoardHolder){
                                                                              [self initStudyBoard2:epv];
                                                                          }else{
                                                                              chessBoard2.touchEnabled = YES;
                                                                          }
                                                                          //[self addChild:chessBoard2];
                                                                          //[studyBoardHolder setScale:0.2];
                                                                          //studyBoardHolder.position = ccp(studyBoardHolder.position.x, -studyBoardHolder.position.y);
                                                                          id animation = [CCScaleTo actionWithDuration:0.3 scaleX:0.05 scaleY:1];
                                                                          
                                                                          id completed = [CCCallBlock actionWithBlock:^(){
                                                                              EZDEBUG(@"start show study board");
                                                                              [mainLayout removeFromParentAndCleanup:NO];
                                                                              studyBoardHolder.scaleX = 0.05;
                                                                              //why make it 100, so typo.
                                                                              [self addChild:studyBoardHolder z:10];
                                                                              id scaleDown = [CCScaleTo actionWithDuration:0.3f scaleX:1 scaleY:1];
                                                                              //id moveTo = [CCMoveTo actionWithDuration:0.3f position:ccp(0, 0)];
                                                                              [studyBoardHolder runAction:scaleDown];
                                                                          }];
                                                                          id sequence = [CCSequence actions:animation, completed, nil];
                                                                          [mainLayout runAction:sequence];
                                                                          
                                                                          [chessBoard2 cleanAll];
                                                                          [player2 forwardFrom:0 to:player.currentAction];
                                                                          
                                                                          //mean
                                                                          //This is still not very precise,
                                                                          //Even no check at all will give a 50% correct rate.
                                                                          //Which boost my confidence.
                                                                          if(player.currentAction == 1){
                                                                              //Only handle 2 simplst cases
                                                                              if([epv.introduction isEqualToString:@"黑先"] != chessBoard2.isCurrentBlack){
                                                                                  [chessBoard2 toggleColor];
                                                                              }
                                                                          }else{
                                                                              [chessBoard2 syncChessColorWithLastMove];
                                                                          }
                                                                          
                                                                          EZDEBUG(@"successfully completed raising board");
                                                                      }
                                        ];
        CCMenu* studyMenu = [CCMenu menuWithItems:studyButton, nil];
        studyMenu.position = ccp(262, 47);
        
        [mainLayout addChild:chessBoard z:9];
        
        [mainLayout addChild:playMenu];
        
        //[self addChild:progressBar];
        //[self addChild:progressNob];
        [mainLayout addChild:studyMenu];
        
        
    }
    
    return self;
}


@end
