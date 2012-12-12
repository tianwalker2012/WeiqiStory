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

@implementation EZCommonPlayPage


- (void) onEnter
{
    [super onEnter];
    //[[CCDirector sharedDirector].view addSubview:_gesturerView];
}

- (void) onExit
{
    [super onExit];
    [_gesturerView removeFromSuperview];
    [_purchaseView removeFromSuperview];
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
