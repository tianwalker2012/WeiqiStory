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


//For the shaped mark, the purpose of the text is to determine which kind of shape it is.
/**
- (id) initWithType:(EZChessMarkType)type text:(NSString*)text coord:(EZCoord*)coord
{
    self = [super init];
    _text = text;
    _type = type;
    _coord = coord;
    return self;
}
 **/
//This was added for the sake of Triangular and Rectangular and other shape types
- (id) initWithType:(EZChessMarkType)type coord:(EZCoord *)coord
{
    self = [super init];
    _type = type;
    _coord = coord;
    return self;
}

- (id) initWithText:(NSString*)text fontSize:(NSInteger)fontSize coord:(EZCoord*)coord 
{
    self = [super init];
    _type = kTextMark;
    _text = text;
    _coord = coord;
    _fontSize = fontSize;
    return self;
}

- (id) clone
{
    EZChessMark* res = [[EZChessMark alloc] init];
    res.type = _type;
    res.text = _text;
    res.coord = _coord;
    return res;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    //EZDEBUG(@"encodeWithCoder");
    [coder encodeObject:_text forKey:@"text"];
    [coder encodeObject:_coord forKey:@"coord"];
    [coder encodeInt:_fontSize forKey:@"fontSize"];
    [coder encodeInt:_type forKey:@"type"];
}



-(id)initWithCoder:(NSCoder *)decoder {
    //EZDEBUG(@"initWithCoder");
    _text = [decoder decodeObjectForKey:@"text"];
    _coord = [decoder decodeObjectForKey:@"coord"];
    _fontSize = [decoder decodeIntForKey:@"fontSize"];
    _type = [decoder decodeIntForKey:@"type"];
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
