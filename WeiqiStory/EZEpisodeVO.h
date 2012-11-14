//
//  EZEpisodeVO.h
//  WeiqiStory
//
//  Created by xietian on 12-10-18.
//
//

#import <Foundation/Foundation.h>


@class EZEpisode;
//What's the purpose of this class?
//So that I could be serialized.
@interface EZEpisodeVO : NSObject

//For example: Dead and live number 4 or Start pattern number 2
@property (strong, nonatomic) NSString* name;

//This pattern will be used to draw the small picture which is used to illustrate the this.
//Why use actions.
//It have more information
//Make it simple and stupid in current iterateion
@property (strong, nonatomic) NSArray* basicPattern;

//Like White chess first, Black dead or Robbery or Unconditional alive etc....
@property (strong, nonatomic) NSString* introduction;

//All the actions with this episode.
//So, the player will accept this as it's data to play against.
@property (strong, nonatomic) NSArray* actions;

//Every time the actions get updated, I will reset the thumbnail.
//Great. Have manual way to do this too.
//Seems the purpose of the basicPattern is used to generate the thumbnail.
@property (strong, nonatomic) UIImage* thumbNail;

//The whole small board.
@property (strong, nonatomic) UIImage* completeBoard;

//All the audioFiles included in this episode.
@property (strong, nonatomic) NSArray* audioFiles;

//What's the purpose of this flag.
//To indicate if this episode have downloaded successfully from the server side.
//The default flag shoudl be false, so that the background thread can work on this.
//Once download completed, can use a notification, so that frontend could load
//All the download episode to the list, user could enjoy playing the episode.
@property (assign, nonatomic) BOOL completed;

@property (assign, nonatomic) BOOL inMainBundle;

@property (strong, nonatomic) EZEpisode* PO;


- (id) initWithPO:(EZEpisode*)po;

- (void) persist;

//Generate the thumbNail according to the moves
- (void) regenerateThumbNail;

-(id)initWithCoder:(NSCoder *)decoder;

-(void)encodeWithCoder:(NSCoder *)coder;

@end
