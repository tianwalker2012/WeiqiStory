//
//  EZActionPlayer.m
//  WeiqiStory
//
//  Created by xietian on 12-9-20.
//
//

#import "EZActionPlayer.h"
//#import "EZChessBoard.h"
#import "EZAction.h"
#import "EZConstants.h"
#import "EZBlockWrapper.h"
#import "EZCoord.h"
#import "EZSoundPlayer.h"
#import "EZExtender.h"
#import "EZSoundAction.h"
#import "EZChessMoveAction.h"
#import "EZAudioFile.h"



@interface  EZActionPlayer(){
    NSTimer* actionTimer;
    EZSoundPlayer* soundPlayer;
    //The purpose of this is to pervent the timer get released.
    //See if the problem can be solved.
    //Will remove it after the test is done
    NSMutableArray* timerArray;
}


- (void) playSound:(EZAction*)action completeBlock:(void(^)())blk;

- (void) playMoves:(EZAction*)action completeBlock:(void(^)())blk;

//Recover the board status to the status before this action.
- (void) undoAction:(EZAction*)action;

- (void) cleanActionMove:(NSArray*)moves;

@end


@implementation EZActionPlayer
//@synthesize currentAction, playingStatus, actions, board;

- (id) initWithActions:(NSArray*)acts chessBoard:(NSObject<EZBoardDelegate>*)bd inMainBundle:(BOOL)mainBundle
{
    self = [super init];
    if(self){
        _actions = acts;
        _board = bd;
        _currentAction = 0;
        _playingStatus = kPause;
        timerArray = [[NSMutableArray alloc] init];
        _stepCompletionBlocks = [[NSMutableArray alloc] init];
        _soundVolume = InitialVolume;
        _inMainBundle = mainBundle;
        _actionDelay = DefaultUnitDelay;
        _delayScale = 1;
    }
    return self;
}


//Once the step completed
//Or the whole activity get completed, this method will get called
- (void) stepCompleted
{
    [_completedHandler completed:_actions.count - 1];
    if(_completeBlock){
        _completeBlock();
    }
}

- (void) setSoundVolume:(CGFloat)soundVolume
{
    [soundPlayer setVolume:soundVolume];
    _soundVolume = soundVolume;
    
}

//When to call this method?
//Start from a place we stopped.
- (void) play
{
    [self playFrom:_currentAction];
}

- (void) play:(EZOperationBlock)completeBlock
{
    _completeBlock = completeBlock;
    [self play];
}
//Mean client clicked play.
//So I will play from current to the end.
- (void) playFrom:(NSInteger)begin
{
    _playingStatus = kPlaying;
    _currentAction = begin;
    [self resume];
}

- (void) playFrom:(NSInteger)begin completeBlock:(EZOperationBlock)block
{
    EZDEBUG(@"Play from:%i", begin);
    _completeBlock = block;
    [self playFrom:begin];
}

//Only play in a stepwise fashion.
- (void) pause{
    _playingStatus = kStepWisePlaying;
    if(_currentAction > 0){
        EZAction* action = [_actions objectAtIndex:_currentAction-1];
        [action pause:self];
    }
}

//later will differentiate it. 
- (void) stop
{
    [self pause];
    _currentAction = 0;
}

//What the meaning of next?
//When next get clicked
//I will adjust the status to stepwise.
- (void) next
{
    //++_currentAction;
    _playingStatus = kStepWisePlaying;
    [self resume];
}

- (void) next:(EZOperationBlock)completBlock
{
    _completeBlock = completBlock;
    [self next];
}

- (BOOL) isEnd
{
    if(_currentAction >= _actions.count){
        return true;
    }
    return false;
}


//Once you set actions, mean you will start all things from the beginning
//You have to take care of cleaning the board by yourself. 
- (void) setActions:(NSArray *)actions
{
    _currentAction = 0;
    _actions = actions;
}

