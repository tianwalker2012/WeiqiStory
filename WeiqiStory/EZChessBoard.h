//
//  EZChessBoard.h
//  FirstCocos2d
//
//  Created by xietian on 12-9-19.
//
//

#import "cocos2d.h"

#import "EZBoardStatus.h"


#define  OverExistingChess 15

#define  ExistingChess 10



//What the purpose of this class?
//It will act as a chess board on the screen.
//It will turn user's touch on this board into
//Black or White on to the board.
//I will implement this on a step wise way.
//What the outside world will use it?
//It can be initialized by column and row.
//And what's the rectangular for the board.
//It will only accept the touch event on this retangular.
@interface EZChessBoard : CCSprite<CCTargetedTouchDelegate, EZBoardFront>

//Only touch fall into this region will be sensed and processed.
@property (assign, nonatomic) CGRect touchRect;

//Cols and rows of this board
@property (assign, nonatomic) NSInteger cols;

@property (assign, nonatomic) NSInteger rows;

@property (assign, nonatomic) BOOL touchEnabled;

@property (assign, nonatomic) BOOL showStep;

//Only show the number started from this number.
//What's the logic now
//If this number is set will show the number from this one
//The showStep should be true.
//Think about it now.
//I will not grantee this will be recoverable.
@property (assign, nonatomic) NSInteger showStepStarted;

//The touch Rect determined what's the region for chess board.
- (id)initWithFile:(NSString*)filename touchRect:(CGRect)rect rows:(NSInteger)rows cols:(NSInteger)cols;



- (void) putChessman:(EZCoord*)coord animated:(BOOL)animated;


- (void) putChessmans:(NSArray*)coords animated:(BOOL)animated;

//How many steps I will regret.
- (void) regretSteps:(NSInteger)steps  animated:(BOOL)animated;

@end
