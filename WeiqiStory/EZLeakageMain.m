//
//  EZLeakageMain.m
//  WeiqiStory
//
//  Created by xietian on 12-11-26.
//
//

#import "EZLeakageMain.h"
#import "EZConstants.h"
#import "EZLeakageChild.h"
#import "EZBubble.h"
#import "EZImageView.h"
#import "EZCoord.h"

@implementation EZLeakageMain

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZLeakageMain *layer = [EZLeakageMain node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}

//We will only support potrait orientation
- (id) init
{
    self = [super init];
    if(self){
        CCSprite* background = [[CCSprite alloc] initWithFile:@"home-page.png"];
        background.anchorPoint = ccp(0,0);
        background.position = ccp(0,0);
        CCMenuItemImage* startButton = [CCMenuItemImage itemWithNormalImage:@"start-button.png" selectedImage:@"start-button-pressed.png" block:^(id sender){
            EZDEBUG(@"Button get clicked");
            [[CCDirector sharedDirector] replaceScene:[EZLeakageChild node]];
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
        
        
        NSArray* coords = @[[[EZCoord alloc]init:2 y:2]];
        UIImage* image = [EZImageView generateSmallBoard:coords];
        EZDEBUG(@"Image size:%@", NSStringFromCGSize(image.size));
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        [[CCDirector sharedDirector].view addSubview:imageView];
        
    }
    
    return self;
}

- (void) onExit
{
    [super onExit];
    //[self unscheduleAllSelectors];
}

- (void) dealloc
{
    EZDEBUG(@"Dealloc LeakageMain");
}

@end
