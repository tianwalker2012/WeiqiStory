//
//  FileUtil.h
//  FirstCocos2d
//
//  Created by xietian on 12-9-13.
//
//

#import <Foundation/Foundation.h>

//Why do we need this class?
//To provide the @2x kind of facility to the image file.
@interface EZFileUtil : NSObject

+ (NSURL*) fileToURL:(NSString*)fileName dirType:(NSSearchPathDirectory)type;

//This method will use the default type, that is the
//NSApplicationDirectory.
+ (NSURL*) fileToURL:(NSString*)fileName;


@end
