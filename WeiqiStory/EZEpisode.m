//
//  EZEpisode.m
//  WeiqiStory
//
//  Created by xietian on 12-10-16.
//
//

#import "EZEpisode.h"
#import "EZConstants.h"
#import "EZChess2Image.h"

@implementation EZEpisode
@dynamic basicPattern, name, introduction, audioFiles, actions, thumbNail, completed, thumbNailFile;

- (void) dealloc
{
    EZDEBUG(@"Release episode:%@, memory:%i", self.name, (int)self);
}

@end
