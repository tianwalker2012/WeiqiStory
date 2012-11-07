//
//  EZRegretAction.h
//  WeiqiStory
//
//  Created by xietian on 12-11-2.
//
//

#import <Foundation/Foundation.h>


//What's the purpose of this class?
//The purpose is to make my board able to regret for your regret.
//Put is simple, once you regret for one move, I will memorize what you have regreted for.
//Like you regret you put a chess on star, and you regret what you have done on star,
//Then you could redo it.
//What's the visual image for this?
//It is a stock.
//Later I may extend this, just as I extend the actions for the players

@class EZChessPosition, EZChessBoard, EZChessMark;
@interface EZRegretAction : NSObject

//Should I provide information about current steps
//Unnecessary in this case.
//Keep it simple and stupid.
//I will only regret on the board.
//Of course, this is for sure. 
- (void) redo:(EZChessBoard*)board animated:(BOOL)animated;

@property (nonatomic, strong) EZChessPosition* position;

@property (nonatomic, strong) NSArray* chessMarks;

@end
