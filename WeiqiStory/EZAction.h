//
//  EZAction.h
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"

/**
typedef enum {
    kActionNone=-1,//Invalid action type, make easy to program to detect errors
    kPreSetting=1,//What's the meaning, Mean I will have no animation. I just do some preparation job.
    kLectures,//Play back some voice.
    kPlantMoves,//Marks are kind of move.
    kPlantMarks,//Will add marks
    kCleanBoard,//Clean all
    kCleanMarks,//Clean marks
    kCleanAll,//
    kCombinedAction,//For the purpose persistent.
    kShowNumberAction,
    kMarkAction
} EZActionType;
**/
 
 
typedef enum {
    kSync,
    kAsync
} EZActionSyncType;


//The default type is kPreSetting
@class EZActionPlayer;
@interface EZAction : NSObject

//@property (assign, nonatomic) EZActionType actionType;

//We can plant marks or plant other things.
//Let's extend the chessMan to handle the special cases
//For curren stage, let's keep it simple and stupid and weave the big picture ASAP.



//What's the delay among each moves
//This is for the plantMoves
@property (assign, nonatomic) CGFloat unitDelay;
//If the audio file will blocking the action after it or not?
//By default it is a blocking.
@property (assign, nonatomic) BOOL blocking;

//Whether we should clean all the moves on the table or not?
//This is depreciated, right?
//I have explicitly generate a clean action to achieve this.
@property (assign, nonatomic) BOOL clean;

@property (assign, nonatomic) NSString* name;

//One which move this action are played.
//Is this a good practice.
//It is not,
//But it is the simplest practice, so I will stick with the simplest if there is no other
//Clearer standard about which one is better. 


@property (strong, nonatomic) EZOperationBlock nextBlock;

@property (assign, nonatomic) EZActionSyncType syncType;

- (EZAction*) clone;

//Do NOT override this method.
//Otherwise, the action will not continue
//If you override this method, you have to implement
//All the logic in this method.
- (void) doAction:(EZActionPlayer*)player;

- (void) undoAction:(EZActionPlayer*)player;

//For the subclass, override this method.
- (void) actionBody:(EZActionPlayer*)player;

//What's the purpose of this method?
//Will only plant the moves or add the preset.
//Just like the fastward on the video casate machine.
//The moves which have no effects on the board will simply get ignored. 
- (void) fastForward:(EZActionPlayer*)player;


@end


@interface EZAction(JSON)

//What's the purpose of this method?
//Turn a array of json string into a list of Actions.
//This method will be called recursively.
//Mean from inside it will call this method again and again.
+ (NSArray*) collectionToActions:(id)jsonCollections;

//Reverse what the collections are doing.
//My goal of this morning it to get this method implemented.
+ (id) actionsToCollections:(NSArray*)actions;

//It will instantiate a new action out of the NSDictionary.
+ (id) dictToAction:(NSDictionary*)dict;


//Turn the coord into dictionary, which could be jsonized
- (NSArray*) coordsToArray:(NSArray*)coords;

- (NSArray*) arrayToCoords:(NSArray*)dicts;

- (NSArray*) marksToArray:(NSArray*)marks;

- (NSArray*) arrayToMarks:(NSArray*)dicts;


//Each action should override this method.
//Make sure itself could be recoverred and persisted fully without losing information.
- (NSDictionary*) actionToDict;

- (id) initWithDict:(NSDictionary*)dict;

@end