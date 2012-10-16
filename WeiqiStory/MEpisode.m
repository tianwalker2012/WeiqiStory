//
//  MEpisode.m
//  WeiqiStory
//
//  Created by xietian on 12-10-15.
//
//

#import "MEpisode.h"
#import "EZConstants.h"

@implementation MEpisode

@dynamic name;
@dynamic storedFile;


- (void) dealloc
{
    [super dealloc];
    EZDEBUG(@"dealloced:%i", (int)self);
}

@end
