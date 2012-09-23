//
//  EZChessman.h
//  WeiqiStory
//
//  Created by xietian on 12-9-19.
//
//

#import "cocos2d.h"

//Why do we need this?
//We need this so that we can display the number accordingly.
@interface EZChessman : CCSprite


- (EZChessman*) initWithFile:(NSString*)imgFile step:(NSInteger)step showStep:(BOOL)show isBlack:(BOOL)black;

- (EZChessman*) initWithSpriteFrameName:(NSString*)imgFile step:(NSInteger)step showStep:(BOOL)show isBlack:(BOOL)black;


- (EZChessman*) initWithSpriteFrameName:(NSString*)imgFile step:(NSInteger)step showStep:(BOOL)show isBlack:(BOOL)black  showedStep:(NSInteger)showStp;



@property (assign, nonatomic) BOOL showStep;
@property (assign, nonatomic) NSInteger step;
@property (assign, nonatomic) BOOL isBlack;

//What's the purpose of showedStep?
//It is no the real sequence when this was planted
//It is when this was displayed.
//Initially, it is the same as the real steps.
//After a while it will change to it's own value.
@property (assign, nonatomic) NSInteger showedStep;

@end
