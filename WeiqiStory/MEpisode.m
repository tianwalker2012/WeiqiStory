//
//  MEpisode.m
//  WeiqiStory
//
//  Created by xietian on 12-10-17.
//
//

#import "MEpisode.h"
#import "EZConstants.h"


//The purpose of this class is to make the LocalNotification persistentable.
@implementation ThumbNailConverter


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
    EZDEBUG(@"tranform to data");
	NSData *data = UIImagePNGRepresentation(value);
    return data;
	//return [NSKeyedArchiver archivedDataWithRootObject:value];
}


- (id)reverseTransformedValue:(id)value {
    EZDEBUG(@"transform to image");
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return [uiImage autorelease];
    //return [NSKeyedUnarchiver unarchiveObjectWithData:value];
    
}

@end


@implementation MEpisode

@dynamic name;
@dynamic storedFile;
@dynamic thumbNail;
@dynamic dummy;

@end
