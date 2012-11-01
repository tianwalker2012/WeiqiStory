//
//  EpisodeFile.h
//  WeiqiStory
//
//  Created by xietian on 12-10-19.
//
//

#import <Foundation/Foundation.h>

//This is class
//Use to present the data in the upload list file.
//What this upload file will do to us?
//For each batch uploaded episode file, I will have a list for it.
//So that each time I could download it.
//Think about How I am going to deliver my content is a very important process.
//Which will determined how I am going to organize my content to make it convinient for me to delivery the contet.

@interface EZEpisodeFile : NSObject

@property (nonatomic, strong) NSString* fileName;

@property (nonatomic, strong) NSDate* createTime;

- (id) proxyForJson;

- (id) initDict:(NSDictionary*)dict;

@end
