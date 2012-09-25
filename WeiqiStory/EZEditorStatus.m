//
//  EZEditorStatus.m
//  WeiqiStory
//
//  Created by xietian on 12-9-23.
//
//

#import "EZEditorStatus.h"
#import "EZVoiceRecorder.h"
#import "EZConstants.h"
#import "EZActionPlayer.h"
#import "EZChessBoard.h"
#import "EZCleanAction.h"

@interface EZEditorStatus()
{
    EZVoiceRecorder* recorder;
    //EZActionPlayer* actPlayer;
    NSInteger recordedSeq;
    
    //When click started how many move in the board;
    NSInteger currentBoardSteps;
}

@end

@implementation EZEditorStatus

- (id) init
{
    self = [super init];
    if(self){
        _actions = [[NSMutableArray alloc] init];
        //player.actions = _actions;
    }
    return self;
}

- (void) setBtnPreset:(CCMenuItem*)preset audio:(CCMenuItem*)audio plantMove:(CCMenuItem*)plantMove
                 save:(CCMenuItem*)save remove:(CCMenuItem*)remove preview:(CCMenuItem*)preview previewAll:(CCMenuItem*)previewAll
{
    _presetting = preset;
    _audio = audio;
    _plantMove = plantMove;
    _saveAction = save;
    _removeOneStep = remove;
    _preview = preview;
    _previewAll = previewAll;
    [self resetStatus];
}

- (void) updateStatusText:(NSString*)info
{
    [_statusText setString:info];
}

- (void) resetStatus
{
    _presetting.isEnabled = true;
    _audio.isEnabled = true;
    _plantMove.isEnabled = true;
    _saveAction.isEnabled = false;
    
    _removeOneStep.isEnabled = (_actions.count > 0);
    _preview.isEnabled = (_actions.count > 0);
    _previewAll.isEnabled = (_actions.count > 0);
}

- (void) disableAll
{
    _presetting.isEnabled = false;
    _audio.isEnabled = false;
    _plantMove.isEnabled = false;
    _saveAction.isEnabled = false;
    _removeOneStep.isEnabled = false;
    _preview.isEnabled = false;
    _previewAll.isEnabled = false;
}

- (void) start:(EZActionType)editType
{
    _curEditType = editType;
    [self disableAll];
    
    switch (editType) {
        case kLectures:{
            NSString* fileName = [NSString stringWithFormat:@"lectures%i.caf", recordedSeq++];
            EZDEBUG(@"Will record to file %@", fileName);
            recorder = [[EZVoiceRecorder alloc] initWithFile:fileName];
            [recorder start];
            
            [self updateStatusText:@"101"];
            break;
        }
        case kPlantMoves:{
            currentBoardSteps = _chessBoard.allSteps.count;
            [self updateStatusText:@"201"];
            break;
        }
            
        case kPreSetting:{
            currentBoardSteps = _chessBoard.allSteps.count;
            [self updateStatusText:@"301"];
            break;
        }
        
            
        default:
            break;
    }
    
    _saveAction.isEnabled = true;
}


- (void) addCleanAction:(EZActionType)actionType
{
    //Why do I do this?
    //So I can clean the mark by the clean action Type
    EZCleanAction* action = [[EZCleanAction alloc] init];
    action.actionType = actionType;
    [_actions addObject:action];
}

- (void) addCleanMark
{
    EZCleanAction* action = [[EZCleanAction alloc] init];
    action.actionType = kPlantMarks;
    [_actions addObject:action];
}

//No defensive coding, just generate the action accordingly.
- (void) save
{
    EZAction* action = [[EZAction alloc]init];
    action.actionType = _curEditType;

    
    switch (_curEditType) {
        case kLectures:{
            [recorder stop];
            NSURL* storedFileURL = recorder.getRecordedFileURL;
            action.audioFiles = @[storedFileURL];
            EZDEBUG(@"Will store a lectures action with URL:%@", storedFileURL);
            [_actions addObject:action];
            break;
        }
            
        case kPreSetting:
        case kPlantMoves:{
            NSInteger addedSteps = _chessBoard.allSteps.count;
            NSInteger deltaStep = addedSteps - currentBoardSteps;
            EZDEBUG(@"previous:%i, current:%i",currentBoardSteps, addedSteps);
            if(deltaStep > 0){
                NSMutableArray* steps = [[NSMutableArray alloc] initWithCapacity:deltaStep];
                for(NSInteger i = 0; i < deltaStep; i++){
                    [steps addObject:[_chessBoard coordForStep:currentBoardSteps+i]];
                }
                if(_curEditType == kPlantMoves){
                    action.plantMoves = steps;
                    //Will add settings to setup the delay per steps.
                    action.unitDelay = 0.5;
                }else{
                    action.preSetMoves = steps;
                }
                [_actions addObject:action];
            }
            
            break;
        }
            
        case kPlantMarks:{
            
            break;
        }
        default:
            break;
    }
    _curEditType = kActionNone;
    
    [self resetStatus];
    [self updateStatusText:[NSString stringWithFormat:@"Current Actions:%i", _actions.count]];
    
}

@end
