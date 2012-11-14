//
//  EZActionPlayer.h
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"
#import "cocos2d.h"


typedef void (^CallbackBlock) ();

typedef enum {
    kPlaying,
    kPause,
    kStepWisePlaying,
    kEnd
} EZActionPlayerStatus;

//What's the purpose of this Player
//I am like a action playback.
//What do I need is audio service
//and ChessBoard object.
//With this thing I could play music.
//My goal is to make the 3 basic types can be played.
//Let's play them.
//@class EZChessBoard;

@class EZCoord;
@class EZAction;
@protocol EZBoardDelegate <NSObject>

- (void) putChessman:(EZCoord*)coord animated:(BOOL)animated;


- (void) putChessmans:(NSArray*)coords animated:(BOOL)animated;

//How many steps I will regret.
- (void) regretSteps:(NSInteger)steps  animated:(BOOL)animated;

//What's the purpose of this method?
//I will put a specified mark on the board.
- (void) putMark:(CCNode*)mark coord:(EZCoord*)coord animAction:(CCAction*)action;


- (void) putMarks:(NSArray*) marks;

- (void) putCharMark:(NSString*)str fontSize:(NSInteger)fontSize coord:(EZCoord*)coord animAction:(CCAction*)action;

//If the mark exist I wll run the action,
//Of course I will attach a Remove from parent to get it remove from board when it is done.
//I will not clean it up, so It could be reused.
- (void) removeMark:(EZCoord*)coord animAction:(CCAction*)action;

- (void) setShowStepStarted:(NSInteger)step;

- (NSInteger) showStepStarted;

- (BOOL) showStep;

- (void) setShowStep:(BOOL)show;

- (NSArray*) getAllChessMoves;

- (void) cleanAllMoves;

- (void) cleanAllMarks;

//All the marks and moves get cleaned
- (void) cleanAll;

- (BOOL) isCurrentBlack;

- (NSArray*) allSteps;

- (NSArray*) allMarks;

@end


//What's the purpose of this protocol
//Provide a complete callback, so that I could notify the caller that one action completed.
//The UI component could be disabled or enabled accordingly.
//Another option is to pass complete block with it.
@protocol EZActionCompleted <NSObject>

- (void) completed:(NSInteger)completedStep;

- (void) started:(NSInteger)step;

@end


@interface EZActionPlayer : NSObject

- (id) initWithActions:(NSArray*)actions chessBoard:(NSObject<EZBoardDelegate>*)board inMainBundle:(BOOL)mainBundle;

- (void) playFrom:(NSInteger)begin;

- (void) playFrom:(NSInteger)begin completeBlock:(EZOperationBlock)block;

- (void) play;

- (void) play:(EZOperationBlock)block;

//Only play one step. then stop
- (void) playOneStep:(NSInteger)begin completeBlock:(EZOperationBlock)block;

//It means play the current steps once more.
- (void) replay;

- (void) replay:(EZOperationBlock)block;

- (BOOL) isPlaying;

- (void) pause;

//Currently, the stop do one more thing than pause, that is set the currentAction to zero.
//Only the quit will call it.
//Normally others only call the pause.
- (void) stop;

- (void) resume;

//What the meaning of next?
//When next get clicked
//I will adjust the status to stepwise.
- (void) next;

- (void) next:(EZOperationBlock)block;

//What's the meaning of prev?
//Once this was called, I will play the previous action.
//For the prev to work?
//I need to reset the effects of current action.
//Prev mean to undo the effects of current action.
- (void) prev;

- (void) prev:(EZOperationBlock)block;

- (BOOL) isEnd;

//Drag the progressBar forward and backward
- (void) forwardFrom:(NSInteger)oldPos to:(NSInteger) newPos;

//Start from beginning;
- (void) rewind;


//Protected
- (void) cleanActionMove:(NSArray*)moves;
- (void) stepCompleted;
- (void) playSound:(EZAction*)action completeBlock:(void(^)())blk;
- (void) stopSound;

- (void) playMoves:(EZAction*)action completeBlock:(void (^)())blk withDelay:(CGFloat)delay;


@property (assign, nonatomic) NSInteger currentAction;
@property (assign, nonatomic) EZActionPlayerStatus playingStatus;
@property (strong, nonatomic) NSArray* actions;
@property (strong, nonatomic) NSObject<EZBoardDelegate>* board;
@property (strong, nonatomic) NSObject<EZActionCompleted>* completedHandler;
@property (strong, nonatomic) EZOperationBlock completeBlock;
@property (assign, nonatomic) BOOL inMainBundle;

@property (strong, readonly) NSMutableArray* stepCompletionBlocks;

@property (assign, nonatomic) CGFloat soundVolume;

@end
