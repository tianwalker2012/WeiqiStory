//
//  MEpisode.h
//  WeiqiStory
//
//  Created by xietian on 12-10-17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EZDummyObject.h"

@interface ThumbNailConverter : NSValueTransformer {
}
@end

@interface MEpisode : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * storedFile;
@property (nonatomic, retain) UIImage* thumbNail;
@property (nonatomic, retain) EZDummyObject* dummy;

@end
