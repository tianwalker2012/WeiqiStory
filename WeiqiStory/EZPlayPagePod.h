//
//  EZPlayPage-pod4.h
//  WeiqiStory
//
//  Created by xietian on 12-11-20.
//
//

#import "cocos2d.h"
#import "EZLayer.h"


#define FingerZOrder 40

@class EZChessBoard;
@class EZEpisodeVO;
@class EZResizeChessBoard;
@class EZActionPlayer;

@interface EZPlayPagePod : EZLayer

+ (CCScene*) scene;

- (CCScene*) createScene;

@property (nonatomic, strong) EZEpisodeVO* episode;

@property (nonatomic, strong) CCSprite* currentFinger;

- (id) initWithEpisode:(EZEpisodeVO*)epv currentPos:(NSInteger)pos;


@property(nonatomic, strong) EZChessBoard* chessBoard;

@property(nonatomic, strong) EZChessBoard* chessBoard2;

//Why do we need this?
//Why need this board to make our ChessBoard could getting larger when user touch the screen.
@property(nonatomic, strong) EZResizeChessBoard* resizeBoard;


@property(nonatomic, strong) EZActionPlayer* player;

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

//So that user could go back and forth.
//How to disable the button?
//This about it.
@property(nonatomic, assign) NSInteger currentEpisodePos;

@end
