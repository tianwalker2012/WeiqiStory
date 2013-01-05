//
//  EZChessMark.h
//  WeiqiStory
//
//  Created by xietian on 12-9-25.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//What's the purpose of this class?
//It is like chess man, the only difference is that
//It will display a user specified CCNode on the specified Coord.
//Enjoy.
//I can feel you are happy. Of course, I am
//I am creating things which could help my daughter to be a Go master.

typedef enum {
    kTextMark,
    kTriangleMark,
    kCycleMark,
    kRectangleMark
} EZChessMarkType;

@class EZCoord;
@interface EZChessMark : NSObject


@property (strong, nonatomic) CCNode* mark;
@property (strong, nonatomic) EZCoord* coord;
@property (strong, nonatomic) NSString* text;
@property (assign, nonatomic) NSInteger fontSize;

//Newly added to support multiple mark types
//By default it is text mark
@property (assign, nonatomic) EZChessMarkType type;
@property (strong, nonatomic) UIColor* markColor;


- (id) initWithNode:(CCNode*)mark coord:(EZCoord*)coord;

- (id) initWithText:(NSString*)text fontSize:(NSInteger)fontSize coord:(EZCoord*)coord;

//This was added for the sake of Triangular and Rectangular and other shape types
- (id) initWithType:(EZChessMarkType)type coord:(EZCoord *)coord;

- (NSDictionary*) toDict;

- (id) initWithDict:(NSDictionary*)dict;

//Only clone the properties, so that I will not copy the node, to fix the bug of chessMark shared among boards
//Now, let's use it.
- (id) clone;

@end
