//
//  EZBoardSnapshot.h
//  WeiqiStory
//
//  Created by xietian on 12-12-25.
//
//

#import <Foundation/Foundation.h>

//What's the purpose of this class?
//Will keep the status of the chessboard
//So it can be used to recover the board.
@interface EZBoardSnapshot : NSObject

@property (nonatomic, strong) NSArray* coords;
@property (nonatomic, strong) NSArray* marks;

//What about other things, like what's the number start?
//Should I display number or not?
//Cool, let's add them.
@property (nonatomic, assign) BOOL showStep;

//Then I will know when the steps will get show off.
@property (nonatomic, assign) NSInteger showStepStarted;

@end
