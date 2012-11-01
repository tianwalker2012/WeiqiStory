//
//  EZEffectTester.m
//  WeiqiStory
//
//  Created by xietian on 12-10-31.
//
//

#import "EZEffectTester.h"

@implementation EZEffectTester


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZEffectTester *layer = [EZEffectTester node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}

//We will only support potrait orientation
- (id) init
{
    self = [super init];
    if(self){
        CGSize winsize = [CCDirector sharedDirector].winSize;
        //CCSprite* background = [[CC]]
        
        CCSprite* background = [[CCSprite alloc] initWithFile:@"effects.png"];
        background.anchorPoint = ccp(0, 0);
        [self addChild:background];
        //[self addChild:menu];
        
    }
    
    return self;
}


@end
