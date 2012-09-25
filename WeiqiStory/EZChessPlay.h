//
//  EZChessPlay.h
//  FirstCocos2d
//
//  Created by xietian on 12-9-19.
//
//

#import "cocos2d.h"


//What a role a layer will play?
//Layer is actually like a ground of sprite.
//It is by default is transparent.
//For example I want this group of object cover on groups of other object
//We can use layer.
//See people how to use it is a great way to learn.
//Without putting your mind to it doesn't enable you to understand them automatically.
//Intentionality.
//Grow by slowly learn and appreciate the facts around you.
@class EZActionPlayer;
@interface EZChessPlay : CCLayer

+ (CCScene*) scene;

+ (CCScene*) sceneWithActions:(NSArray*)actions;

@property (strong, nonatomic) EZActionPlayer* actPlayer;

@end
