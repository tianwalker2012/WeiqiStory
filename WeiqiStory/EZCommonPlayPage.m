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


@implementation EZCommonPlayPage


- (void) onEnter
{
    [super onEnter];
    [[CCDirector sharedDirector].view addSubview:_gesturerView];
}

- (void) onExit
{
    [super onExit];
    [_gesturerView removeFromSuperview];
}


- (id) init
{
    self = [super init];
    [self createSwipeGesture];
    
    return self;
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
    _gesturerView.backgroundColor = [UIColor colorWithRed:0.2 green:0.1 blue:0.1 alpha:0.5];
    [_gesturerView addGestureRecognizer:recognizerRight];
    [_gesturerView addGestureRecognizer:recognizerLeft];
    //[[CCDirector sharedDirector].view addSubview:_gesturerView];
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
