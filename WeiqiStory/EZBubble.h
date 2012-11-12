//
//  EZBubble.h
//  WeiqiStory
//
//  Created by xietian on 12-11-11.
//
//

#import "cocos2d.h"

@interface EZBubble : CCNode<CCTargetedTouchDelegate>

- (id) initWithBubble:(CCSprite*)bubble broken:(CCSprite*)broken;

@property (nonatomic, strong) CCSprite* bubble;
@property (nonatomic, strong) CCSprite* broken;
@property (nonatomic, assign) BOOL isBroken;

@end
