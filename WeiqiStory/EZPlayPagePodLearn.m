//
//  EZPlayPagePodLearn.m
//  WeiqiStory
//
//  Created by xietian on 12-12-13.
//
//

//The purpose of this class is to enable client to learn the first

#import "EZPlayPagePodLearn.h"
#import "EZConstants.h"
#import "EZEpisodeVO.h"
#import "EZChessBoard.h"
#import "EZActionPlayer.h"
#import "EZProgressBar.h"
#import "EZExtender.h"
#import "EZSoundManager.h"
#import "EZBubble.h"
#import "EZBubble2.h"
//#import "EZResizeChessBoard.h"
#import "EZListTablePagePod.h"
#import "EZEpisode.h"
#import "EZCoreAccessor.h"
//#import "EZFlexibleBoard.h"
#import "EZFlexibleResizeBoard.h"
#import "MobClick.h"
#import "EZShape.h"
#import "EZFileUtil.h"
#import "EZExtender.h"


//Only 2 status.
//Let's visualize what's was going on for a while.
//Should I disable the progress.
typedef enum {
    kPlayerPlaying,// the button during this stage.
    kPlayerPause//Mean not playing anything, this is play status, right?
} EZPlayStatus;

@interface EZPlayPagePodLearn()
{
    
}

@end

@implementation EZPlayPagePodLearn

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZPlayPagePodLearn *layer = [EZPlayPagePodLearn node];
	
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


