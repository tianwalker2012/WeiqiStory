//
//  EZCommonPlay.m
//  WeiqiStory
//
//  Created by xietian on 12-12-3.
//
//

#import "cocos2d.h"
#import "EZCommonPlayPage.h"
#import "EZCoreAccessor.h"
#import "EZEpisode.h"
#import "EZEpisodeVO.h"
#import "EZAppPurchase.h"
#import "EZTouchView.h"
#import "EZFileUtil.h"
#import "EZActionPlayer.h"

@implementation EZCommonPlayPage


- (void) onEnter
{
    [super onEnter];
    //[[CCDirector sharedDirector].view addSubview:_gesturerView];
    [self createSwipeSign];
}

- (void) onExit
{
    [super onExit];
    [_gesturerView removeFromSuperview];
    [_purchaseView removeFromSuperview];
    //[_swipeNode removeFromParentAndCleanup:NO];
}


- (id) init
{
    self = [super init];
    [self createSwipeGesture];
    return self;
}


- (id) initWithPos:(NSInteger)currentEpisode
{
    self = [super init];
    [self createSwipeGesture];
    
    if(currentEpisode >= PurchaseBegin && ![[EZAppPurchase getInstance] isPurchased:ProductID]){
        [self addPurchaseLayer];
    }
    
    return self;
}


//The purpose of this method is to stop the animating cycle, make user not very annoying
- (void) dismissAnimating:(ccTime)time
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
}

- (void) addPurchaseLayer
{
    CGSize winSize = [[CCDirector sharedDirector].view bounds].size;
    EZDEBUG(@"The winSize is:%@", NSStringFromCGSize(winSize));
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _purchaseView = [[EZTouchView alloc] initWithFrame:CGRectMake(0, 130, 768, winSize.height - 130)];
    }else {
        
        if([[CCFileUtils sharedFileUtils] runningDevice] == kCCiPhone5){
            _purchaseView = [[EZTouchView alloc] initWithFrame:CGRectMake(0, 87, 320, winSize.height - 87)];
        }else{
            _purchaseView = [[EZTouchView alloc] initWithFrame:CGRectMake(0, 80, 320, winSize.height - 80)];
        }
    }
    
    __weak EZCommonPlayPage* weakSelf = self;
    _purchaseView.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.5];
    _purchaseView.userInteractionEnabled = true;
    
    CGSize screenSize = [CCDirector sharedDirector].view.bounds.size;
    UIImageView* lock = [[UIImageView alloc]initWithImage:[EZFileUtil imageFromFile:@"lock.png" scale:[UIScreen mainScreen].scale]];
    lock.center = ccp(screenSize.width/2, screenSize.height/2);
    [_purchaseView addSubview:lock];
    
    
 
    _purchaseView.touchBlock = ^(){
        EZDEBUG(@"TouchedView");
        CGSize screenSize = [CCDirector sharedDirector].view.bounds.size;
        weakSelf.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [weakSelf.activityIndicator setFrame:[CCDirector sharedDirector].view.bounds];
        weakSelf.activityIndicator.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        weakSelf.activityIndicator.center = ccp(screenSize.width/2, screenSize.height/2);
        [[CCDirector sharedDirector].view addSubview:weakSelf.activityIndicator];
        [weakSelf.activityIndicator startAnimating];
        
        [weakSelf schedule:@selector(dismissAnimating:) interval:1.0 repeat:0 delay:3];
        [[EZAppPurchase getInstance] purchase:ProductID successBlock:^(id tr){
            [[EZAppPurchase getInstance] setPurchased:TRUE pid:ProductID];
            [weakSelf.activityIndicator stopAnimating];
            [weakSelf.activityIndicator removeFromSuperview];
            [weakSelf.purchaseView removeFromSuperview];
        } failedBlock:^(id tr){
            EZDEBUG(@"Failed to purchase");
            [weakSelf.activityIndicator stopAnimating];
            [weakSelf.activityIndicator removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"purchaseFailureTitle", @"QueryInfo", @"")
                                                            message:NSLocalizedStringFromTable(@"purchaseFailureContent", @"QueryInfo", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];

    };

    [[CCDirector sharedDirector].view addSubview:_purchaseView];
    
}

//Add the swipe sign and animation to remind user that we are swipable.
//Only do it 3 times is enough.
//Cool.
- (void) createSwipeSign
{
    NSInteger swipeCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"swipeCount"];
    if(swipeCount >= SwipeCountLimit ){
        EZDEBUG(@"Quit for already demoed %i times", swipeCount);
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:swipeCount+1 forKey:@"swipeCount"];
    
    if(!_swipeNode){
        //_swipeNode = [[CCNode alloc] init];
        //_swipeNode.contentSize = CGSizeMake(276, 116);
        _swipeNode = [CCSprite spriteWithFile:@"swipe-sign.png"];
        _finger = [CCSprite spriteWithFile:@"swipe-finger.png"];
        //CCSprite* swipe = [CCSprite spriteWithFile:@"swipe-sign.png"];
        //swipe.anchorPoint = ccp(0, 0);
        //On the upper side of the swipeNode;
        //swipe.position = ccp(0, _swipeNode.contentSize.height - swipe.contentSize.height + 10);
        //[_swipeNode addChild:swipe];
        _finger.anchorPoint = ccp(1.0, 1.0);
        CGFloat startX = _swipeNode.contentSize.width/6;
        CGFloat endX = _swipeNode.contentSize.width*5/6+_finger.contentSize.width;
        _finger.position = ccp(startX, _swipeNode.contentSize.height/2);
        [_swipeNode addChild:_finger];
        //_swipeNode.anchorPoint = ccp(0.5, 0.5);
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            _swipeNode.position = ccp(384, 512);
        }else {
            _swipeNode.position = ccp(320/2, 244);
        }
        
        CGFloat fingerY = _finger.position.y;
        //CGPoint pos = swipe.position;
        __weak EZCommonPlayPage* weakSelf = self;
        _swipeAnim = [CCSpawn actions:[CCRepeat actionWithAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.0 position:ccp(endX, fingerY)], [CCMoveTo actionWithDuration:1.0 position:ccp(startX, fingerY)], nil] times:2.0],[CCFadeOut actionWithDuration:2.0],nil];
        
        _fadeOutAnim = [CCSequence actions:[CCFadeOut actionWithDuration:2.0],[CCCallBlock actionWithBlock:^(){
            [weakSelf.swipeNode removeFromParentAndCleanup:NO];
        }], nil];
    }
    [_swipeNode removeFromParentAndCleanup:NO];
    
    //Make sure this is on the top of the convas.
    EZDEBUG(@"Will run swipe animation");
    [self addChild:_swipeNode z:100];
    [_finger runAction:_swipeAnim];
    [_swipeNode runAction:_fadeOutAnim];

}

