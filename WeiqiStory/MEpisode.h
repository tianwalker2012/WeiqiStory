//
//  MEpisode.h
//  WeiqiStory
//
//  Created by xietian on 12-10-19.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MEpisode : NSManagedObject

@property (nonatomic, retain) id dummy;
@property (nonatomic, retain) id dummys;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * storedFile;
@property (nonatomic, retain) id thumbNail;
@property (nonatomic, retain) NSNumber * completed;

@end
