//
//  FileUtil.m
//  FirstCocos2d
//
//  Created by xietian on 12-9-13.
//
//

#import "EZFileUtil.h"
#import "EZConstants.h"
#import "cocos2d.h"

@implementation EZFileUtil

//Will list all file under the specified directory
+ (NSArray*) listAllFiles:(NSSearchPathDirectory)type
{
    NSMutableArray* fileURLS = [[NSMutableArray alloc] init];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    /**
    NSArray* dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   type, NSUserDomainMask, YES);
    NSString* docsDir = [dirPaths objectAtIndex:0];
    **/
    
    NSArray* urls = [manager URLsForDirectory:type inDomains:NSUserDomainMask];
    EZDEBUG(@"The Type:%i URLS count is:%i, content:%@",type, urls.count,urls);
    
    for(NSURL* url in urls){
        NSError* error;
        NSArray* contents = [manager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        [fileURLS addObjectsFromArray:contents];
        //EZDEBUG(@"Content size:%i, content:%@",contents.count, contents);
    }
    
    EZDEBUG(@"Final urls:%i", fileURLS.count);
    return fileURLS;
}

+ (void) removeAllAudioFiles
{
    NSArray* urls = [EZFileUtil listAllFiles:NSDocumentDirectory];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSError* error = nil;
    for(NSURL* url in urls){
        NSString* file = url.description;
        error = nil;
        if([file hasSuffix:@"caf"]){
            EZDEBUG(@"Encounter caf, should remove:%@", file);
        
            [fileMgr removeItemAtURL:url error:&error];
            if(error){
                EZDEBUG(@"Error at deleting %@, error detail:%@", url, error);
            }else{
                EZDEBUG(@"Successfully deleted:%@", url);
            }
        }
        
    }
}

+ (void) deleteFile:(NSString*)files
{
    
}


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

//Will pick the proper file with my own name conventions.
//Great, I love this. 
+ (UIImage*) imageFromFile:(NSString *)file
{
    ccResolutionType resolution;
    NSString *fullpath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:file resolutionType:&resolution];
    
    NSLog(@"Full path:%@, resolution type:%i", fullpath, resolution);
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:fullpath];
    return image;
}


//IF all data have copied into the database
//If it is I will read from the database rather than from the disk.
//Save the efforts of copy things.
+ (BOOL) isDataCopyDone
{
   NSNumber* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"DataCopyDone"];
    if(data){
        return data.boolValue;
    }
    return false;
}

+ (void) setDataCopyDone:(BOOL)done
{
    [[NSUserDefaults standardUserDefaults] setBool:done forKey:@"DataCopyDone"];
}

@end
