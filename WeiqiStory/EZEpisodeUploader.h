//
//  EZEpisodeUploader.h
//  WeiqiStory
//
//  Created by xietian on 12-10-19.
//
//

#import <Foundation/Foundation.h>
#import "EZConstants.h"


#define EpisodeListFile @"episode.lst"
//What's the invoke's expectation for this class?
//First, I just pass it the episodes,
//It will upload the episodes.
//With all it's audios.
//We have call back to indicate the failure or the success.
//Who will use the uploader?
//My Editor will use it.
//So I wish I could know what's wrong with my upload.
@class EZEpisodeVO;
@interface EZEpisodeUploader : NSObject

@property (nonatomic, strong) NSString* uploadBaseURL;

@property (nonatomic, strong) NSString* downloadBaseURL;

//What I want to do?
//I will update the list, which have the filename and date attached with it.
//Everytime I have new data uploaded, I will change the content of this file, so that
//Client knew which file to download.
//What do you say?
//It is great.
//Let's implement it.
- (void) updateList:(NSString*)fileName;

- (void) cleanList;

- (NSArray*) getEpisodeList;

- (void) uploadEpisodes:(NSArray*) episodes completBlk:(EZOperationBlock)block;

- (void) uploadEpisode:(EZEpisodeVO*)episode nextBlk:(EZOperationBlock)block;

- (void) uploadOnlyEpisodes:(NSArray*)episodes;

@end