//Start from beginning;
//What's assumption I should make?
//It maybe called at any place.
//So what should we do?
//Make it simple and straightward.
- (void) rewind
{
    //NSInteger endPos = _currentAction;
    _currentAction = 0;
    //for(int i = (endPos-1); i >= 0; --i){
    //    EZAction* action = [_actions objectAtIndex:i];
    //    [self undoAction:action];
    //}
    [_board cleanAllMoves];
    [_board cleanAllMarks];
}

//This is for the purpose of dragging the progressBar forward and backward. 
- (void) forwardFrom:(NSInteger)oldPos to:(NSInteger) newPos
{
    if(oldPos < newPos){
        for(int i = oldPos; i < newPos; i++){
            EZAction* action = [_actions objectAtIndex:i];
            [action fastForward:self];
        }
    }else if(oldPos > newPos){
        for(int i = oldPos-1; i >= newPos; i--){
            EZAction* action = [_actions objectAtIndex:i];
            [action undoAction:self];
        }
    }else{//mean oldPos == newPos
        
    }
    _currentAction = newPos;
}

//Only need to handle presetting and moves
- (void) undoAction:(EZAction*)action
{
    [action undoAction:self];
}

//So far, for clean no need to distinguish what kind of move it is.
//As time goes by, there will be more than one dot on the same position.
- (void) cleanActionMove:(NSArray*)moves
{
    //for(EZCoord* coord in moves){
        //[_board clean:coord animated:NO];
    [_board regretSteps:moves.count animated:NO];
    //}
}


- (void) undoOneStep
{
    --_currentAction;
    if(_currentAction < 0){
        //assert(@"Should not call when no step have been played." == nil);
        //Be a good citizen. Don't left inconsistent status.
        _currentAction = 0;
        return;
    }
    
    EZAction* currAction = [_actions objectAtIndex:_currentAction];
    [self undoAction:currAction];
}
//What's the meaning of prev?
//Once this was called, I will play the previous action.
//For the prev to work?
//I need to reset the effects of current action.
//Prev mean to undo the effects of current action.
- (void) prev
{
    //Why? because each steps get played the _currentAction will move to the next step
    
    [self undoOneStep];
    --_currentAction;
    if(_currentAction < 0){
        _currentAction = 0;
        EZDEBUG(@"Only have one action, quite for no prev");
        return;
    }
    EZAction* prevAction = [_actions objectAtIndex:_currentAction];
    [self undoAction:prevAction];
    [self playOneStep:_currentAction];
}

//It means play the current steps once more.
- (void) replay
{
    //Mean nothing played before.
    //Let's play the first step
    //What's user case will have this happened?
    //Not played but hit this button directly.
    if(_currentAction < 0){
        _currentAction = 0;
    }
    
    if(_currentAction == 0){
        [self resume];
    }else{
        NSInteger played = _currentAction - 1;
        EZAction* prevAction = [_actions objectAtIndex:played];
        EZDEBUG(@"Played:%i", played);
        [self undoAction:prevAction];
        [self playOneStep:played];
    }
}

- (void) replay:(EZOperationBlock)completeBlock
{
    _completeBlock = completeBlock;
    [self replay];
}

//Only play one step. then stop
- (void) playOneStep:(NSInteger)begin
{
    _currentAction = begin;
    _playingStatus = kStepWisePlaying;
    [self resume];
}

- (BOOL) isPlaying
{
    return _playingStatus == kPlaying;
}

- (void) playOneStep:(NSInteger)begin completeBlock:(EZOperationBlock)block
{
    _completeBlock = block;
    [self playOneStep:begin];
}

- (void) resume{
    if(_playingStatus != kPlaying && _playingStatus != kStepWisePlaying){
        EZDEBUG(@"Quit for status:%i, currentAction:%i",_playingStatus, _currentAction);
        return;
    }
    EZDEBUG(@" _currentAction:%i, actions Count:%i", _currentAction, _actions.count);
    
    if(_currentAction >= _actions.count){
        _playingStatus = kEnd;
        EZDEBUG(@"Quit for get the end of actions");
        [self stepCompleted];
        return;
    }
    
    //Only truly started will get called. Otherwise it will not get called
    [_completedHandler started:_currentAction];
    EZAction* action = [_actions objectAtIndex:_currentAction];
    EZDEBUG(@"Will play action:%i, name:%@",_currentAction, action.name);
    ++_currentAction;
    
    for(EZEventBlock blk in _stepCompletionBlocks){
        blk(self);
    }
    [action doAction:self];
}

