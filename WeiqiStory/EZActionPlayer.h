//
//  EZActionPlayer.h
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import <Foundation/Foundation.h>

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
@protocol EZBoardDelegate <NSObject>

- (void) putChessman:(EZCoord*)coord animated:(BOOL)animated;


- (void) putChessmans:(NSArray*)coords animated:(BOOL)animated;

//How many steps I will regret.
- (void) regretSteps:(NSInteger)steps  animated:(BOOL)animated;

@end


@interface EZActionPlayer : NSObject

- (id) initWithActions:(NSArray*)actions chessBoard:(NSObject<EZBoardDelegate>*)board;

- (void) playFrom:(NSInteger)begin;

- (void) play;
//Only play one step. then stop
- (void) playOneStep:(NSInteger)begin;

//It means play the current steps once more.
- (void) replay;

- (void) pause;

- (void) resume;

//What the meaning of next?
//When next get clicked
//I will adjust the status to stepwise.
- (void) next;

//What's the meaning of prev?
//Once this was called, I will play the previous action.
//For the prev to work?
//I need to reset the effects of current action.
//Prev mean to undo the effects of current action.
- (void) prev;


@property (assign, nonatomic) NSInteger currentAction;
@property (assign, nonatomic) EZActionPlayerStatus playingStatus;
@property (strong, nonatomic) NSArray* actions;
@property (strong, nonatomic) NSObject<EZBoardDelegate>* board;

@end
