//
//  EZPlayPage.m
//  WeiqiStory
//
//  Created by xietian on 12-10-30.
//
//

#import "EZPlayPage.h"
#import "EZConstants.h"
#import "EZEpisodeVO.h"
#import "EZChessBoard.h"
#import "EZActionPlayer.h"
#import "EZProgressBar.h"
#import "EZExtender.h"

//Only 2 status.
//Let's visualize what's was going on for a while.
//Should I disable the progress.
typedef enum {
    kPlayerPlaying,// the button during this stage.
    kPlayerPause//Mean not playing anything, this is play status, right?
} EZPlayStatus;

@interface EZPlayPage()
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
    
    BOOL volumePressed;
    
    NSInteger playButtonStatus;
}

@end

@implementation EZPlayPage

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZPlayPage *layer = [EZPlayPage node];
	
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

/**
//This is criminal secene, I have no time to check it yet.
//It eats up about half hours of my prcious time, I could absolutely squeeze some time out of it.
- (void) initStudyBoard:(EZEpisodeVO*) epv
{
    studyBoardHolder = [[CCNode alloc] init];
    studyBoardHolder.contentSize = CGSizeMake(768, 876);
    studyBoardHolder.anchorPoint = ccp(0, 0);
    studyBoardHolder.position = ccp(0, 0);
    
    studyBoard  = [[EZChessBoard alloc]initWithFile:@"chess-board-pad.png" touchRect:CGRectMake(20, 20, 646, 646) rows:19 cols:19];
    studyBoard.position = ccp(387,475+30);
    //studyBoard.touchEnabled = false;
    
    studyPlayer = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:chessBoard];
    EZDEBUG(@"Action count:%i", epv.actions.count);
    
    [self addChild:studyBoard];
    
    CCMenuItemImage* quitButton = [CCMenuItemImage itemWithNormalImage:@"study-btn-pad.png" selectedImage:@"study-btn-pad.png"
        block:^(id sender){
            [studyBoardHolder removeFromParentAndCleanup:NO];
            studyBoard.touchEnabled = false;
        }
    ];
    CCMenu* quitButtonWrapper = [CCMenu menuWithItems:quitButton, nil];
    quitButtonWrapper.position = ccp(663, 59);
    [studyBoardHolder addChild:quitButtonWrapper];
    //[self addChild:studyBoardHolder];
    
}
**/

