//
//  EZAudioFile.m
//  WeiqiStory
//
//  Created by xietian on 12-10-18.
//
//

#import "EZAudioFile.h"
#import "EZFileUtil.h"

@implementation EZAudioFile

- (NSDictionary*) toDict
{
    NSMutableDictionary* res = [[NSMutableDictionary alloc] init];
    [res setValue:self.class.description forKey:@"class"];
    [res setValue:_fileName forKey:@"fileName"];
    [res setValue:@(_downloaded) forKey:@"downloaded"];
    [res setValue:@(_inMainBundle) forKey:@"inMainBundle"];
    return res;
}

- (id) initWithDict:(NSDictionary*)dict
{
    self = [super init];
    //self = [super initWithDict:dict];
    //Because I turn all the NSURL to strings, so here I should to turn them back.
    _fileName = [dict objectForKey:@"fileName"];
    _downloaded = ((NSNumber*)[dict objectForKey:@"downloaded"]).boolValue;
    _inMainBundle = ((NSNumber*)[dict objectForKey:@"inMainBundle"]).boolValue;
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_fileName forKey:@"fileName"];
    [coder encodeBool:_downloaded forKey:@"downloaded"];
    [coder encodeBool:_inMainBundle forKey:@"inMainBundle"];
}


-(id)initWithCoder:(NSCoder *)decoder {
    //[super initWith]
    //self = [super initWithCoder:decoder];
    _fileName = [decoder decodeObjectForKey:@"fileName"];
    _downloaded = [decoder decodeBoolForKey:@"downloaded"];
    _inMainBundle = [decoder decodeBoolForKey:@"inMainBundle"];
    return self;
    
}

//Simply the invoker.
//So that the code like this will not distributed everywhere.
//Good refractor point.
- (NSURL*) getFileURL
{
    if(_inMainBundle){
        return [EZFileUtil fileToURL:_fileName];
    }else{
        return [EZFileUtil fileToURL:_fileName dirType:NSDocumentDirectory];
    }
}

- (id)proxyForJson
{
    return [self toDict];
}





@end
