//
//  EZLeakageChild.m
//  WeiqiStory
//
//  Created by xietian on 12-11-26.
//
//

#import "EZLeakageChild.h"
#import "EZConstants.h"
#import "EZLeakageMain.h"
#import "EZBubble.h"

@implementation EZLeakageChild

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZLeakageChild *layer = [EZLeakageChild node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}


- (void) onExit
{
    [super onExit];
    //[self unscheduleAllSelectors];
}
//We will only support potrait orientation
- (id) init
{
    self = [super init];
    if(self){
        CCSprite* background = [[CCSprite alloc] initWithFile:@"background-pattern.png"];
        background.anchorPoint = ccp(0, 0);
        background.position = ccp(0, 0);
        
        
        CCMenuItemImage* startButton = [CCMenuItemImage itemWithNormalImage:@"back-button.png" selectedImage:@"back-button.png" block:^(id sender){
            EZDEBUG(@"Button get clicked");
            [[CCDirector sharedDirector] replaceScene:[EZLeakageMain node]];
        }];
        
        __weak CCNode* weakSelf = self;
        [self scheduleBlock:^(){
            [EZBubble generatedBubble:weakSelf z:10];
        } interval:1.0 repeat:kCCRepeatForever delay:0.5];
        CCMenu* menu = [CCMenu menuWithItems:startButton, nil];
        menu.position = ccp(160, 250);
        
        [self addChild:background];
        [self addChild:menu];
        EZDEBUG(@"Done with background");
        
    }
    
    return self;
}

- (void) dealloc
{
    EZDEBUG(@"Dealloc LeakageChild");
}


@end