- (EZEpisodeVO*) getEpisode:(NSInteger)curPos
{
    NSArray* arr = [[EZCoreAccessor getClientAccessor] fetchObject:[EZEpisode class] begin:curPos limit:1];
    if(arr.count > 0){
        EZEpisodeVO* res = [[EZEpisodeVO alloc] initWithPO:[arr objectAtIndex:0]];
        return res;
    }
    return nil;
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
    //_resizeBoard = [[EZResizeChessBoard alloc] initWithOrgBoard:@"chess-board.png" orgRect:CGRectMake(13, 13, 271, 271) largeBoard:@"chess-board-large.png" largeRect:CGRectMake(27, 27, 632, 632)];
    _flexibleBoard = [[EZFlexibleResizeBoard alloc] initWithBoard:@"chess-board-large.png" boardTouchRect:CGRectMake(27, 27, 632, 632) visibleSize:CGSizeMake(310, 310)];
    
    
    _chessBoard2 = _flexibleBoard.chessBoard;
    
    //_resizeBoard.contentSize = _resizeBoard.orgBoard.contentSize;
    //_flexibleBoard.basicPatterns = epv.basicPattern;
    _flexibleBoard.anchorPoint = ccp(0.5, 0.5);
    _flexibleBoard.position = ccp(320/2, 244-2);
    //chessBoard2.anchorPoint = ccp(0.5, 0.5);
    [_studyBoardHolder addChild:_flexibleBoard z:9];
    
    CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
    boardFrame.position = ccp(320/2, 244);
    //boardFrame.anchorPoint = ccp(0.5, 0.5);
    //_resizeBoard.enlargedBoard.cursorHolder = boardFrame;
    _flexibleBoard.chessBoard.cursorHolder = boardFrame;
    //Why Frame should cover the edge of the board.
    [_studyBoardHolder addChild:boardFrame z:10];
    
    
    //[self addChild:studyBoardHolder];
    _player2 = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:_flexibleBoard.chessBoard inMainBundle:epv.inMainBundle];
    
    //EZActionPlayer* playerTmp = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:resizeBoard.enlargedBoard inMainBundle:epv.inMainBundle];
    __weak EZPlayPagePodLearn* weakSelf = self;
    
    CCMenuItemImage* quitButton = [CCMenuItemImage itemWithNormalImage:@"study-over-button.png" selectedImage:@"study-over-button.png"
                                                                 block:^(id sender){
                                                                     [weakSelf quitButtonClicked:epv];
                                                                 }
                                   ];
    
    CCMenu* quitButtonWrapper = [CCMenu menuWithItems:quitButton, nil];
    quitButtonWrapper.position = ccp(262, 47);
    //quitButtonWrapper.anchorPoint = ccp(0.5, 0.5);
    [_studyBoardHolder addChild:quitButtonWrapper];
    
    
    CCMenuItemImage* prevButton = [CCMenuItemImage itemWithNormalImage:@"prev-button.png" selectedImage:@"prev-button-pressed.png" block:^(id sender) {
        [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
        [MobClick event:@"prev_step_clicked" label:nil];
        [weakSelf.chessBoard2 regretSteps:1 animated:NO];
        EZDEBUG(@"Regret queue:%i", weakSelf.chessBoard2.regrets.count);
    }];
    
    CCMenu* prevMenu = [CCMenu menuWithItems:prevButton, nil];
    //prevMenu.anchorPoint = ccp(0.5, 0.5);
    prevMenu.position = ccp(58, 47);
    [_studyBoardHolder addChild:prevMenu];
    
    //What's the meaning of nextStep?, It mean what?
    
    CCMenuItemImage* nextButton = [CCMenuItemImage itemWithNormalImage:@"next-button.png" selectedImage:@"next-button-pressed.png" block:^(id sender){
        EZDEBUG(@"Regret queue:%i", weakSelf.chessBoard2.regrets.count);
        [MobClick event:@"next_step_clicked" label:nil];
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
    
    _flexibleBoard.touchBlock = ^(){
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


//Actully, this is a better solution then using the weakSelf, the code is more readable.
- (void) quitButtonClicked:(EZEpisodeVO*)epv
{
    EZPlayPagePodLearn* weakSelf = self;
    [MobClick event:@"study_over_clicked" label:nil];
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
        if(!weakSelf.mainLayout){
            [weakSelf createMainLayout:epv];
        }
        
        [weakSelf.mainLayout removeFromParentAndCleanup:NO];
        weakSelf.mainLayout.scaleX = 0.05;
        [weakSelf.mainFlexBoard backToRollStatus];
        [weakSelf addChild:weakSelf.mainLayout z:10];
        id scaleDown = [CCScaleTo actionWithDuration:0.3f scaleX:1 scaleY:1];
        id scaleDownComplete = [CCCallBlock actionWithBlock:^(){
            [weakSelf.mainFlexBoard recalculateBoardRegion];
        }];
        //id moveTo = [CCMoveTo actionWithDuration:0.3f position:ccp(0, 0)];
        [weakSelf.mainLayout runAction:[CCSequence actions:scaleDown, scaleDownComplete, nil]];
        [weakSelf.studyBoardHolder removeFromParentAndCleanup:NO];
    }];
    id sequence = [CCSequence actions:animation, completed, nil];
    weakSelf.flexibleBoard.touchEnabled = false;
    [weakSelf.flexibleBoard backToRollStatus];
    [weakSelf.studyBoardHolder runAction:sequence];
}
- (void) onExit
{
    //if(chessBoard2.touchEnabled){
    //Make sure, it get removed from the event chains
    //chessBoard2.touchEnabled = false;
    //}
    [super onExit];
}


- (void) showCommentArea:(EZOperationBlock)showBlock completeBlock:(EZOperationBlock)completeBlock
{
    //Mean only show it if not visiable yet.
    if(_isCommentShowing){
        EZDEBUG(@"Already showing, will call the block directly");
        if(showBlock){
            showBlock();
        }
        if(completeBlock){
            completeBlock();
        }
        
        return;
    }
    _isCommentShowing = true;
    __weak EZPlayPagePodLearn* weakSelf = self;
    [UIView animateWithDuration:0.3
                    delay:0.0 options:UIViewAnimationOptionCurveEaseOut 
                     animations:^(){
                         ///weakSelf.textView.layer.transform = CATransform3DIdentity;}];
                         [weakSelf.commentBackground setPosition:ccp(75, 0)];
                         //weakSelf.revealButton.layer.anchorPoint = ccp(0.5, 0.5);
                         weakSelf.revealButton.layer.transform = CATransform3DConcat(CATransform3DIdentity, CATransform3DMakeRotation(M_PI, 0, 0, 1.0));
                         [weakSelf.revealButton setPosition:ccp(60+ _commentBackground.bounds.size.width/2, weakSelf.commentBackground.bounds.size.height-30)];
                         if(showBlock){
                             showBlock();
                         }
                     }
                     completion:^(BOOL complete){
                         if(completeBlock){
                             completeBlock();
                         }
                     }
     ];
}

- (void) hideCommentArea:(EZOperationBlock)hideCalledBlock completeBlock:(EZOperationBlock)completeBlock
{
    if(!_isCommentShowing){
        EZDEBUG(@"Already hide will call the block directly");
        if(hideCalledBlock){
            hideCalledBlock();
        }
        if(completeBlock){
            completeBlock();
        }
        return;
    }
    _isCommentShowing = false;
    __weak EZPlayPagePodLearn* weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
        [weakSelf.commentBackground setPosition:ccp(75, -weakSelf.commentBackground.bounds.size.height)];
        //weakSelf.revealButton.layer.anchorPoint = ccp(0.5, 0.5);
        weakSelf.revealButton.layer.transform = CATransform3DIdentity;
        [weakSelf.revealButton setPosition:ccp(60+ _commentBackground.bounds.size.width/2,-25)];
        if(hideCalledBlock){
            hideCalledBlock();
        }
    }
        completion:^(BOOL completed){
            if(completeBlock){
                completeBlock();
            }
        }
     ];

}

