//
//  EZEpisodeVO.m
//  WeiqiStory
//
//  Created by xietian on 12-10-18.
//
//

#import "EZEpisodeVO.h"
#import "EZChess2Image.h"
#import "EZConstants.h"
#import "EZEpisode.h"
#import "EZCoreAccessor.h"

@implementation EZEpisodeVO

//Make it easy to use to the caller.
//I hope this setter will not affect the core data. Let's check. throgh test
- (void) setBasicPattern:(NSArray *)basicPattern
{
    _basicPattern = [NSArray arrayWithArray:basicPattern];
    [self regenerateThumbNail];
}

//Generate the thumbNail according to the moves
- (void) regenerateThumbNail
{
    CGSize thumbSize =  CGSizeMake(ThumbNailSize, ThumbNailSize);
    self.thumbNail = [EZChess2Image generateChessBoard:self.basicPattern size:thumbSize];
}

- (void) dealloc
{
    EZDEBUG(@"episode deallocated:%@", self.name);
}

- (id) initWithPO:(EZEpisode*)po
{
    self = [super init];
    _name = po.name;
    _introduction = po.introduction;
    _actions = po.actions;
    _basicPattern = po.basicPattern;
    _thumbNail = po.thumbNail;
    _audioFiles = po.audioFiles;
    _completed = po.completed.boolValue;
    _inMainBundle = po.inMainBundle.boolValue;
    _thumbNailFile = po.thumbNailFile;
    _PO = po;
    return self;
}

//Will store this object value to database.
//Based on my current knowledge, this method call will have some issue, if called from different thread.
- (void) persist
{
    if(!_PO){
        _PO = [[EZCoreAccessor getClientAccessor] create:[EZEpisode class]];
    }
    _PO.name = _name;
    _PO.introduction = _introduction;
    _PO.actions = _actions;
    _PO.basicPattern = _basicPattern;
    _PO.thumbNail = _thumbNail;
    _PO.audioFiles = _audioFiles;
    _PO.completed = @(_completed);
    _PO.inMainBundle = @(_inMainBundle);
    _PO.thumbNailFile = _thumbNailFile;
    [[EZCoreAccessor getClientAccessor] saveContext];
}

//Will not upload thumbNail?
//Why not.
//Just upload it
//Complete will not upload.
//So that the default value is false.
-(id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    _name = [decoder decodeObjectForKey:@"name"];
    _introduction = [decoder decodeObjectForKey:@"introduction"];
    _actions = [decoder decodeObjectForKey:@"actions"];
    _basicPattern = [decoder decodeObjectForKey:@"basicPattern"];
    //_thumbNail = [decoder decodeObjectForKey:@"thumbNail"];
    _audioFiles = [decoder decodeObjectForKey:@"audioFiles"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_introduction forKey:@"introduction"];
    [coder encodeObject:_actions forKey:@"actions"];
    [coder encodeObject:_basicPattern forKey:@"basicPattern"];
    //[coder encodeObject:_thumbNail forKey:@"thumbNail"];
    [coder encodeObject:_audioFiles forKey:@"audioFiles"];
}

@end
