//
//  EZFlexibleBoard.h
//  WeiqiStory
//
//  Created by xietian on 12-12-3.
//
//

#import "cocos2d.h"
#import "EZClippingNode.h"


#define  MaximumZoomOut 2.5;

@class EZChessBoard;
//What do I mean by flexible board.
//1. First iteration The Board will try to demostrate the largest area could be displayed initially.
//2. It allow users to pinch and pan,but have the limit for enlarge.
//For example, the largest zoom in is 2.5, the smallest zoom out is to fit the frame of the Flexible Board.
@interface EZFlexibleBoard : EZClippingNode<CCStandardTouchDelegate, UIGestureRecognizerDelegate>
//What's the purpose of the rectangular?
//Is this only touch region or what?
//Or it is touch region
- (id) initWithBoard:(NSString*)orgBoardName boardTouchRect:(CGRect)boardTouchRegion visibleSize:(CGSize)size;

@property (nonatomic, strong) EZChessBoard* chessBoard;

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

@property (nonatomic, assign) BOOL movingState;

//What's the purpose of this?
//It is for the moving, right?
@property (nonatomic, strong) UITouch* movingTouch;

@property (nonatomic, strong) CCSprite* movingCursor;

@end
