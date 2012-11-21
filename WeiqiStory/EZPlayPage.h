//
//  EZPlayPage.h
//  WeiqiStory
//
//  Created by xietian on 12-10-30.
//
//

#import "cocos2d.h"
#import "EZLayer.h"

@class EZEpisodeVO;
@interface EZPlayPage : EZLayer

+ (CCScene*) scene;

- (CCScene*) createScene;

@property (nonatomic, strong) EZEpisodeVO* episode;

- (id) initWithEpisode:(EZEpisodeVO*)epv;

@end
