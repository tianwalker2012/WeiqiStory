//
//  Constants.h
//  SqueezitProto
//
//  Created by Apple on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef SqueezitProto_Constants_h
#define SqueezitProto_Constants_h
#import <math.h>

#ifdef DEBUG
#define EZCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
EZDEBUG(xx, ##__VA_ARGS__); \
} \
} ((void)0)
#else
#define EZCONDITIONLOG(condition, xx, ...) ((void)0)
#endif // #ifdef DEBUG


#ifdef DEBUG
#define EZDEBUG(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define EZDEBUG(xx, ...)  ((void)0)
#endif // #ifdef DEBUG

typedef void (^ EZOperationBlock)();

//Why add this, seems 
typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
    
} GameManagerSoundState;

//Why do we need this?
//It is about how to transform
typedef enum {
    kOriginal,
    kHorizontal,
    kVertical,
    kDiagonal,
    kOriginalT,//Original Transpose
    kHorizontalT,
    kVerticalT,
    kDiagonalT
} CoordTransformType;


#define AUDIO_MAX_WAITTIME 1.0

#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[EZSoundManager sharedSoundManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[EZSoundManager sharedSoundManager] stopSoundEffect:__VA_ARGS__]

#define LOADSOUNDEFFECT(...) \
[[EZSoundManager sharedSoundManager] loadSoundEffects:__VA_ARGS__]


#endif
