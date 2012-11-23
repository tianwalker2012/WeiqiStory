//
//  EZResizeChessBoard.h
//  WeiqiStory
//
//  Created by xietian on 12-11-20.
//
//

#import "EZChessBoard.h"
#import "EZConstants.h"

//What I will do in this class?
//Add 2 board.
//One is the original, one is the enlarged.
//EveryTime I got touched, I will locate the enlarged board to the proper place.
//I will in charge of sync among the 2 boards.
//So it will show the same things.
//Since all the event controlled by me, so I can do whatever I want.
#define LargerZorder 8
#define OrginalZorder 9

@interface EZResizeChessBoard : CCNode<CCTargetedTouchDelegate>;


- (id) initWithOrgBoard:(NSString*)orgBoardName orgRect:(CGRect)orgRect largeBoard:(NSString*)largeBoardName largeRect:(CGRect)largeRect;

@property (nonatomic, strong) EZChessBoard* orgBoard;
@property (nonatomic, strong) EZChessBoard* enlargedBoard;

//touched block
//Why do we need this property?
//Because, we need to have some animation once the board get touched, it will be cancealled.
@property (nonatomic, strong) EZOperationBlock touchedBlock;


@property (nonatomic, assign) BOOL isLargeBoard;
@property (nonatomic, assign) BOOL touchEnabled;
@property (nonatomic, assign) CGRect touchZone;
@property (nonatomic, assign) CGSize largeSize;
@property (nonatomic, assign) CGSize orgSize;

//Why do I have all this?
//Because, touchEnd always get called whether I accepted the touch or not,
//So I should record that I have accepted the touch. 
@property (nonatomic, assign) BOOL touchAccepted;

@end
