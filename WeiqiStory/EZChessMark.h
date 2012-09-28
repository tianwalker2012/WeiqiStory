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
@class EZCoord;
@interface EZChessMark : NSObject


@property (strong, nonatomic) CCNode* mark;
@property (strong, nonatomic) EZCoord* coord;
@property (strong, nonatomic) NSString* text;
@property (assign, nonatomic) NSInteger fontSize;

- (id) initWithNode:(CCNode*)mark coord:(EZCoord*)coord;

- (id) initWithText:(NSString*)text fontSize:(NSInteger)fontSize coord:(EZCoord*)coord ;

@end
