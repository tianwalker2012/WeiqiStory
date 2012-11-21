//
//  EZPlayPage-pod4.h
//  WeiqiStory
//
//  Created by xietian on 12-11-20.
//
//

#import "cocos2d.h"
#import "EZLayer.h"

@class EZEpisodeVO;
@interface EZPlayPagePod : EZLayer

+ (CCScene*) scene;

- (CCScene*) createScene;

@property (nonatomic, strong) EZEpisodeVO* episode;

- (id) initWithEpisode:(EZEpisodeVO*)epv;


@end
