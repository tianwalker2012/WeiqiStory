//
//  EZEditorStatus.h
//  WeiqiStory
//
//  Created by xietian on 12-9-23.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EZAction.h"
#import "EZCleanAction.h"

typedef enum {
    kEpisodeBegin,
    kPreSetting,
    kPlantMoves,
    kLectures,
    kActionNone
} EZActionType;


//What's the purpose of this class
//All the editor interface will be manipulated my this class
//Make my life easier.
//Not a clean thinking absolutely.

//@class EZActionPlayer;
@class EZChessBoard, EZActionPlayer;
@interface EZEditorStatus : NSObject

@property (weak, nonatomic) CCMenuItem* presetting;
@property (weak, nonatomic) CCMenuItem* audio;
@property (weak, nonatomic) CCMenuItem* plantMove;

@property (weak, nonatomic) CCMenuItem* saveAction;
@property (weak, nonatomic) CCMenuItem* removeOneStep;
@property (weak, nonatomic) CCMenuItem* preview;
@property (weak, nonatomic) CCMenuItem* previewAll;

@property (weak, nonatomic) CCLabelAtlas* statusText;

@property (weak, nonatomic) CCLabelTTF* statusLabel;

@property (assign, nonatomic) EZActionType curEditType;

@property (strong, nonatomic) NSMutableArray* actions;

@property (strong, nonatomic) EZAction* presetAction;


@property (weak, nonatomic) EZActionPlayer* player;

//Keep the record,
@property (assign, nonatomic) BOOL showStep;
//This chessBoard will be used to capture the move of the chess
@property (weak, nonatomic) EZChessBoard* chessBoard;

@property (strong, nonatomic) NSString* audioFileName;


- (void) setBtnPreset:(CCMenuItem*)preset audio:(CCMenuItem*)audio plantMove:(CCMenuItem*)plantMove
                 save:(CCMenuItem*)save remove:(CCMenuItem*)remove preview:(CCMenuItem*)preview previewAll:(CCMenuItem*)previewAll;

- (void) start:(EZActionType)editType;

//When this will get called?
//I go to another branch.
- (void) insertPreset;

- (void) save;

- (void) saveAsEpisodeBegin;

- (void) addCleanAction:(EZCleanType)cleanType;

- (void) addCleanMark;

- (void) removeLast;

- (void) insertShowHand;

- (void) clean;



//- (id) initWithPlayer:(EZActionPlayer*)player;

@end
