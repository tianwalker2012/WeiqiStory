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

//It is to remove all the audio file on the iPad
//So I could use the directory space for other purpose.
+ (void) removeAllAudioFiles;

+ (NSArray*) listAllFiles:(NSSearchPathDirectory)type;

+ (void) deleteFiles:(NSString*)files;

+ (UIImage*) imageFromFile:(NSString*)file;

//IF all data have copied into the database
//If it is I will read from the database rather than from the disk.
//Save the efforts of copy things.
+ (BOOL) isDataCopyDone;

+ (void) setDataCopyDone:(BOOL)done;



@end
