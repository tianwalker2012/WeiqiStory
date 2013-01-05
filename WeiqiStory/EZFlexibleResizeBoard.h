//
//  EZFlexibleResizeBoard.h
//  WeiqiStory
//
//  Created by xietian on 12-12-12.
//
//

#import "cocos2d.h"
#import "EZClippingNode.h"
#import "EZConstants.h"


#define  MaximumScale 2.5

@class EZTitleImage;
@class EZChessBoard;
//What do I mean by flexible board.
//1. First iteration The Board will try to demostrate the largest area could be displayed initially.
//2. It allow users to pinch and pan,but have the limit for enlarge.
//For example, the largest zoom in is 2.5, the smallest zoom out is to fit the frame of the Flexible Board.

@interface EZFlexibleResizeBoard : EZClippingNode<CCStandardTouchDelegate, UIGestureRecognizerDelegate>
//What's the purpose of the rectangular?
//Is this only touch region or what?
//Or it is touch region
- (id) initWithBoard:(NSString*)orgBoardName boardTouchRect:(CGRect)boardTouchRegion visibleSize:(CGSize)size;

//Will back to status of roll, so that have no trail effects.
- (void) backToRollStatus;

//Client don't need to care about the possiblity
//The method will figure out a feasible scale value for it.
- (void) scaleBoardTo:(CGFloat)scale;


//Some times, I just want to calculate the region without really plant it.
//Like my recalculation jobs.
- (void) calculateRegionForPattern:(NSArray*)pattern isPlant:(BOOL)plant;

//What's the purpose of this method?
//Since the board not strictly controlled by the EZFlexibleBoard, so I need to calculate the visible part based on what already planed by
//The player.
- (void) recalculateBoardRegion;

- (void) zoomIn;

- (void) zoomOut;

@property (nonatomic, strong) NSArray* basicPatterns;

@property (nonatomic, strong) EZChessBoard* chessBoard;

//Simplify the cases to illustrate the issue.
@property (nonatomic, strong) EZTitleImage* simpleBoard;

@property (nonatomic, assign) CGFloat zoomScale;

//Visiable region.
@property (nonatomic, assign) CGSize visableSize;

//This will be combine the position with the visableSize
@property (nonatomic, assign) CGRect touchRegion;

//What's the purpose of this region?
//When the touch out of this region
//And when the touch in the out region
//I will move according to the 
@property (nonatomic, assign) CGRect moveInnerRegion;

//
@property (nonatomic, assign) CGRect moveOutterRegion;

//Why do I have all this?
//Because, touchEnd always get called whether I accepted the touch or not,
//So I should record that I have accepted the touch.
@property (nonatomic, assign) BOOL touchAccepted;

@property (nonatomic, assign) CGFloat orgScale;

@property (nonatomic, strong) UIView* gestureView;

@property (nonatomic, strong) UIPinchGestureRecognizer* pinchRecognizer;

@property (nonatomic, strong) UIPanGestureRecognizer* panRecognizer;

@property (nonatomic, assign) BOOL pinchOngoing;

@property (nonatomic, assign) BOOL isFirstPan;

@property (nonatomic, assign) CGPoint prevPanPoint;

@property (nonatomic, assign) BOOL multiTouchAccepted;

@property (nonatomic, strong) NSMutableSet* allTouches;

//@property (nonatomic, assign) BOOL movingState;

//What's the purpose of this?
//It is for the moving, right?
//@property (nonatomic, strong) UITouch* movingTouch;

@property (nonatomic, strong) CCSprite* movingCursor;
@property (nonatomic, strong) UITouch* currMovingTouch;

//This is a state machine, I will use state machine to manage things
@property (nonatomic, assign) NSInteger touchState;

@property (nonatomic, strong) EZOperationBlock touchBlock;

//Why 2 point, the initial Point is to calculate should I intepret the move as plant Move or board move
@property (nonatomic, assign) CGPoint initialPoint;

//This point is how much I shold intpret this event.
@property (nonatomic, assign) CGPoint prevPoint;

//@property (nonatomic, assign) CGFloat prevScale;

//I invent this for the purpose of multiple double click will mess up the scale, so the board will
//not come back to it's state. So I will update the lastCalculatedScale after each update visible region.
@property (nonatomic, assign) CGFloat lastCalculatedScale;

@property (nonatomic, assign) BOOL touchEnabled;


@end
