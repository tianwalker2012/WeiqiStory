//
//  EZChessBoard.h
//  FirstCocos2d
//
//  Created by xietian on 12-9-19.
//
//

#import "cocos2d.h"

#import "EZBoardStatus.h"
//There is a bad smell, I don't the cyclic way of header reference.
//Let's refractor it later.
//Now Let's keep it as it is. 
#import "EZActionPlayer.h"

#import "EZCoord.h"
#import "EZBoardSnapshot.h"


#define  OverExistingChess 30

#define  ExistingChess 10

//What's the purpose of this Zorder?
//The mark on the Chess board, make sure it is covering the chessman.
#define  MarkZOrder 11

//What's the purpose of this?
//It is use by the board to differentiate whether we are planting chess or we are planting marks
//Should we add to this?
//Not appropriate way.
//Why?
//Messup with the functionality.
typedef enum {
    kChessMan = 1,
    kChessMark
} EZChessmanType;


//What the purpose of this class?
//It will act as a chess board on the screen.
//It will turn user's touch on this board into
//Black or White on to the board.
//I will implement this on a step wise way.
//What the outside world will use it?
//It can be initialized by column and row.
//And what's the rectangular for the board.
//It will only accept the touch event on this retangular.
@class  EZChessMark;

@interface EZChessBoard : CCSprite<CCTargetedTouchDelegate, EZBoardFront, EZBoardDelegate>


//Let's see if we can fix this.
@property (nonatomic, strong) CCSprite* boardBackground;

//Only touch fall into this region will be sensed and processed.
@property (assign, nonatomic) CGRect touchRect;

//Cols and rows of this board
@property (assign, nonatomic) NSInteger cols;

@property (assign, nonatomic) NSInteger rows;

//Used to specify the markCharSize,if zero mean I will go with my default setting.
@property (assign, nonatomic) NSInteger markCharSize;

@property (assign, nonatomic) BOOL touchEnabled;

@property (assign, nonatomic) BOOL showStep;

@property (assign, nonatomic) EZChessmanType chessmanType;

@property (assign, nonatomic) EZChessmanSetType chessmanSetType;

@property (assign, nonatomic) NSInteger chessMarkCount;

//@property (assign, nonatomic) EZChessmanType chessmanType;

//Only show the number started from this number.
//What's the logic now
//If this number is set will show the number from this one
//The showStep should be true.
//Think about it now.
//I will not grantee this will be recoverable.
@property (assign, nonatomic) NSInteger showStepStarted;

@property (strong, nonatomic) NSMutableArray* allMarks;

@property (strong, nonatomic) NSMutableArray* regrets;

//Sometimes we need customized chessman
@property (strong, nonatomic) NSString* whiteChessName;

@property (strong, nonatomic) NSString* blackChessName;

//To indicate whether our board is a large board or not.
//What did this affect us?
//This will affect which chessman size we will use?
//Which mark size we will use?
//Let get things up and run as fast as possible, then refractor it later, is this solution ok with you?
//Cool, I am cool with it.
@property (assign, nonatomic) BOOL isLargeBoard;
@property (strong, nonatomic) NSString* triangularMarkName;

//Why do we need this?
//So we can estimate how big the mark should be.
@property (assign, nonatomic) CGSize estimatedChessmanSize;

//Why do I add this?
//I want to make the cursor be above the frame.
//The simplst way to do this is to make the frame a part of the board.
//This will make my Board shink and resize very unconvinient.
//So I take a new conception called cursorHolder, which mean my cursor will be hold by this guy.
//Ok, let's do this.
@property (strong, nonatomic) CCNode* cursorHolder;

//The touch Rect determined what's the region for chess board.
- (id)initWithFile:(NSString*)filename touchRect:(CGRect)rect rows:(NSInteger)rows cols:(NSInteger)cols;



- (void) putChessman:(EZCoord*)coord animated:(BOOL)animated;

- (void) putMarks:(NSArray*) marks;

- (void) putMark:(EZChessMark*) mark animate:(id)anim;

- (void) putChessmans:(NSArray*)coords animated:(BOOL)animated;

//How many steps I will regret.
- (void) regretSteps:(NSInteger)steps  animated:(BOOL)animated;

- (void) redoRegret:(BOOL)animated;

//Will get all the steps ever put on this board
- (NSArray*) allSteps;

- (EZCoord*) coordForStep:(NSInteger)step;

- (void) toggleColor;

//For study mood to show the right color.
- (void) syncChessColorWithLastMove;


//Following method is related to recover and store the current board status
@property (nonatomic, strong) NSMutableArray* snapshotStack;

//Push current status to the stack, which can be recovered later.
- (void) pushStatus;

//Pop the current status from the stack so that the stored status could be recovered.
- (void) popStatus;

//What's the meaning of this?
//Just pop the status out of the field
//
- (void) popStatusWithoutApplying;

//Get the snapshot of the board
- (EZBoardSnapshot*) getSnapshot;

//This is a total operation. mean the whole status will get recovered.
- (void) playSnapshot:(EZBoardSnapshot*)snapshot;
//My worry is that the snapshot recover operation is a very costly operation, how to make it little more efficient.
//First I need to identifiy where is the bottleneck of the performance.
//Once I idenitify performance bottle I could solve it.


@end
