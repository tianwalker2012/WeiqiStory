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

//Make it easy to use to the caller.
- (void) setBasicPattern:(NSArray *)basicPattern
{
    _basicPattern = [NSArray arrayWithArray:basicPattern];
    [self regenerateThumbNail];
}

//Generate the thumbNail according to the moves
- (void) regenerateThumbNail
{
    CGSize thumbSize =  CGSizeMake(ThumbNailSize, ThumbNailSize);
    _thumbNail = [EZChess2Image generateChessBoard:_basicPattern size:thumbSize];
}

@end
