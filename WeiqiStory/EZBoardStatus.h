//
//  EZBoardStatus.h
//  FirstCocos2d
//
//  Created by Apple on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//I can put all the illegal ButtonPutStatus here
typedef enum ChessPutStatus{
    EZPutOk = 0,//OK no issue
    EZLackQi = 1,//No qi
    EZJustRobber = 2, //Just get robbered, you can't get your staff back
    EZOccupied = 3 // Occupied by other guy.
} ChessPutStatus;


@class EZCoord;
@class EZChessPosition;
//Why I create this?
//What's the purpose.
//EZBoardStatus will not know about the EZBoard.
//It only know the EZBoardFront.
//This is like the window,
//Decouple this will make the test easier
//Code more clean.
@protocol EZBoardFront <NSObject>

//Clean all the button on the board, animated or not.
- (void) cleanAllButton:(BOOL)animated;

//Coord is better and more stable than point
- (void) clean:(EZCoord*)coord animated:(BOOL)animated;

- (void) putButton:(EZCoord*)coord isBlack:(BOOL)isBlack animated:(BOOL)animated;

//Why need this method?
//Because, I need the deleted button to show the correct number too.
- (void) recoveredButton:(EZChessPosition*)chessPos animated:(BOOL)animated;

@end

//What's the purpose of this class?
//The checking logic and position conversion logic get processed here. 
//Why decouple the position checking logic with the EZBoard?
//Keey thing simple and stupid.
//Now I assume the responsibility for this class is to check the correct position for the 

@interface EZBoardStatus : NSObject

@property (assign, nonatomic) CGFloat lineGap;

//May have board which support fewer lines
@property (assign, nonatomic) NSInteger totalLines;

@property (assign, nonatomic) CGRect bounds;

//What's the current steps
@property (assign, nonatomic) NSInteger steps;

//Why do we need this?
//The screen draw accomplished by this guy
@property (strong, nonatomic) id<EZBoardFront> front;

//If the first mover is Black.
//By default it is black.
//Otherwise change it accordingly
@property (assign, nonatomic) BOOL initialBlack;

//what's the logic for the robbery?
//If the cascade remove only remove one button, then that button will be recorded as robbery position.
//The Robbery step will also get recorded.Interesting.
@property (strong, nonatomic) EZChessPosition* robberPosition;

//The most recent robbery steps
@property (assign, nonatomic) NSInteger robberyStep;


//Old initialization. Will be replaced with a better and cleaner interface
//More straightforward to understand
- (id) initWithSize:(CGRect)bounds lineGap:(CGFloat)gap totalLines:(NSInteger)totalLines;


- (id) initWithBound:(CGRect)bounds rows:(NSInteger)rows cols:(NSInteger)cols;


- (CGPoint) adjustLocation:(CGPoint)point;

//Turn the point to the coordinate on the board
//Useful, when you want to get transform the point to board coordinate
- (EZCoord*) pointToBC:(CGPoint)pt;


//Doing the opposite with the above method.
- (CGPoint) bcToPoint:(EZCoord*)bd;

//Check if the position are legal to put button or not.
//No internal status will be updated
- (ChessPutStatus) tryPutButton:(EZCoord*)bd isBlack:(BOOL)black;


//Simplify the usage.
- (ChessPutStatus) putButton:(CGPoint)point  animated:(BOOL)animated;

//If successful, will update the steps and change the internal status accordingly.
//The It will call EZBoardFront to plant the button on screen accordingly.
- (ChessPutStatus) putButtonByCoord:(EZCoord*)coord animated:(BOOL)animated;

//Used to check if the current button is black
//It is mean next button is black or not
- (BOOL) isCurrentBlack;


//Honestly, I get lost just now. 
//Let me find my sense back. 
//1. Who is the caller?
//2. What's the expectation of the caller?
//Currently I have 2 qi detection needs.
//a. I want to put a button on a place, I need to know if I put my button on that place
//Do I still have qi?(If I don't have Qi, then will check for sub cases, if the opponent will be killed?
//b. If I can put the button, I need to check do I get anybody killed
// I need to check all the people around me, see if they still have qi or not.
// (If not will remove them.)
// Consider case1, if I put a button down, what should I do?
// For each button near me, I will ask them to check qi.
// If I am white button, I will check for black qi.
// If it is space return 1, if it is white return 0, if it is black, if will return the the space count + plus the qi of it's neigbour. 
// I would like to return a ArrayList have zero qi, 
// I will detect for black button.
// Good.
// Actually, I have 2 needs one is to get the exact number of QI, one is that stop by finding any QI.
// I guess, I am interested in the later one.
- (NSInteger) detectQi:(EZCoord*)coord isBlack:(BOOL)black;


//Give the available Neighbors for a given point
- (NSArray*) availableNeigbor:(EZCoord*)coord;

//The expectation of the caller is to get out all the button get zero qi
//Due to move of this coord
//Use dictionary to remove duplicated button
//Remove this method, because this is a policy not a mechanism
//Now I have better volcabulary for this.
//Orthagonal.
//- (NSDictionary*) detectKill:(EZCoord*)coord isBlack:(BOOL)black;

//Remove this coord plus all it's connected neighor
//Return the total removed button count
//Will remove black
- (NSInteger) cascadeRemoveEaten:(EZCoord*)coord  isBlack:(BOOL)black animated:(BOOL)animated;


//Initially it is a internal method,
//I just expose it for test purpose.
//Not show it will function normal without disturb internal status.
- (void) removeEaten:(EZCoord*)coord animated:(BOOL)animated;

//What's the purpose of this functionality?
//It will be called after a button is planted.
//It will check if anybody will get removed
//If have will remove them.
//Returned value will be all removed buttons
- (NSInteger) checkAndRemove:(EZCoord*)coord isBlack:(BOOL)black animated:(BOOL)animated;


//What's the purpose of this method.
//Who will call this method?
//Before plant a button, this method will be called
//It will return truth
//If 1. We have availableQi
//Or 2. We can eat opponents
//Don't worry about robbery.
//Robbery check have done before calling this.
//I am imagine just plant this and check if we have Qi.
//Or if we can remove any thing.
//Cool.
//If we remove the side effect checkAndRemove we are perfect.
//If it is the robbery position. Will only return true if can eat more than 1 chessman.
- (BOOL) checkAvailableQi:(EZCoord*)coord isBlack:(BOOL)black isRobbery:(BOOL)robbery;


- (EZChessPosition*) regretOneStep:(BOOL)animated;

//What's the difference between planted and getAllChessMoves?
//Make it clear. 
- (NSArray*) plantedChesses;


- (EZCoord*) coordForStep:(NSInteger)step;

- (NSArray*) getAllChessMoves;

- (void) cleanAllMoves;

@end