//I only call this method once,
//I assume replace the javascript will be faster than this method.
- (void) loadUIWebView
{
    NSString* basicFormat = @"<html><head>\
    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\
    <style type='text/css'>\
    body {font-family:Adobe Kaiti Std; \
    color: white;\
    back-ground-color: transparent;\
    }\
    div {font-size:18px; padding:2px; line-height:20px; letter-spacing:－2px;}\
    </style>\
    </head><body><div id='test'></div></body></html>";
    NSString *path = [[NSBundle mainBundle] bundlePath];
    [_textView loadHTMLString:basicFormat baseURL:[NSURL fileURLWithPath:path]];
}

//Current implmentation will consider 2 size
//Large size or smaller size.
//Based on the number of characters.
//I will adjust both the text size and the Comment Region size to reflect this needs
- (void) adjustSizeByCharNumber:(NSString*)strs;
{
    EZDEBUG(@"Adjust the comment region by the char counts:%i", strs.length);
    if(strs.length > 5){
        if(_commentBackground == _smallCommentBackground){
            [self switchCommentRegion:YES];
        }else{
            EZDEBUG(@"already large Board, let's stick with it");
        }
        
    }else{
        if(_commentBackground == _largeCommentBackground){
            [self switchCommentRegion:NO];
        }else{
            EZDEBUG(@"already small Board, let's stick with it");
        }
        
    }
}

- (void) switchCommentRegion:(BOOL)smallToBig
{
    EZDEBUG(@"switch comment region:%@", smallToBig?@"SmallToBig":@"BigToSmall");
     [_commentBackground removeFromSuperview];
    if(smallToBig){
        _commentBackground = _largeCommentBackground;
    }else{
        _commentBackground = _smallCommentBackground;
    }
    //Add animation later, if the region visible, I prefer the iterative way.
    //My favoriate way is iterativ way
    
    [_textView removeFromSuperview];
    [_textView setFrame:CGRectMake(0, 0, _textView.frame.size.width, _commentBackground.bounds.size.height)];
    
    _textView.center = ccp(_commentBackground.bounds.size.width/2, _commentBackground.bounds.size.height/2);
    
    [_commentBackground addSubview:_textView];
    [[CCDirector sharedDirector].view addSubview:_commentBackground];
    //We will ask the comment animation to show the comment
    _isCommentShowing = false;
}
//I may need add the animation later, now keep it simple and stupid.
//Let's fix the drag issue, why sometime I will have an empty.
- (void) showComment:(NSString*)comment
{
    EZDEBUG(@"showComment");
    __weak EZPlayPagePodLearn* weakSelf = self;
    CGPoint orgPos = _textView.center;
    EZDEBUG(@"Original position:%@, center:%@", NSStringFromCGPoint(orgPos), NSStringFromCGPoint(_textView.center));
    [self adjustSizeByCharNumber:comment];
    
    NSString* formatedStr =[NSString stringWithFormat: @"document.getElementById('test').innerHTML = '%@'", comment];
    
    
    [self showCommentArea:nil completeBlock:^(){
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(){
            //[weakSelf.textView setPosition:ccp(-weakSelf.textView.bounds.size.width, orgPos.y)];
            //weakSelf.textView.center = ccp(-weakSelf.textView.bounds.size.width/2, orgPos.y);
            weakSelf.textView.alpha = 0.0;
        
        } completion:^(BOOL completed){
            [weakSelf.textView stringByEvaluatingJavaScriptFromString:formatedStr];
            //weakSelf.textView.center = ccp(weakSelf.textView.bounds.size.width , orgPos.y);
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^(){
                //weakSelf.textView.center = ccp(orgPos.x, orgPos.y);
                weakSelf.textView.alpha = 1.0;
                
            } completion:nil];
        }];
    
    }];
    
    /**
    [UIView animateWithDuration:0.3 animations:^(){
            //weakSelf.commentBackground.layer.anchorPoint = ccp(0.5, 0.5);
            //weakSelf.textView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
            //weakSelf.commentBackground.layer.transform = CATransform3DMakeTranslation(0, -weakSelf.commentBackground.bounds.size.height, 0);
            [weakSelf.commentBackground setPosition:ccp(75, -weakSelf.commentBackground.bounds.size.height)];
            [weakSelf.textView loadHTMLString:formatedStr baseURL:[NSURL fileURLWithPath:path]];
     }
     
        completion:^(BOOL completed){
            [UIView animateWithDuration:0.3
                             animations:^(){
            ///weakSelf.textView.layer.transform = CATransform3DIdentity;}];
            [weakSelf.commentBackground setPosition:ccp(75, 0)];}
             ];}];
    //_textView.alpha = 0.5;
    **/
}

