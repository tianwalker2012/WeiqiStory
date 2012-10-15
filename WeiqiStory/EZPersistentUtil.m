//
//  EZPersistentUtil.m
//  WeiqiStory
//
//  Created by xietian on 12-10-4.
//
//

#import "EZPersistentUtil.h"
#import "EZConstants.h"

@implementation EZPersistentUtil

@end


@implementation NSURL(EZExtension)

- (id)proxyForJson
{
    EZDEBUG(@"proxyForJson get called");
    return [self absoluteString];
}

@end