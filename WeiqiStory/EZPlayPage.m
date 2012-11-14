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
    
    CCNode* mainLayout;
    
    CCSprite* bubble;
    CCSprite* broken;
    
    //CCTimer* timer;
    
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
    
    CCMenuItemImage* quitButton = [CCMenuItemImage itemWithNormalImage:@"studyover-pad.png" selectedImage:@"study-btn-pad.png"
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
    
    //studyBoardHolder = [CCSprite spriteWithFile:@"background-pattern.png" rect:CGRectMake(0, 0, 768, 878)];
    //studyBoardHolder.contentSize = CGSizeMake(768, 876);
    studyBoardHolder = [[CCNode alloc] init];
    studyBoardHolder.contentSize = CGSizeMake(768, 876);
    studyBoardHolder.anchorPoint = ccp(0.5, 0);
    studyBoardHolder.position = ccp(768/2, 0);
    
    
    chessBoard2 = [[EZChessBoard alloc] initWithFile:@"chess-board.png" touchRect:CGRectMake(27, 27, 632, 632) rows:19 cols:19];
    chessBoard2.position = ccp(384, 512);
    [studyBoardHolder addChild:chessBoard2 z:9];
    
    CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
    boardFrame.position = ccp(384, 512);
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
                [self addChild:mainLayout z:5];
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
    quitButtonWrapper.position = ccp(663, 75);
    [studyBoardHolder addChild:quitButtonWrapper];
    
    
    CCMenuItemImage* prevButton = [CCMenuItemImage itemWithNormalImage:@"prev-button.png" selectedImage:@"prev-button-pressed-pad.png" block:^(id sender) {
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
        [chessBoard2 regretSteps:1 animated:NO];
        EZDEBUG(@"Regret queue:%i", chessBoard2.regrets.count);
    }];
    
    CCMenu* prevMenu = [CCMenu menuWithItems:prevButton, nil];
    prevMenu.position = ccp(231, 75);
    [studyBoardHolder addChild:prevMenu];
    
    //What's the meaning of nextStep?, It mean what?
    
    CCMenuItemImage* nextButton = [CCMenuItemImage itemWithNormalImage:@"next-button.png" selectedImage:@"next-button-pressed-pad.png" block:^(id sender){
        EZDEBUG(@"Regret queue:%i", chessBoard2.regrets.count);
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
        [chessBoard2 redoRegret:NO];
    }];

    CCMenu* nextMenu = [CCMenu menuWithItems:nextButton, nil];
    nextMenu.position = ccp(429, 75);
    [studyBoardHolder addChild:nextMenu];
    
}

- (void) onExit
{
    if(chessBoard2.touchEnabled){
        //Make sure, it get removed from the event chains
        chessBoard2.touchEnabled = false;
    }
}

