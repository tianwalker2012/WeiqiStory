//
//  EZPlayerStatus.m
//  WeiqiStory
//
//  Created by xietian on 12-9-23.
//
//

#import "EZPlayerStatus.h"
#import "EZConstants.h"

@implementation EZPlayerStatus

//When this was get called?
//It will get called when one step or the whole thing get completed.
- (void) completed:(NSInteger)completedStep
{
    EZDEBUG(@"Completed get called");
    [_playButton setIsEnabled:YES];
    if(_player.isEnd){
        //[_player rewind];
    }
    
    [_prevButton setIsEnabled:YES];
    
    
    [_nextButton setIsEnabled:YES];
    
    
    [_replayButton setIsEnabled:YES];

    _playing = false;
}

- (void) started:(NSInteger)step
{
    EZDEBUG(@"started get called");
    if(_player.playingStatus == kStepWisePlaying){
        _playButton.isEnabled = false;
        
    }else if(_player.playingStatus == kPlaying){
        //_playButton.isEnabled = false;
        //Why I disable it?
        //Becuse I don't want pause button to be dis-enabled.
    }
    _playing = true;
    _prevButton.isEnabled = false;
    _nextButton.isEnabled = false;
    _replayButton.isEnabled = false;
}

- (id) initWithPlay:(id)play prev:(id)prev next:(id)next replay:(id)replay
{
    self = [super init];
    _playButton = play;
    _prevButton = prev;
    _nextButton = next;
    _replayButton = replay;
    _playing = false;
    [self setInitStatus];
    return self;
}


- (void) setInitStatus
{
    [_playButton setIsEnabled:YES];
    [_prevButton setIsEnabled:NO];
    [_nextButton setIsEnabled:YES];
    [_replayButton setIsEnabled:NO];
}

//How many case do I have?
//When I playing at StepWise
//All the button will be disabled.
//When I playing at Playing model,
//The only available button would be the pause button.
//So the only chance this button will get called was when the playing button are
- (void) play
{
    //Mean things are going on
    //
    if(_playing){
        EZDEBUG(@"Clicked to pause");
        _playButton.isEnabled = false;
        [_playButton setString:@"暂停"];
        _player.playingStatus = kStepWisePlaying;
    }else{
        EZDEBUG(@"Clicked to start");
        [_playButton setString:@"开始"];
        [_player play];
    }
}

@end
