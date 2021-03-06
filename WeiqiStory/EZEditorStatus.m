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
#import "EZMarkAction.h"
#import "EZCombinedAction.h"
#import "EZShowNumberAction.h"
#import "EZSoundAction.h"
#import "EZChessMoveAction.h"
#import "EZChessPresetAction.h"
#import "EZUploader.h"
#import "EZAudioFile.h"
#import "EZExtender.h"


@interface EZEditorStatus()
{
    EZVoiceRecorder* recorder;
    //EZActionPlayer* actPlayer;
    NSInteger recordedSeq;
    
    //When click started how many move in the board;
    NSInteger currentBoardSteps;
    NSInteger beginMarks;
    
    //This is already preset with CleanAction Before it.
    //My clean action should also clean the marks.
    //Cool. 
    //EZAction* presetAction;
    EZShowNumberAction* showHandAction;
}

@end

@implementation EZEditorStatus

- (id) init
{
    self = [super init];
    if(self){
        _actions = [[NSMutableArray alloc] init];
        //player.actions = _actions;
        _showStep = false;
    }
    return self;
}


- (void) clean
{
    [_actions removeAllObjects];
    self.showStep = false;
    self.presetAction = nil;
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
    //[_statusText setString:info];
    [_statusLabel setString:info];
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
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger countID = [userDefaults integerForKey:@"GlobalCount"];
            ++ countID;
            [userDefaults setInteger:countID forKey:@"GlobalCount"];
            NSString* timestamp = [[NSDate date] stringWithFormat:@"yyyyMMdd"];
            NSString* fileName = [NSString stringWithFormat:@"audio%@%i.caf",timestamp, countID];
            _audioFileName = fileName;
            EZDEBUG(@"Will record to file %@", fileName);
            recorder = [[EZVoiceRecorder alloc] initWithFile:fileName];
            [recorder start];
            
            [self updateStatusText:@"Recording lectures"];
            break;
        }
        case kPlantMoves:{
            currentBoardSteps = _chessBoard.allSteps.count;
            beginMarks = _chessBoard.allMarks.count;
            
            [self updateStatusText:@"Are recording moves"];
            break;
        }
            
        case kPreSetting:{
            currentBoardSteps = _chessBoard.allSteps.count;
            beginMarks = _chessBoard.allMarks.count;
            
            [self updateStatusText:@"Are recording presets"];
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
    //action.actionType = actionType;
    [_actions addObject:action];
}

//I don't need clean mark?
//I need it.
//When I regret, I need to check what is the mark status or not
- (void) addCleanMark
{
    EZCleanAction* action = [[EZCleanAction alloc] init];
    //action.actionType = kPlantMarks;
    [_actions addObject:action];
}

- (void) removeLast
{
    if(_actions.count > 0){
        EZAction* lastAct = [_actions lastObject];
        [_actions removeLastObject];
        [lastAct undoAction:_player];
    }
    
}

- (void) insertShowHand
{
    showHandAction = [[EZShowNumberAction alloc] init];
    showHandAction.curShowStep = _showStep;
    showHandAction.curStartStep = self.chessBoard.allSteps.count;
}

//No defensive coding, just generate the action accordingly.
- (EZAction*) createMarkActions
{
    NSInteger addedMarks = _chessBoard.allMarks.count;
    NSInteger deltaMarks = addedMarks - beginMarks;
    
    EZDEBUG(@"current total marks:%i, deltaMarks:%i", addedMarks, deltaMarks);
    
    if(deltaMarks > 0){
        NSMutableArray* steps = [[NSMutableArray alloc] initWithCapacity:deltaMarks];
        EZMarkAction* markAction = [[EZMarkAction alloc] init];
        for(NSInteger i = 0; i < deltaMarks; i++){
            [steps addObject:[_chessBoard.allMarks objectAtIndex:beginMarks+i]];
        }
        markAction.marks = steps;
        //[_actions addObject:markAction];
        return markAction;
    }
    EZDEBUG(@"Saved marks from:%i, marks number:%i", beginMarks, deltaMarks);
    return nil;
    
}

- (void) insertPreset
{
    EZDEBUG(@"Will insert a preset:%@", _presetAction);
    if(_presetAction){
        [_actions addObject:_presetAction];
    }
}

