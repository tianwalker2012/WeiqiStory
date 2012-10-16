//
//  EZEpisode.h
//  WeiqiStory
//
//  Created by xietian on 12-10-16.
//
//

#import <Foundation/Foundation.h>

//What's the purpose of this class?
//I can't think abstractly about what need in the our player.
//I need a class to stabize and concreting some of my thoughts with the player.
//Once you put something done, it is no more a abstract idea.
//It is something alive now. 
@interface EZEpisode : NSObject

//For example: Dead and live number 4 or Start pattern number 2
@property (strong, nonatomic) NSString* name;

//This pattern will be used to draw the small picture which is used to illustrate the this.
@property (strong, nonatomic) NSArray* basicPattern;

//Like White chess first, Black dead or Robbery or Unconditional alive etc....
@property (strong, nonatomic) NSString* introduction;

//All the actions with this episode.
//So, the player will accept this as it's data to play against.
@property (strong, nonatomic) NSArray* actions;

@end
