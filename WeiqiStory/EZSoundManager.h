//
//  EZSoundManager.h
//  SpaceViking
//
//  Created by Apple on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"
#import "SimpleAudioEngine.h"

//What's the purpose of this class?
//Make the simplest class possible. 
//initially as a refractor task.
//Make sure the sound abitility stripped away from the original GameManager. 
//Then gradually, crack it down. 
//You have a whole life to do this. Enjoy.
@interface EZSoundManager : NSObject
{
    // Added for audio
    BOOL hasAudioBeenInitialized;
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
}


@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) GameManagerSoundState managerSoundState;
//@property (readonly) SimpleAudioEngine *soundEngine;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;


+(EZSoundManager*)sharedSoundManager; 
-(void)setupAudioEngine;
-(ALuint)playSoundEffect:(NSString*)soundEffectKey;
-(void)stopSoundEffect:(ALuint)soundEffectID;
-(void)playBackgroundTrack:(NSString*)trackFileName;

- (BOOL) isBackgrondPlaying;
- (void) stopBackground;


//Newly added.
-(void)loadSoundEffects:(NSArray*)effectsFiles;
-(void)unloadSoundEffects:(NSArray*)effectsFiles;


@end
