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

@interface EZCommonPlayPage : EZLayer

@property(nonatomic, strong) UIView* gesturerView;

//So that user could go back and forth.
//How to disable the button?
//This about it.
@property(nonatomic, assign) NSInteger currentEpisodePos;


@property(nonatomic, strong) EZActionPlayer* player;
//The sub class will implement this.
//Otherwise, because i don't know which class this will instantiated
//isNext mean, we are from left to right, or from left to right.
- (void) swipeTo:(EZEpisodeVO*)epv currentPos:(NSInteger)currentPos isNext:(BOOL)isNext;

//Get current episode
- (EZEpisodeVO*) getEpisode:(NSInteger)curPos;

//The puprose of this is that
//I need to extract the common shared service between PodPage and PadPage
//So that keep my code DRY.
- (void) createSwipeGesture;

@end