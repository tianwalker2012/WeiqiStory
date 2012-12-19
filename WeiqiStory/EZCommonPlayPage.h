//
//  EZCommonPlay.h
//  WeiqiStory
//
//  Created by xietian on 12-12-3.
//
//

#import "CCLayer.h"
#import "EZLayer.h"

@class EZEpisodeVO;
@class EZActionPlayer;
@class EZTouchView;

#define SwipeCountLimit 3

//Great design, I would like the animation also implemented here.
//Let's enjoy doing this.
@interface EZCommonPlayPage : EZLayer

@property(nonatomic, strong) UIView* gesturerView;

@property(nonatomic, strong) EZTouchView* purchaseView;

//So that user could go back and forth.
//How to disable the button?
//This about it.
@property(nonatomic, assign) NSInteger currentEpisodePos;

@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;

@property(nonatomic, strong) EZActionPlayer* player;


@property (nonatomic, strong) CCNode* swipeNode;

@property (nonatomic, strong) CCSprite* finger;

@property (nonatomic, strong) id swipeAnim;

@property (nonatomic, strong) id fadeOutAnim;
//The sub class will implement this.
//Otherwise, because i don't know which class this will instantiated
//isNext mean, we are from left to right, or from left to right.
- (void) swipeTo:(EZEpisodeVO*)epv currentPos:(NSInteger)currentPos isNext:(BOOL)isNext;

//Get current episode
- (EZEpisodeVO*) getEpisode:(NSInteger)curPos;

//Add the swipe sign and animation to remind user that we are swipable.
//Only do it 3 times is enough.
//Cool. 
- (void) createSwipeSign;


- (id) initWithPos:(NSInteger)currentEpisode;
//The puprose of this is that
//I need to extract the common shared service between PodPage and PadPage
//So that keep my code DRY.
- (void) createSwipeGesture;

@end