- (void) initStudyBoard2:(EZEpisodeVO*)epv
{
    
    studyBoardHolder = [CCSprite spriteWithFile:@"background-pattern-pad.png" rect:CGRectMake(0, 0, 768, 878)];
    //studyBoardHolder.contentSize = CGSizeMake(768, 876);
    studyBoardHolder.anchorPoint = ccp(0, 0);
    studyBoardHolder.position = ccp(0, 0);
    
    
    chessBoard2 = [[EZChessBoard alloc] initWithFile:@"chess-board-pad.png" touchRect:CGRectMake(27, 27, 632, 632) rows:19 cols:19];
    chessBoard2.position = ccp(384, 512);
    [studyBoardHolder addChild:chessBoard2];
    
    CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame-pad.png"];
    boardFrame.position = ccp(384, 512);
    //Why Frame should cover the edge of the board.
    [studyBoardHolder addChild:boardFrame z:10];

    
    //[self addChild:studyBoardHolder];
    player2 = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:chessBoard2];
    CCMenuItemImage* quitButton = [CCMenuItemImage itemWithNormalImage:@"study-over-button-pad.png" selectedImage:@"study-over-button-pad.png"
        block:^(id sender){
            id action = [CCScaleTo actionWithDuration:0.3 scaleX:1 scaleY:0.1];
            //id action = [CCMoveTo actionWithDuration:0.3 position:ccp(0, -studyBoardHolder.position.y)];
            CCAction* removeAction = [CCSequence actions:action,[CCCallBlock actionWithBlock:^(){
                [studyBoardHolder removeFromParentAndCleanup:NO];
            }], nil];
            chessBoard2.touchEnabled = false;
            [studyBoardHolder runAction:removeAction];
        }
    ];
    CCMenu* quitButtonWrapper = [CCMenu menuWithItems:quitButton, nil];
    quitButtonWrapper.position = ccp(663, 75);
    [studyBoardHolder addChild:quitButtonWrapper];
    
    
    CCMenuItemImage* prevButton = [CCMenuItemImage itemWithNormalImage:@"prev-button-pad.png" selectedImage:@"prev-button-pressed-pad.png" block:^(id sender) {
        [chessBoard2 regretSteps:1 animated:NO];
        EZDEBUG(@"Regret queue:%i", chessBoard2.regrets.count);
    }];
    
    CCMenu* prevMenu = [CCMenu menuWithItems:prevButton, nil];
    prevMenu.position = ccp(231, 75);
    [studyBoardHolder addChild:prevMenu];
    
    //What's the meaning of nextStep?, It mean what?
    
    CCMenuItemImage* nextButton = [CCMenuItemImage itemWithNormalImage:@"next-button-pad.png" selectedImage:@"next-button-pressed-pad.png" block:^(id sender){
        EZDEBUG(@"Regret queue:%i", chessBoard2.regrets.count);
        [chessBoard2 redoRegret:NO];
    }];

    CCMenu* nextMenu = [CCMenu menuWithItems:nextButton, nil];
    nextMenu.position = ccp(429, 75);
    [studyBoardHolder addChild:nextMenu];
    
}
//We will only support potrait orientation
- (id) initWithEpisode:(EZEpisodeVO*)epv
{
    self = [super init];
    if(self){
        playButtonStatus = kPlayerPause;
        _episode = epv;
        CGSize winsize = [CCDirector sharedDirector].winSize;
        //CCSprite* background = [[CC]]
        volumePressed = false;
        CCSprite* background = [[CCSprite alloc] initWithFile:@"background-pattern-pad.png"];
        background.anchorPoint = ccp(0, 0);
        background.position = ccp(0, 0);
                
        CCMenuItemImage* backButton = [CCMenuItemImage itemWithNormalImage:@"back-button-pad.png" selectedImage:@"back-button-pressed-pad.png" block:^(id sender){
            [[CCDirector sharedDirector] popScene];
        }];
        
        CCMenu* backMenu = [CCMenu menuWithItems:backButton, nil];
        //menu.anchorPoint = ccp(0, 0);
        backMenu.position =  ccp(96, 950);
        
        
        
        CCSprite* messageRegion = [[CCSprite alloc] initWithFile:@"message-region-pad.png"];
        messageRegion.position = ccp(461, 950);
        
        episodeName = [[CCLabelTTF alloc] initWithString:epv.name fontName:@"Adobe Kaiti Std" fontSize:24];
        episodeName.anchorPoint = ccp(0, 0);
        episodeName.position = ccp(62, messageRegion.contentSize.height - 50);
        [messageRegion addChild:episodeName];
        
        episodeIntro = [[CCLabelTTF alloc] initWithString:epv.introduction fontName:@"Adobe Kaiti Std" fontSize:24];
        episodeIntro.anchorPoint = ccp(0, 0);
        episodeIntro.position = ccp(62, 10);
        
        
        infomationRegion = [[CCLabelTTF alloc] initWithString:@"无用之用是为大用" fontName:@"Adobe Kaiti Std" fontSize:32];
        infomationRegion.anchorPoint = ccp(0, 0.5);
        infomationRegion.position = ccp(messageRegion.contentSize.width/3, messageRegion.contentSize.height/2);
        
        [messageRegion addChild:episodeIntro];
        [messageRegion addChild:infomationRegion];
        
        
        [self addChild:background];
        [self addChild:backMenu];
        [self addChild:messageRegion];

        
        
        
        CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame-pad.png"];
        boardFrame.position = ccp(384, 512);
        //Why Frame should cover the edge of the board.
        [self addChild:boardFrame z:10];
        
        
        chessBoard = [[EZChessBoard alloc]initWithFile:@"chess-board-pad.png" touchRect:CGRectMake(27, 27, 632, 632) rows:19 cols:19];
        chessBoard.position = ccp(384, 512);
        chessBoard.touchEnabled = false;
        
                
        //[self addChild:chessBoard2];
        player = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:chessBoard];
        
        
        //[player2 forwardFrom:0 to:epv.actions.count];
        
        playImg = [CCSprite spriteWithFile:@"play-button-pad.png"];
        pauseImg = [CCSprite spriteWithFile:@"pause-button-pad.png"];
        
        
        CCMenuItemImage* playButton = [CCMenuItemImage itemWithNormalImage:@"play-button-pad.png" selectedImage:@"play-button-pressed-pad.png"
                                       block:^(id sender) {
                                            CCMenuItemImage* imageItem = sender;
                                           EZDEBUG(@"play clicked, play status:%i", playButtonStatus);
                                           if(playButtonStatus == kPlayerPause){
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
        playMenu.position = ccp(87, 75);
        
        CCSprite* progressBar = [[CCSprite alloc] initWithFile:@"progress-bar-pad.png"];
        //progressBar.position = ccp(294, 59);
        
        CCSprite* progressNob = [[CCSprite alloc] initWithFile:@"progress-nob-pad.png"];
        //progressNob.position = ccp(294, 59);
        EZProgressBar* myBar = [[EZProgressBar alloc] initWithNob:progressNob bar:progressBar maxValue:epv.actions.count changedBlock:^(NSInteger prv, NSInteger cur) {
            EZDEBUG(@"Player2 Nob position changed from:%i to %i", prv, cur);
            [player forwardFrom:prv to:cur];
            
        }];
        
        [player.stepCompletionBlocks addObject:^(id sender){
            //Update the progressBar accordingly.
            EZDEBUG(@"One step Completed");
            EZActionPlayer* curPlayer = sender;
            myBar.currentValue = curPlayer.currentAction;
        }];
        
        myBar.position = ccp(170, 60);
        [self addChild:myBar];
        
        CCMenuItemImage* studyButton = [CCMenuItemImage itemWithNormalImage:@"study-button-pad.png" selectedImage:@"study-button-pad.png"
                                        block:^(id sender){
                                            /**
                                            if(!studyBoardHolder){
                                                [self initStudyBoard:epv];
                                            }
                                            
                                            [self addChild:studyBoardHolder];
                                            EZDEBUG(@"Added touch event");
                                            //studyBoard.touchEnabled = true;
                                            
                                            [studyBoard cleanAll];
                                            EZDEBUG(@"play to current position:%i", player.currentAction);
                                            [self performBlock:^(){
                                                [studyPlayer forwardFrom:0 to:player.currentAction];
                                            } withDelay:0.1];
                                            //[studyPlayer play];
                                             **/
                                            if(!player2){
                                                [self initStudyBoard2:epv];
                                            }else{
                                                chessBoard2.touchEnabled = YES;
                                            }
                                            //[self addChild:chessBoard2];
                                            //[studyBoardHolder setScale:0.2];
                                            //studyBoardHolder.position = ccp(studyBoardHolder.position.x, -studyBoardHolder.position.y);
                                            studyBoardHolder.scaleY = 0.1;
                                            [self addChild:studyBoardHolder z:100];
                                            id scaleDown = [CCScaleTo actionWithDuration:0.3f scaleX:1 scaleY:1];
                                            //id moveTo = [CCMoveTo actionWithDuration:0.3f position:ccp(0, 0)];
                                            [studyBoardHolder runAction:scaleDown];
                                            [chessBoard2 cleanAll];
                                            [player2 forwardFrom:0 to:player.currentAction];
                                            EZDEBUG(@"successfully completed raise board");
                                        }
                                        ];
        CCMenu* studyMenu = [CCMenu menuWithItems:studyButton, nil];
        studyMenu.position = ccp(663, 75);
        
        [self addChild:chessBoard];
        
        [self addChild:playMenu];
        
        CCSprite* normalVolume = [CCSprite spriteWithFile:@"volume-button-pad.png"];
        CCSprite* pressedVolume = [CCSprite spriteWithFile:@"volume-button-pressed-pad.png"];
        
        
        EZProgressBar* volumeBar = [[EZProgressBar alloc] initWithNob:[CCSprite spriteWithFile:@"volume-nob-pad.png"] bar:[CCSprite spriteWithFile:@"volume-bar-pad.png"] maxValue:10 changedBlock:^(NSInteger prv, NSInteger cur) {
            CGFloat volume = cur/10.0f;
            EZDEBUG(@"Volume position changed from:%i to %i, final volume will be:%f", prv, cur, volume);
            //[player forwardFrom:prv to:cur];
            player2.soundVolume = volume;
        }];
        volumeBar.currentValue = player2.soundVolume;
        
        CCSprite* volumeFrame = [CCSprite spriteWithFile:@"volume-frame-pad.png"];
        volumeBar.position = ccp(6, 6);
        [volumeFrame addChild:volumeBar];
        
        CCMenu* volume = [CCMenu menuWithItems:[CCMenuItemImage itemWithNormalImage:@"volume-button-pad.png" selectedImage:@"volume-button-pressed-pad.png" block:^(id sender) {
            CCMenuItemImage* item = sender;
            if(volumePressed){
                EZDEBUG(@"Will hide volume bar");
                volumePressed = false;
                //Hide the volume adjust region.
                [item setNormalSpriteFrame:normalVolume.displayFrame];
                CCSpawn* action = [CCSpawn actions:[CCMoveTo actionWithDuration:0.3 position:ccp(492, 70)], [CCScaleTo actionWithDuration:0.3 scale:0.1], nil];
                CCAction* combined = [CCSequence actions:action,[CCCallBlock actionWithBlock:^(){
                    [volumeFrame removeFromParentAndCleanup:NO];
                }], nil];
                [volumeFrame runAction:combined];
            }else{
                EZDEBUG(@"Will show volume bar");
                [item setNormalSpriteFrame:pressedVolume.displayFrame];
                //Enlarge the volume adjust region.
                volumePressed = true;
                volumeFrame.scale = 0.1;
                volumeFrame.position = ccp(492, 70);
                //Why 9, make it small than the volume button,
                //So it will hide below the volume button
                [self addChild:volumeFrame z:9];
                CCSpawn* action = [CCSpawn actions:[CCMoveTo actionWithDuration:0.3 position:ccp(529, 32)],[CCScaleTo actionWithDuration:0.3 scale:1], nil];
                [volumeFrame runAction:action];
            }
        }], nil];
        
        volume.position = ccp(492, 75);
        
        [self addChild:volume z:10];
        //[self addChild:progressBar];
        //[self addChild:progressNob];
        [self addChild:studyMenu];
        
        
    }
    
    return self;
}


@end