- (void) generatedBubble:(ccTime)time
{
    EZDEBUG(@"Generate bubble2");
    CGFloat xStartPos = arc4random()%768;
    CGFloat xEndPos = arc4random()%768;
    CGFloat yEndPos = 1048;
    CGFloat addDuration = arc4random()%5;
    
    CGFloat duration = 5 + addDuration;
    EZBubble* randBubble = [[EZBubble alloc] initWithBubble:[CCSprite spriteWithSpriteFrame:bubble.displayFrame] broken:[CCSprite spriteWithSpriteFrame:broken.displayFrame]];
    //CCNode* randBubble = [[EZBubble2 alloc] init];
    randBubble.contentSize = bubble.contentSize;
    CGFloat finalScale =0.5 + 0.2 * (arc4random() % 4);
    
    CGFloat finalAngle = 90 * (arc4random() % 5);
    
    randBubble.scale = 0.5;
    randBubble.position = ccp(xStartPos, 0);
    [self addChild:randBubble z:100];
    id animate =  [CCSpawn actions:[CCMoveTo actionWithDuration:duration position:ccp(xEndPos, yEndPos)],[CCRotateBy actionWithDuration:duration angle:finalAngle], [CCScaleTo actionWithDuration:duration scale:finalScale], nil];
    id action = [CCSequence actions:animate,[CCCallBlock actionWithBlock:^(){
        [randBubble removeFromParentAndCleanup:YES];
    }], nil];
    [randBubble runAction:action];
}
//We will only support potrait orientation
- (id) initWithEpisode:(EZEpisodeVO*)epv
{
    self = [super init];
    if(self){
        //timer = [[CCTimer alloc] initWithTarget:self selector:@selector(generatedBubble) interval:1 repeat:kCCRepeatForever delay:1];
        EZDEBUG(@"Before Called schedule");
        [self schedule:@selector(generatedBubble:) interval:1.0 repeat:kCCRepeatForever delay:0.5];
        EZDEBUG(@"After called");
        
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
        messageRegion.position = ccp(461, 950);
        
        episodeName = [[CCLabelTTF alloc] initWithString:epv.name fontName:@"Adobe Kaiti Std" fontSize:24];
        episodeName.anchorPoint = ccp(0, 0);
        episodeName.position = ccp(62, messageRegion.contentSize.height - episodeName.contentSize.height - 15);
        [messageRegion addChild:episodeName];
        
        episodeIntro = [[CCLabelTTF alloc] initWithString:epv.introduction fontName:@"Adobe Kaiti Std" fontSize:24];
        episodeIntro.anchorPoint = ccp(0, 0);
        episodeIntro.position = ccp(62, 0);
        
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
        mainLayout.contentSize = CGSizeMake(768, 878);
        //studyBoardHolder.contentSize = CGSizeMake(768, 876);
        mainLayout.anchorPoint = ccp(0.5, 0);
        mainLayout.position = ccp(768/2, 0);
        
        [self addChild:mainLayout z:5];
        
        CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
        boardFrame.position = ccp(384, 512);
        //Why Frame should cover the edge of the board.
        [mainLayout addChild:boardFrame z:10];
        
        
        chessBoard = [[EZChessBoard alloc]initWithFile:@"chess-board.png" touchRect:CGRectMake(27, 27, 632, 632) rows:19 cols:19];
        chessBoard.position = ccp(384, 512);
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
        backMenu.position =  ccp(96, 950);
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
        playMenu.position = ccp(87, 75);
        
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
        
        myBar.position = ccp(170, 60);
        [mainLayout addChild:myBar];
        
        if(epv.actions.count > 0){
            [player playOneStep:0 completeBlock:nil];
        }
        
        CCMenuItemImage* studyButton = [CCMenuItemImage itemWithNormalImage:@"study-button.png" selectedImage:@"study-button-pad.png"
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
                                                [self addChild:studyBoardHolder z:100];
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
        studyMenu.position = ccp(663, 75);
        
        [mainLayout addChild:chessBoard z:9];
        
        [mainLayout addChild:playMenu];
        
        CCSprite* normalVolume = [CCSprite spriteWithFile:@"volume-button.png"];
        CCSprite* pressedVolume = [CCSprite spriteWithFile:@"volume-button-pressed.png"];
        
        
        EZProgressBar* volumeBar = [[EZProgressBar alloc] initWithNob:[CCSprite spriteWithFile:@"volume-nob.png"] bar:[CCSprite spriteWithFile:@"volume-bar.png"] maxValue:10 changedBlock:^(NSInteger prv, NSInteger cur) {
            CGFloat volume = cur/10.0f;
            EZDEBUG(@"Volume position changed from:%i to %i, final volume will be:%f", prv, cur, volume);
            //[player forwardFrom:prv to:cur];
            player2.soundVolume = volume;
        }];
        volumeBar.currentValue = player2.soundVolume;
        
        CCSprite* volumeFrame = [CCSprite spriteWithFile:@"volume-frame-pad.png"];
        volumeBar.position = ccp(6, 6);
        [volumeFrame addChild:volumeBar];
        
        CCMenu* volume = [CCMenu menuWithItems:[CCMenuItemImage itemWithNormalImage:@"volume-button.png" selectedImage:@"volume-button-pressed.png" block:^(id sender) {
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
        
        [mainLayout addChild:volume z:10];
        //[self addChild:progressBar];
        //[self addChild:progressNob];
        [mainLayout addChild:studyMenu];
        
        
    }
    
    return self;
}


@end
