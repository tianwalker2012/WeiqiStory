//
//  EZPlayPagePodLearn.h
//  WeiqiStory
//
//  Created by xietian on 12-12-13.
//
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "EZLayer.h"
#import "EZCommonPlayPage.h"
#import "EZActionPlayer.h"


@class EZChessBoard;
@class EZEpisodeVO;
@class EZResizeChessBoard;
@class EZActionPlayer;
@class EZFlexibleResizeBoard;
@class EZBackground;

#define MaxCommentHeight 160

#define MinCommentHeight 90

@interface EZPlayPagePodLearn : EZCommonPlayPage<EZCommentShower>

+ (CCScene*) scene;

- (CCScene*) createScene;

@property (nonatomic, strong) EZEpisodeVO* episode;

@property (nonatomic, strong) CCSprite* currentFinger;

- (id) initWithEpisode:(EZEpisodeVO*)epv currentPos:(NSInteger)pos;


@property(nonatomic, strong) EZChessBoard* chessBoard;

@property(nonatomic, strong) EZChessBoard* chessBoard2;

//Why do we need this?
//Why need this board to make our ChessBoard could getting larger when user touch the screen.
//@property(nonatomic, strong) EZResizeChessBoard* resizeBoard;

@property (nonatomic, strong) EZFlexibleResizeBoard* flexibleBoard;

@property (nonatomic, strong) EZFlexibleResizeBoard* mainFlexBoard;

@property(nonatomic, strong) EZActionPlayer* player2;

@property(nonatomic, strong) CCSprite* pauseImg;

@property(nonatomic, strong) CCSprite* playImg;

//Now just put it at the rough place, later, I will adjust the layout accordingly
@property(nonatomic, strong) CCLabelTTF* episodeName;
@property(nonatomic, strong) CCLabelTTF* episodeIntro;
@property(nonatomic, strong) CCLabelTTF* infomationRegion;


//The board which will be used for the study purpose
@property(nonatomic, strong) CCNode* studyBoardHolder;
@property(nonatomic, strong) EZChessBoard* studyBoard;
//Used to progress the board to current status
@property(nonatomic, strong) EZActionPlayer* studyPlayer;

@property(nonatomic, strong) CCNode* mainLayout;

@property(nonatomic, strong) CCSprite* bubble;
@property(nonatomic, strong) CCSprite* broken;

@property(nonatomic, strong) CCSprite* blackFinger;
@property(nonatomic, strong) CCSprite* whiteFinger;

@property(nonatomic, strong) CCAction* fingerAnim;
//CCTimer* timer;

@property(nonatomic, assign) BOOL volumePressed;

@property(nonatomic, assign) NSInteger playButtonStatus;

@property (nonatomic, strong) CCMenuItemImage* playButton;

@property (nonatomic, strong) UIWebView* textView;

@property (nonatomic, strong) EZBackground* commentBackground;
//@property (nonatomic, strong) UIImageView* commentBackground;

//Why do I do this?
//I want the comment region to load faster
//The textView width should be the same with the commentbackground are used currently.
//@property (nonatomic, strong) UIImageView* largeCommentBackground;

//@property (nonatomic, strong) UIImageView* smallCommentBackground;

@property (nonatomic, strong) UIButton* revealButton;

@property (nonatomic, assign) BOOL isCommentShowing;


//For test purpose
@property (nonatomic, strong) UIView* stretched;


@end