//This comment may get showed beside the exact move
- (void) showMoveComment:(NSString*)comment
{
    EZDEBUG(@"showMoveComment");
    [self showComment:comment];
}

- (NSString*) getComment
{
    return @"empty";
}

//This comment may get showed beside the exact move
- (NSString*) getMoveComment
{
    return @"empty";
}

- (void) nextAction:(id)sender
{
    EZDEBUG(@"Next clicked,Current action number:%i", self.player.currentAction);
    [self.player next];
}

- (void) prevAction:(id)sender
{
    EZDEBUG(@"Prev clicked, Current action number:%i", self.player.currentAction);
    [self.player undoOneStep];
}

- (UIImageView*) loadCommentRegionFile:(NSString*)fileName
{
    UIImageView* res = [[UIImageView alloc]initWithImage:[EZFileUtil imageFromFile:fileName scale:[UIScreen mainScreen].scale]];
    res.layer.cornerRadius = 10;
    res.layer.masksToBounds = true;
    [res.layer setShadowOffset:CGSizeMake(3.0, 3.0)];
    res.userInteractionEnabled = true;
    [res setPosition:ccp(72, -res.bounds.size.height)];
    return res;
}

- (void) addTextShower
{
    //_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 60, 100, 100)];
    _textView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 200, 80)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.opaque = NO;
    [self loadUIWebView];
    //_textView.font = [UIFont fontWithName:@"Adobe Kaiti Std" size:20];
    //_textView.layer.cornerRadius = 10;
    //_textView.layer.masksToBounds = true;
    
    _largeCommentBackground = [self loadCommentRegionFile:@"large-comment-region.png"];
    _smallCommentBackground = [self loadCommentRegionFile:@"comment-region.png"];

    
    
    _commentBackground = _smallCommentBackground;

    _textView.center =  ccp(_commentBackground.bounds.size.width/2, _commentBackground.bounds.size.height/2);
    
    
    [_commentBackground addSubview:_textView];
    
    
    _revealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_revealButton setImage:[EZFileUtil imageFromFile:@"reveal.png" scale:[UIScreen mainScreen].scale] forState:UIControlStateNormal];
    
    [_revealButton setFrame:CGRectMake(60+ _commentBackground.bounds.size.width/2,-25, 44, 66)];
    //[_revealButton setPosition:ccp(_commentBackground.bounds.size.width/2,_commentBackground.bounds.size.height-10)];
    [_revealButton addTarget:self action:@selector(revealClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[CCDirector sharedDirector].view addSubview:_commentBackground];
    [[CCDirector sharedDirector].view addSubview:_revealButton];
 
    //[[CCDirector sharedDirector].view addSubview:reveal];
    
}


