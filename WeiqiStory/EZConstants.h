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

//Used to handle the events, passing the sender to aviod cyclic reference holder.
typedef void (^ EZEventBlock)(id sender);

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

//Why need to differentiate this 2?
//So that I can test the functionality without need to worry about all the things.

#define DownloadBaseURL @"http://192.168.10.104:3000"

#define UploadBaseURL @"http://192.168.10.104:3000/upload"

#define ServerListFile @"episode.lst"

#define EditorDB @"WeiqiEditor.sqlite"

#define ClientDB @"WeiqiClient.sqlite"

#define CoreDBModel @"ChessLecture"


#define sndRefuseChessman @"refuse.wav"
#define sndPlantChessman @"plant-chess.wav"
#define sndButtonPress @"pressed.wav"
#define sndBubbleBroken @"bubble-broken.wav"

#define BubbleTouchPriority 20

//What if something failed?
//Should we do some thing about it?
//Have some retry mechanism later.
//Add them later. 
#define EpisodeDownloadDone @"EpisodeDownloadDone"

#define BatchFetchSize 8

#define PodBatchFetchSize 6

#define ImageCacheSize 15

#define ChessMarkColor ccc3(122, 190, 83)

#define AUDIO_MAX_WAITTIME 1.0

#define ChessRemoveAnimateInterval 0.3

#define ChessPlantAnimateInterval 0.6

#define ThumbNailSize  150

#define InitialVolume 0.8


#define ezrect(x, y, w, h) \
    CGRectMake(x, y, w, h)

#define ezros(pos, size) \
    CGRectMake(pos.x, pos.y, size.width, size.height)

#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[EZSoundManager sharedSoundManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[EZSoundManager sharedSoundManager] stopSoundEffect:__VA_ARGS__]

#define LOADSOUNDEFFECT(...) \
[[EZSoundManager sharedSoundManager] loadSoundEffects:__VA_ARGS__]


#endif
