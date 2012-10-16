//
//  MEpisode.h
//  WeiqiStory
//
//  Created by xietian on 12-10-15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MEpisode : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * storedFile;

@end