//what should this method do?
- (void) revealClicked:(id)sender
{
    EZDEBUG(@"Reveal clicked:%@", _isCommentShowing?@"Showed":@"Hidden");
    if(!_isCommentShowing){
        [self showCommentArea:nil completeBlock:nil];
    }else{
        [self hideCommentArea:nil completeBlock:nil];
    }
}

//As it's name imply
- (void) addTestStepBackAndForth
{
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextButton.frame = CGRectMake(200, 0, 88, 44);
    [nextButton setTitle:@"Next Action" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    
    UIButton* prevButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    prevButton.frame = CGRectMake(40, 0, 88, 44);
    [prevButton setTitle:@"Prev Action" forState:UIControlStateNormal];
    [prevButton addTarget:self action:@selector(prevAction:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    
    [[CCDirector sharedDirector].view addSubview:nextButton];
    [[CCDirector sharedDirector].view addSubview:prevButton];
    
}


//We will only support potrait orientation
- (id) initWithEpisode:(EZEpisodeVO*)epv currentPos:(NSInteger)pos
{
    self = [super initWithPos:pos];
    if(self){
        //[self addTestStepBackAndForth];
        [self addTextShower];
        
        //Test code
        //[self showComment:@"我爱大大棒棒糖"];
        /**
        EZShape* shape = [[EZShape alloc] init];
        shape.lineWidth = 4;
        shape.contentSize = CGSizeMake(300, 300);
        shape.position = ccp(0, 0);
        
        [self addChild:shape z:1000];
        **/
        //timer = [[CCTimer alloc] initWithTarget:self selector:@selector(generatedBubble) interval:1 repeat:kCCRepeatForever delay:1];
        self.currentEpisodePos = pos;
        __weak EZPlayPagePodLearn* weakSelf = self;
        [self scheduleBlock:^(){
            [EZBubble generatedBubble:weakSelf z:9];
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
        
        
        CCMenuItemImage* backButton = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button-pressed.png" block:^(id sender){
            [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            [weakSelf.player stop];
            [[CCDirector sharedDirector] replaceScene:[EZListTablePagePod node]];
            [MobClick event:@"back_clicked" label:nil];
        }];
        
        CCMenu* backMenu = [CCMenu menuWithItems:backButton, nil];
        //menu.anchorPoint = ccp(0, 0);
        backMenu.position =  ccp(42, 440);
        
        
        NSInteger deviceType = [[CCFileUtils sharedFileUtils] runningDevice];
        if(deviceType == kCCiPhone5){
            backMenu.position = ccp(42, 518);
            messageRegion.position = ccp(192, 518);
            
            NSInteger nextPos = self.currentEpisodePos + 1;
            NSInteger prevPos = self.currentEpisodePos - 1;
            
            EZEpisodeVO* prevEpv = [weakSelf getEpisode:prevPos];
            EZEpisodeVO* nextEpv = [weakSelf getEpisode:nextPos];
            
            
            
            EZDEBUG(@"Curent Position:%i, prevEpv name:%@, nextEpv name:%@, nonWeakValue:%i, self pointer:%i, prevPos:%i, nextPos:%i", weakSelf.currentEpisodePos, prevEpv.name, nextEpv.name, self.currentEpisodePos, (int)self, prevPos, nextPos);
            
            CCMenuItemImage* playPrevItem = [CCMenuItemImage itemWithNormalImage:@"play-prev.png" selectedImage:@"play-prev-pressed.png" disabledImage:@"play-prev-pressed.png" block:^(id sender){
                EZDEBUG(@"Prev clicked");
                [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
                [weakSelf.player pause];
                EZPlayPagePodLearn* nextPage = [[EZPlayPagePodLearn alloc] initWithEpisode:prevEpv currentPos:prevPos];
                //nextPage.currentEpisodePos = weakSelf.currentEpisodePos - 1;
                EZDEBUG(@"Will replace current scene with:%@", prevEpv.name);
                [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene:[nextPage createScene]]];
                
            }];
            
            CCMenu* playPrev = [CCMenu menuWithItems:playPrevItem, nil];
            if(prevEpv == nil){
                playPrevItem.isEnabled = false;
            }
            
            playPrev.position = ccp(45, 448);
            
            CCMenuItemImage* playNextItem = [CCMenuItemImage itemWithNormalImage:@"play-next.png" selectedImage:@"play-next-pressed.png" disabledImage:@"play-next-pressed.png" block:^(id sender){
                [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
                EZDEBUG(@"Next clicked");
                [weakSelf.player pause];
                EZPlayPagePodLearn* nextPage = [[EZPlayPagePodLearn alloc] initWithEpisode:nextEpv currentPos:nextPos];
                //nextPage.currentEpisodePos = weakSelf.currentEpisodePos + 1;
                EZDEBUG(@"Will replace curent scene for:%@", nextEpv.name);
                [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[nextPage createScene]]];
            }];
            
            
            CCMenu* playNext = [CCMenu menuWithItems:playNextItem, nil];
            playNext.position = ccp(279, 448);
            if(nextEpv == nil){
                //playNext.enabled = false;
                playNextItem.isEnabled = false;
            }
            
            //[self addChild:playNext];
            //[self addChild:playPrev];
        }
        
        [self addChild:backMenu];
        [self addChild:messageRegion];
        
        /**
        [self showStudyBoard:epv];
         **/
        
        [self showLearningBoard:epv];
    }
    
    return self;
}

//Will called in the initial method, if you want to show the study board.
- (void) showStudyBoard:(EZEpisodeVO*)epv
{
    [self initStudyBoard2:epv];
    _flexibleBoard.basicPatterns = epv.basicPattern;
    _flexibleBoard.touchEnabled = true;
    [self addChild:_studyBoardHolder z:10];
    [self setupStudyBoard:epv];
}

//The same with this method.
//To simplify the cases with the switching
- (void) showLearningBoard:(EZEpisodeVO*)epv
{
    [self createMainLayout:epv];
    [self addChild:_mainLayout z:10];
    
    EZDEBUG(@"Show a mark");
    [_chessBoard putCharMark:@"F" fontSize:30 coord:[[EZCoord alloc] init:15 y:8] animAction:nil];
    //[_mainFlexBoard setBasicPatterns:epv.basicPattern i];
    [_mainFlexBoard calculateRegionForPattern:epv.basicPattern isPlant:NO];
}

- (void) createMainLayout:(EZEpisodeVO*)epv
{
    //mainLayout = [CCSprite spriteWithFile:@"background-pattern.png" rect:CGRectMake(0, 0, 768, 878)];
    __weak EZPlayPagePodLearn* weakSelf = self;
    _mainLayout = [[CCNode alloc] init];
    _mainLayout.contentSize = CGSizeMake(320, 397);
    //studyBoardHolder.contentSize = CGSizeMake(768, 876);
    _mainLayout.anchorPoint = ccp(0.5, 0);
    _mainLayout.position = ccp(320/2, 0);
    
    //[self addChild:_mainLayout z:10];
    
    CCSprite* boardFrame = [[CCSprite alloc] initWithFile:@"board-frame.png"];
    boardFrame.position = ccp(320/2, 244);
    //Why Frame should cover the edge of the board.
    [_mainLayout addChild:boardFrame z:10];
    
    
    //_chessBoard = [[EZChessBoard alloc]initWithFile:@"chess-board.png" touchRect:CGRectMake(13, 13, 271, 271) rows:19 cols:19];
    //_chessBoard.position = ccp(320/2, 244);
    //_chessBoard.touchEnabled = false;
    
    
    _mainFlexBoard = [[EZFlexibleResizeBoard alloc] initWithBoard:@"chess-board-large.png" boardTouchRect:CGRectMake(27, 27, 632, 632) visibleSize:CGSizeMake(310, 310)];
    
    
    _chessBoard = _mainFlexBoard.chessBoard;
    //Disable the touch event.
    _mainFlexBoard.touchEnabled = false;
    //_resizeBoard.contentSize = _resizeBoard.orgBoard.contentSize;
    //_flexibleBoard.basicPatterns = epv.basicPattern;
    _mainFlexBoard.anchorPoint = ccp(0.5, 0.5);
    //fix for the chessman cut problem.
    //The simplest solution should be increase the skirt of the board, in the meanwhile
    //cut the inner of the frame. 
    _mainFlexBoard.position = ccp(320/2, 244-2);
    
    //[self addChild:chessBoard2];
    //Progress Bar test
    self.player = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:_chessBoard inMainBundle:epv.inMainBundle];
    
    EZChessBoard* backBoard = [[EZChessBoard alloc] initWithFile:@"chess-board.png" touchRect:CGRectMake(13, 13, 271, 271) rows:19 cols:19];
    
    backBoard.anchorPoint = ccp(0.5, 0.5);
    backBoard.position = ccp(0, 244);
    backBoard.touchEnabled = false;
    
    //[self addChild:backBoard z:100];
    EZActionPlayer* backPlayer = [[EZActionPlayer alloc] initWithActions:epv.actions chessBoard:backBoard inMainBundle:epv.inMainBundle];
    backPlayer.textShower = self;
    //End of progress bar test
    
    self.player.textShower = self;
    //[player2 forwardFrom:0 to:epv.actions.count];
    
    _playImg = [CCSprite spriteWithFile:@"play-button.png"];
    _pauseImg = [CCSprite spriteWithFile:@"pause-button.png"];
    
    //__weak EZPlayPagePod* weakSelf = self;
    
    
    
    _playButton = [CCMenuItemImage itemWithNormalImage:@"play-button.png" selectedImage:@"play-button-pressed.png"
                                                                 block:^(id sender) {
                                                                     [weakSelf playClicked:sender];
                                                                 }
                                   ];
    CCMenu* playMenu = [CCMenu menuWithItems:_playButton, nil];
    playMenu.position = ccp(44, 47);
    
    CCSprite* progressBar = [[CCSprite alloc] initWithFile:@"progress-bar.png"];
    //progressBar.position = ccp(294, 59);
    
    CCSprite* progressNob = [[CCSprite alloc] initWithFile:@"progress-nob.png"];
    //progressNob.position = ccp(294, 59);
    EZProgressBar* myBar = [[EZProgressBar alloc] initWithNob:progressNob bar:progressBar maxValue:epv.actions.count changedBlock:^(NSInteger prv, NSInteger cur) {
        EZDEBUG(@"Player2 Nob position changed from:%i to %i", prv, cur);
        [MobClick event:@"progress_dragged" label:[NSString stringWithFormat:@"from:%i to %i",prv, cur]];
        //pause the player, no harm will be done
        //The bug maybe here. mean I play from this place to next one
        [weakSelf.player pause];
        [_playButton setNormalSpriteFrame:weakSelf.playImg.displayFrame];
        [_chessBoard cleanAll];
        [weakSelf.player forwardFrom:0 to:cur];
        //[weakSelf.player forwardFrom:prv to:cur];
        
        //[backBoard cleanAll];
        //[backPlayer forwardFrom:0 to:cur];
        
    }];
    
    [self.player.stepCompletionBlocks addObject:^(id sender){
        //Update the progressBar accordingly.
        EZDEBUG(@"One step Completed");
        EZActionPlayer* curPlayer = sender;
        myBar.currentValue = curPlayer.currentAction;
    }];
    
    myBar.position = ccp(78, 37);
    [_mainLayout addChild:myBar];
    
    if(epv.actions.count > 0){
        [self.player playOneStep:0 completeBlock:nil];
    }
    
    CCMenuItemImage* studyButton = [CCMenuItemImage itemWithNormalImage:@"study-button.png" selectedImage:@"study-button.png"
                                                                  block:^(id sender){
                                                                      [weakSelf studyClicked:epv];
                                                                  }
                                    ];
    
    CCMenu* studyMenu = [CCMenu menuWithItems:studyButton, nil];
    studyMenu.position = ccp(262, 47);
    
    [_mainLayout addChild:_mainFlexBoard z:9];
    
    [_mainLayout addChild:playMenu];
    
    //[self addChild:progressBar];
    //[self addChild:progressNob];
    [_mainLayout addChild:studyMenu];
}

//Make is more readable
- (void) playClicked:(id)sender
{
    EZPlayPagePodLearn* weakSelf = self;
    [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
    CCMenuItemImage* imageItem = sender;
    EZDEBUG(@"play clicked, play status:%i", weakSelf.playButtonStatus);
    
    if(!weakSelf.player.isPlaying){
        [MobClick event:@"play_button_clicked" label:nil];
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
        [MobClick event:@"pause_button_clicked" label:nil];
        [weakSelf.player pause];
        weakSelf.playButtonStatus = kPlayerPause;
        [imageItem setNormalSpriteFrame:weakSelf.playImg.displayFrame];
    }
    
}

- (void) studyClicked:(EZEpisodeVO*)epv
{
    EZPlayPagePodLearn* weakSelf = self;
    [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
    [MobClick event:@"study_button_clicked" label:nil];
    [weakSelf.player pause];
    [_playButton setNormalSpriteFrame:weakSelf.playImg.displayFrame];
    
    //More straightforward.
    if(!weakSelf.studyBoardHolder){
        [weakSelf initStudyBoard2:epv];
    }else{
        weakSelf.flexibleBoard.touchEnabled = YES;
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
        id scaleComplete = [CCCallBlock actionWithBlock:^(){
            if(weakSelf.flexibleBoard.chessBoard.allSteps.count > 0){
                [weakSelf.flexibleBoard recalculateBoardRegion];
            }else{
                [weakSelf.flexibleBoard calculateRegionForPattern:epv.basicPattern isPlant:false];
            }
        }];
        //id moveTo = [CCMoveTo actionWithDuration:0.3f position:ccp(0, 0)];
        [weakSelf.studyBoardHolder runAction:[CCSequence actions:scaleDown, scaleComplete, nil]];
    }];
    id sequence = [CCSequence actions:animation, completed, nil];
    [weakSelf.mainLayout runAction:sequence];
    
    [weakSelf.chessBoard2 cleanAll];
    [weakSelf.player2 forwardFrom:0 to:weakSelf.player.currentAction];
    
    
    [weakSelf setupStudyBoard:epv];
    [weakSelf.flexibleBoard backToRollStatus];
    [weakSelf.mainFlexBoard backToRollStatus];
    //Make sure the inner board and outboard color is consistent.
    //It is all because initially, I didn't get all the
    //BoardFront interface well define.
    //Otherwise it could be much simpler to add functionality like this.
    EZDEBUG(@"Raise study panel successfully");
}

- (void) setupStudyBoard:(EZEpisodeVO*)  epv
{
    EZPlayPagePodLearn* weakSelf = self;
    //mean
    //This is still not very precise,
    //Even no check at all will give a 50% correct rate.
    //Which boost my confidence.
    if(weakSelf.player.currentAction <= 1 ){
        //Only handle 2 simplst cases
        if([epv.introduction hasPrefix:@"黑先"] != weakSelf.chessBoard2.isCurrentBlack){
            [weakSelf.chessBoard2 toggleColor];
        }
    }else{
        [weakSelf.chessBoard2 syncChessColorWithLastMove];
    }
    EZDEBUG(@"epv.introduction:%@, currentColor:%@", epv.introduction, weakSelf.chessBoard2.isCurrentBlack?@"Black":@"White");
    
    if(weakSelf.chessBoard2.isCurrentBlack){
        weakSelf.currentFinger = weakSelf.blackFinger;
    }else{
        weakSelf.currentFinger = weakSelf.whiteFinger;
    }
    
    
    //Hope it harmless to remove twice.
    [weakSelf.currentFinger stopAllActions];
    [weakSelf.currentFinger removeFromParentAndCleanup:NO];
    weakSelf.currentFinger.visible = true;
    [weakSelf.studyBoardHolder addChild:weakSelf.currentFinger z:FingerZOrder];
    
    [weakSelf.currentFinger runAction:weakSelf.fingerAnim];
    //We will recalculate the board visible region.
}
//Will be called by the commonPage when swipe get called
//I am make sure the epv is a valid one
- (void) swipeTo:(EZEpisodeVO*)epv currentPos:(NSInteger)currentPos isNext:(BOOL)isNext
{
    [MobClick event:@"swiped" label:[NSString stringWithFormat:@"position:%i,next:%@",currentPos, isNext?@"true":@"false"]];
    EZPlayPagePodLearn* nextPage = [[EZPlayPagePodLearn alloc] initWithEpisode:epv currentPos:currentPos];
    if(isNext){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[nextPage createScene]]];
    }else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5 scene:[nextPage createScene]]];
    }
}

- (void) dealloc
{
    EZDEBUG(@"EZPlayPageNode Released");
}


@end

