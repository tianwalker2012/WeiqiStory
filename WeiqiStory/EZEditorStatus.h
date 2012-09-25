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

//What's the purpose of this class
//All the editor interface will be manipulated my this class
//Make my life easier.
//@class EZActionPlayer;
@class EZChessBoard;
@interface EZEditorStatus : NSObject

@property (weak, nonatomic) CCMenuItem* presetting;
@property (weak, nonatomic) CCMenuItem* audio;
@property (weak, nonatomic) CCMenuItem* plantMove;

@property (weak, nonatomic) CCMenuItem* saveAction;
@property (weak, nonatomic) CCMenuItem* removeOneStep;
@property (weak, nonatomic) CCMenuItem* preview;
@property (weak, nonatomic) CCMenuItem* previewAll;

@property (weak, nonatomic) CCLabelAtlas* statusText;

@property (assign, nonatomic) EZActionType curEditType;

@property (strong, nonatomic) NSMutableArray* actions;

//This chessBoard will be used to capture the move of the chess
@property (weak, nonatomic) EZChessBoard* chessBoard;


- (void) setBtnPreset:(CCMenuItem*)preset audio:(CCMenuItem*)audio plantMove:(CCMenuItem*)plantMove
                 save:(CCMenuItem*)save remove:(CCMenuItem*)remove preview:(CCMenuItem*)preview previewAll:(CCMenuItem*)previewAll;

- (void) start:(EZActionType)editType;


- (void) save;

- (void) addCleanAction;

- (void) removeLast;

//- (id) initWithPlayer:(EZActionPlayer*)player;

@end
