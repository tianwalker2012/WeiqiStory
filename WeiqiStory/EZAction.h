//
//  EZAction.h
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    kPreSetting,//What's the meaning, Mean I will have no animation. I just do some preparation job.
    kLectures,//Play back some voice.
    kPlantMoves//Marks are kind of move. 
} EZActionType;

//The default type is kPreSetting
@interface EZAction : NSObject

@property (assign, nonatomic) EZActionType actionType;

//We can plant marks or plant other things.
//Let's extend the chessMan to handle the special cases
//For curren stage, let's keep it simple and stupid and weave the big picture ASAP.
@property (strong, nonatomic) NSArray* preSetMoves;

//I can assign serveral files
@property (strong, nonatomic) NSArray* audioFiles;

@property (strong, nonatomic) NSArray* plantMoves;

//What's the delay among each moves
//This is for the plantMoves
@property (assign, nonatomic) CGFloat unitDelay;

//If the audio file will blocking the action after it or not?
//By default it is a blocking.
@property (assign, nonatomic) BOOL blocking;

//Whether we should clean all the moves on the table or not?
@property (assign, nonatomic) BOOL clean;

@property (assign, nonatomic) NSString* name;

//One which move this action are played.
//Is this a good practice.
//It is not,
//But it is the simplest practice, so I will stick with the simplest if there is no other
//Clearer standard about which one is better. 
@property (assign, nonatomic) NSInteger currentMove;

@property (assign, nonatomic) NSInteger currentAudio;

- (EZAction*) clone;

@end
