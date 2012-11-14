//
//  EZEpisodeDownloader.h
//  WeiqiStory
//
//  Created by xietian on 12-10-19.
//
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"

@class EZEpisode;
//I think this class will be act as a facade class.
//I just feed him a URL for the EZEpisodes,
//He will get all episode downloaded along with the audio files
//It will send a notification when it is done.
//In Current iteration I will just call call callback block to simplify the logic.
//So following is his repsonsibility.
//1. Download the Episode file
//2. Iterate the episodes in all the episode file and store them to database, set the completeness to false.
//3. For each episode, download all it's audio files.Once the episode file is done,change the completeness to true
//And send a notification to indicate that it is ok.
//TODO, I can setup a thread pool to handle all this.
//But at current stage, let's just keep it simple and stupid.
@interface EZEpisodeDownloader : NSObject

//The base URL which will be used to download the files
@property (nonatomic, strong) NSString* baseURL;

@property (nonatomic, strong) NSThread* worker;

//This is as if all the files are on the local main bundle or the document already,
//Then I will not try to download it again.
//Just use it as it is.
//Update the database.
//In database, I only store the episodeVO,
//I will add another flag to indicate if the audio in the main bundle or in the document.
//Better copy it to the document, so next time when the main bundle get updated nothing will lose, right?
//Sound right. 
@property (nonatomic, assign) BOOL isLocalFile;

@property (nonatomic, assign) BOOL isMainBundle;

@property (nonatomic, assign) NSInteger episodeCounts;

//Once this audio for this guy is over
//I will use the blocking method here.
//I will store the downloaded file to the document directory
//I will give the list of successful files back.
//I want experiment what if the url not exist and what if the file not exist with the NSData.
- (void) downloadAllAudio:(NSArray*)files completeBlock:(EZOperationBlock)block;

//This is a asynchronized method.
//It will not block the main thead. 
- (void) downloadEpisode:(NSURL*)url completeBlock:(EZOperationBlock)block;

//what's the purpos of this method
//I may have multiple episode, so I need to download them
//According to a list on the server side.
- (void) downloadAccordingToList:(NSURL*)url;

- (id) init;

@end