// How to concel this?
// This will be the topic of next iteration.
// Let's wite a test. test the whole thing accordingly.
- (void) playSound:(EZAction*)action completeBlock:(void(^)())blk
{
    EZSoundAction* soundAction = (EZSoundAction*)action;
    if(soundPlayer){
        soundPlayer = nil;
    }
    if(soundAction.currentAudio >= soundAction.audioFiles.count){
        EZDEBUG(@"Complete audio playback");
        if(blk){
            blk();
        }
        return;
    }
    //The reason is that Xcode will not generate the closure correct
    //If I directly pass the block to the method.
    CallBackBlock block =  ^(){
        [self playSound:action completeBlock:blk];
    };
    EZAudioFile* audio = [soundAction.audioFiles objectAtIndex:soundAction.currentAudio];
    soundAction.currentAudio = soundAction.currentAudio + 1;
    soundPlayer = [[EZSoundPlayer alloc] initWithFile:audio.fileName inMainBundle:_inMainBundle completeCall:block];
    [soundPlayer setVolume:_soundVolume];
}

- (void) stopSound
{
    [soundPlayer stop];
}

//Will be called by the pause in the action body
- (void) stopPlayMoves
{
    if(actionTimer){
        [actionTimer invalidate];
        actionTimer = nil;
    }
}


- (void) playMoves:(EZAction*)act completeBlock:(void (^)())blk withDelay:(CGFloat)delay
{
    EZChessMoveAction* action = (EZChessMoveAction*)act;
    //EZDEBUG(@"Get into playMoves with delay %f,play moves:%i, currentMove:%i, object pointer:%i, name:%@",action.unitDelay, action.plantMoves.count, action.currentMove, (int)action, action.name);
    EZAction* localAct = action;
    EZOperationBlock block = ^(){
        [self playMoves:localAct completeBlock:blk];
    };
    EZBlockWrapper* bw = [[EZBlockWrapper alloc] initWithBlock:block];
    
    actionTimer = [NSTimer scheduledTimerWithTimeInterval:action.unitDelay>0?action.unitDelay:_actionDelay target:bw selector:@selector(runBlock) userInfo:nil repeats:NO];
}

- (void) delayBlock:(EZOperationBlock)block delay:(CGFloat)delay
{
    EZBlockWrapper* bw = [[EZBlockWrapper alloc] initWithBlock:block];
    actionTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:bw selector:@selector(runBlock) userInfo:nil repeats:NO];
}

//The logic is clean and nice.
//Let's complete the clone method.
- (void) playMoves:(EZAction*)act completeBlock:(void(^)())blk
{
    EZChessMoveAction* action = (EZChessMoveAction*)act;
    //EZDEBUG(@"in playMoves,currentMove:%i, total move:%i, object pointer:%i, name:%@", action.currentMove, action.plantMoves.count, (int)action, action.name);
    
    if(actionTimer){
        [actionTimer invalidate];
        actionTimer = nil;
    }
    if(action.currentMove >= action.plantMoves.count){
        //EZDEBUG(@"Complete move playback");
        if(blk){
            blk();
        }
        return;
    }
    //In the future we will have other kind of things to plant on the board
    //Now let's get the simplest case up and run.
    EZDEBUG(@"current plant move:%i, total move:%i",action.currentMove, action.plantMoves.count);
    EZCoord* planted = [action.plantMoves objectAtIndex:action.currentMove];
    //EZDEBUG(@"Start to plant move at:%@",planted);
    [_board putChessman:planted animated:YES];
    action.currentMove += 1;
    [self playMoves:action completeBlock:blk withDelay:action.unitDelay];
}


@end
