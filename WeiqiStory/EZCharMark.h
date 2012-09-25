//
//  EZCharMark.h
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import "EZAction.h"

@class EZCoord;
@interface EZCharMark : NSObject

@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) EZCoord* coord;


+ (id) create:(NSString*)content coord:(EZCoord*)coord;

@end