- (void) saveAsEpisodeBegin
{
    EZCleanAction* cleanAction = [[EZCleanAction alloc] init];
    cleanAction.cleanType = kCleanAll;
    
    EZMarkAction* markAction =  [[EZMarkAction alloc] init];
    markAction.marks = [NSArray arrayWithArray:_chessBoard.allMarks];
    
    EZChessPresetAction*  presetAction = [[EZChessPresetAction alloc] init];
    presetAction.preSetMoves = [_chessBoard getAllChessMoves];
    EZCombinedAction* combined = [[EZCombinedAction alloc] init];
    if(showHandAction){
        combined.actions = @[cleanAction,presetAction, markAction, showHandAction];
    }else{
        combined.actions = @[cleanAction,presetAction, markAction];
    }
    [_actions addObject:combined];
    _presetAction = combined;
    [self updateStatusText:[NSString stringWithFormat:@"Have stored the episode status, the action length is:%i",_actions.count]];
}

- (void) save
{
    //EZAction* action = nil;//[[EZAction alloc]init];
    //action.actionType = _curEditType;

    
    switch (_curEditType) {
        case kLectures:{
            [recorder stop];
            EZSoundAction* sa = [[EZSoundAction alloc] init];
            NSURL* storedFileURL = recorder.getRecordedFileURL;
            //EZUploader* uploader = [[EZUploader alloc] init];
            EZDEBUG(@"Start upload:%@",recorder.recordedFile);
            
            
            EZAudioFile* file = [[EZAudioFile alloc] init];
            file.fileName = recorder.recordedFile;
            file.inMainBundle = false;
            file.downloaded = true;
            sa.audioFiles = @[file];
            EZDEBUG(@"Will store a lectures action with URL:%@", storedFileURL);
            [_actions addObject:sa];
            break;
        }
        case kEpisodeBegin:{
            break;
        }
        case kPreSetting:
        case kPlantMoves:{
            EZAction* action = nil;
            NSInteger addedSteps = _chessBoard.allSteps.count;
            NSInteger markSteps = _chessBoard.allMarks.count;
            NSInteger deltaStep = addedSteps - currentBoardSteps;
            NSInteger deltaMark = markSteps - beginMarks;
            EZDEBUG(@"previous:%i, current:%i",currentBoardSteps, addedSteps);
            if(deltaStep > 0 || deltaMark > 0){
                NSMutableArray* steps = [[NSMutableArray alloc] initWithCapacity:deltaStep];
                for(NSInteger i = 0; i < deltaStep; i++){
                    [steps addObject:[_chessBoard coordForStep:currentBoardSteps+i]];
                }
                
                EZAction* markAction = [self createMarkActions];
                if(_curEditType == kPlantMoves){
                    EZChessMoveAction* ca = [[EZChessMoveAction alloc] init];
                    ca.plantMoves = steps;
                    //Will add settings to setup the delay per steps.
                    ca.unitDelay = ChessPlantAnimateInterval;
                    action = ca;
                    
                    if(markAction){
                        EZCombinedAction* cb = [[EZCombinedAction alloc] init];
                        cb.actions = @[action, markAction];
                        //[_actions addObject:cb];
                        action = cb;
                        
                    }
                
                }else{
                    EZChessPresetAction* pa = [[EZChessPresetAction alloc] init];
                    EZDEBUG(@"Add one combined action");
                    EZAction* markAction = [self createMarkActions];
                    pa.preSetMoves = steps;
                    action = pa;
                    EZCombinedAction* cb = [[EZCombinedAction alloc] init];
                    //EZCleanAction* ca = [[EZCleanAction alloc] init];
                    //ca.cleanType = kCleanAll;
                    if(markAction){
                         cb.actions = @[action,markAction];
                    }else{
                         cb.actions = @[action];
                    }
                    //_presetAction = cb;
                    action = cb;
                    //[_actions addObject:action];
                    
                }
                //Will add the showNumber action
                if(showHandAction){
                    EZCombinedAction* cb = [[EZCombinedAction alloc] init];
                    cb.actions = @[showHandAction, action];
                    action = cb;
                    showHandAction = nil;
                }
                [_actions addObject:action];
            }
            //[self saveMarks];
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
