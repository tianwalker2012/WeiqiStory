//
//  EZEpisode.h
//  WeiqiStory
//
//  Created by xietian on 12-10-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EZAction.h"
//What's the purpose of this class?
//I can't think abstractly about what need in the our player.
//I need a class to stabize and concreting some of my thoughts with the player.
//Once you put something done, it is no more a abstract idea.
//It is something alive now. 
@interface EZEpisode : NSManagedObject

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

//This property will be used to store the thumbNailFile name.
//Why? Becuase thumbNail eat too much memory,
//I have no way to control how the Core data release memory.
@property (strong, nonatomic) NSString* thumbNailFile;

//All the audioFiles included in this episode.
@property (strong, nonatomic) NSArray* audioFiles;

//What's the purpose of this flag.
//To indicate if this episode have downloaded successfully from the server side.
//The default flag shoudl be false, so that the background thread can work on this.
//Once download completed, can use a notification, so that frontend could load
//All the download episode to the list, user could enjoy playing the episode. 
@property (strong, nonatomic) NSNumber* completed;


//Whether all the resource in the mainBundle or not
@property (strong, nonatomic) NSNumber* inMainBundle;

@end
