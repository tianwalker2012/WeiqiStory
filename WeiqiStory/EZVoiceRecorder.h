//
//  EZVoiceRecorder.h
//  SpeakHere
//
//  Created by xietian on 12-9-17.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
//Who will be the user?
//How to use it?
//Init with the fileName, you want the recorded file to be stored.
//Then Record and Stop.
@interface EZVoiceRecorder : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

- (id) initWithFile:(NSString*)fileName;

- (void) stop;

- (void) start;

- (void) play:(NSString*)fileName;

- (BOOL) isRecording;

- (NSURL*) getRecordedFileURL;


@property (strong, nonatomic) NSString* recordedFile;

@end
