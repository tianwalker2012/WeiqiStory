//
//  EZEditPage.h
//  WeiqiStory
//
//  Created by xietian on 12-11-13.
//
//

#import "cocos2d.h"
#import "EZConstants.h"

@class EZEpisodeVO;
@interface EZEditPage : CCLayer<UITextFieldDelegate>


+ (CCScene*) scene;

- (CCScene*) createScene;

- (id) initWithEpisode:(EZEpisodeVO*)epv;

@property (nonatomic, strong) EZEpisodeVO* episode;

//If the episode get editted or deleted
@property (nonatomic, strong) EZOperationBlock deletedEpisode;

@property (nonatomic, strong) EZOperationBlock savedEpisode;




@end
