//
//  EZUILoader.m
//  WeiqiStory
//
//  Created by xietian on 12-10-17.
//
//

#import "EZUILoader.h"

@implementation EZUILoader

+ (EZEpisodeCell*) createEpisodeCell
{
    EZUILoader* loader = [[EZUILoader alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"EZEpisodeCell" owner:loader options:nil];
    return loader.episodeCell;
}

@end