- (void) createSwipeGesture
{
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _gesturerView = [[UIView alloc] initWithFrame:CGRectMake(0, 138, 768, 748)];
    }else {
        
        if([[CCFileUtils sharedFileUtils] runningDevice] == kCCiPhone5){
            _gesturerView = [[UIView alloc] initWithFrame:CGRectMake(0, 87, 320, 408)];
        }else{
            _gesturerView = [[UIView alloc] initWithFrame:CGRectMake(0, 87, 320, 320)];
        }
    }
    //UIView* anotherView = [[UIView alloc] initWithFrame:CGRectMake(0, 138, 768, 748)];
    
    UISwipeGestureRecognizer* recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer* recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    //_gesturerView.backgroundColor = [UIColor colorWithRed:0.2 green:0.1 blue:0.1 alpha:0.5];
    _gesturerView.backgroundColor = [UIColor clearColor];
    [_gesturerView addGestureRecognizer:recognizerRight];
    [_gesturerView addGestureRecognizer:recognizerLeft];
    [[CCDirector sharedDirector].view addSubview:_gesturerView];
}


//Let's do it in an iterative way.
//I really enjoy iterative way of doing things.
//It make you can see each step of your achievements.
- (void) swiped:(id) sender
{
    
    [[NSUserDefaults standardUserDefaults] setInteger:SwipeCountLimit forKey:@"swipeCount"];
    UISwipeGestureRecognizer* swiper = sender;
    
    NSInteger nextPos = _currentEpisodePos + 1;
    NSInteger prevPos = _currentEpisodePos - 1;
    
    EZEpisodeVO* epv = nil;
    NSInteger  currentPos = 0;
    if(swiper.direction == UISwipeGestureRecognizerDirectionLeft){
        epv = [self getEpisode:nextPos];
        currentPos = nextPos;
    }else{
        epv = [self getEpisode:prevPos];
        currentPos = prevPos;
    }
    EZDEBUG(@"Swipe right get called, direction:%i, nextPos:%i, prevPos:%i", swiper.direction, nextPos, prevPos);
    [self.player pause];
    
    if(epv == nil){
        return;
    }
    //EZPlayPage* nextPage = [[EZPlayPage alloc] initWithEpisode:epv currentPos:currentPos];
    //nextPage.currentEpisodePos = weakSelf.currentEpisodePos + 1;
    
    if(swiper.direction == UISwipeGestureRecognizerDirectionLeft){
        //[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5 scene:[nextPage createScene]]];
        [self swipeTo:epv currentPos:currentPos isNext:YES];
    }else{
        [self swipeTo:epv currentPos:currentPos isNext:NO];
    }
    
}


- (void) swipeTo:(EZEpisodeVO*)epv currentPos:(NSInteger)currentPos isNext:(BOOL)isNext
{
    EZDEBUG(@"Should override me");
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


@end
