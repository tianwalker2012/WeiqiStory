//
//  EZBoardPanel.h
//  WeiqiStory
//
//  Created by xietian on 12-10-30.
//
//

#import "EZImageView.h"
#import "EZConstants.h"

@class EZEpisodeVO;
//What's my expectation for this class
//You just pass in the coord, I will turn the coord into the small board.
//And I will handle the touch event and other things here.
@interface EZBoardPanel : EZImageView

- (id) initWithEpisode:(EZEpisodeVO*)vo;

- (void) updateWithEpisode:(EZEpisodeVO*)vo;

@property (nonatomic, strong) UILabel* name;
@property (nonatomic, strong) UILabel* intro;
@property (nonatomic, strong) EZOperationBlock tappedBlock;
@property (nonatomic, strong) EZImage* chessPattern;

@end
