//
//  EZChessMark.m
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import "EZChessMark.h"
#import "EZCoord.h"

@implementation EZChessMark

- (id) initWithNode:(CCNode*)mark coord:(EZCoord*)coord
{
    self = [super init];
    _mark = mark;
    _coord = coord;
    return self;
}

- (id) initWithText:(NSString*)text fontSize:(NSInteger)fontSize coord:(EZCoord*)coord 
{
    self = [super init];
    _text = text;
    _coord = coord;
    _fontSize = fontSize;
    return self;
}

- (NSDictionary*) toDict
{
    return @{@"text":_text, @"coord":[_coord toDict], @"fontSize":@(_fontSize)};
}


- (id) initWithDict:(NSDictionary*)dict
{
    self = [super init];
    _text = [dict objectForKey:@"text"];
    _coord = [[EZCoord alloc] initWithDict:[dict objectForKey:@"coord"]];
    _fontSize = ((NSNumber*)[dict objectForKey:@"fontSize"]).intValue;
    return self;
}

@end
