//
//  FileUtil.m
//  FirstCocos2d
//
//  Created by xietian on 12-9-13.
//
//

#import "EZFileUtil.h"
#import "EZConstants.h"

@implementation EZFileUtil

+ (NSURL*) fileToURL:(NSString*)fileName dirType:(NSSearchPathDirectory)type
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                        type, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    EZDEBUG(@"dirPath count:%i, first one:%@",dirPaths.count, docsDir);
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:fileName];
    //recordedFile = fileName;
    
    NSURL *res = [NSURL fileURLWithPath:soundFilePath];
    return res;
    
}

//This method will use the default type, that is the
//NSApplicationDirectory.
//Finally, after 1.5 hours I got the right path name.
//Enjoy
+ (NSURL*) fileToURL:(NSString*)fileName
{
    //return [EZFileUtil fileToURL:fileName dirType:NSApplicationDirectory];
    //NSString* pathStr = [NSString stringWithFormat:@"file:/%@/%@",[[NSBundle mainBundle] bundlePath],fileName];
    NSString* fullPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    
    NSURL* res = [NSURL fileURLWithPath:fullPath];
    EZDEBUG(@"Home made directory name:%@, URL is:%@", fullPath, res);
    return res;
}

@end
