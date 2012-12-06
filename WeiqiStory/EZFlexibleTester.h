//
//  EZFlexibleTester.h
//  WeiqiStory
//
//  Created by xietian on 12-12-6.
//
//

#import "EZClippingNode.h"




#import "cocos2d.h"
#import "EZClippingNode.h"


#define  MaximumScale 2.5


@class EZChessBoard;
//What do I mean by flexible board.
//1. First iteration The Board will try to demostrate the largest area could be displayed initially.
//2. It allow users to pinch and pan,but have the limit for enlarge.
//For example, the largest zoom in is 2.5, the smallest zoom out is to fit the frame of the Flexible Board.
typedef enum{
    kTouchStart,
    kSingleTouch,
    kBoardMoving
} TouchState;


@interface EZFlexibleTester : EZClippingNode<CCStandardTouchDelegate, UIGestureRecognizerDelegate>

//What's the purpose of the rectangular?
//Is this only touch region or what?
//Or it is touch region
- (id) initWithBoard:(NSString*)orgBoardName boardTouchRect:(CGRect)boardTouchRegion visibleSize:(CGSize)size;


//Client don't need to care about the possiblity
//The method will figure out a feasible scale value for it.
- (void) scaleBoardTo:(CGFloat)scale;

- (void) zoomIn;

- (void) zoomOut;

@property (nonatomic, strong) NSArray* basicPatterns;

@property (nonatomic, strong) CCSprite* chessBoard;

@property (nonatomic, assign) CGFloat zoomScale;

//Visiable region.
@property (nonatomic, assign) CGSize visableSize;

//This will be combine the position with the visableSize
@property (nonatomic, assign) CGRect touchRegion;

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



@end
