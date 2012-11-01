//
//  EpisodeFile.m
//  WeiqiStory
//
//  Created by xietian on 12-10-19.
//
//

#import "EZEpisodeFile.h"
#import "EZExtender.h"

@implementation EZEpisodeFile

//I assume this would make whole chain complete.
- (id) proxyForJson
{
    EZDEBUG(@"I get called");
    return @{@"fileName":_fileName, @"createdTime":[_createTime stringWithFormat:@"yyyyMMdd HHmmss"] };
}


- (id) initDict:(NSDictionary*)dict
{
    self = [super init];
    _fileName = [dict objectForKey:@"fileName"];
    _createTime = [NSDate stringToDate:[dict objectForKey:@"createdTime"] dateString:@"yyyyMMdd HHmmss"];
    return self;
}

@end
