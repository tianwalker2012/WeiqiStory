//
//  EZUIViewWrapper.h
//  WeiqiStory
//
//  Created by xietian on 12-10-30.
//
//

#import "cocos2d.h"

@interface EZUIViewWrapper : CCSprite
{
	UIView *uiItem;
	float rotation;
}

@property (nonatomic, strong) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;

- (void) updateUIViewTransform;

@end