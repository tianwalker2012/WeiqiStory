//
//  EZDummyObject.m
//  WeiqiStory
//
//  Created by xietian on 12-10-17.
//
//

#import "EZDummyObject.h"
#import "EZConstants.h"

@implementation EZDummyObject

-(void)encodeWithCoder:(NSCoder *)coder {
    
    EZDEBUG(@"encodeWithCoder");
    
    [coder encodeObject:_name forKey:@"name"];
}



-(id)initWithCoder:(NSCoder *)decoder {
    
    EZDEBUG(@"initWithCoder");
    
    _name = [decoder decodeObjectForKey:@"name"];
    
    return self;
    
}

@end
