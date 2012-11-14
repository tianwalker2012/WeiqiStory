//
//  HomePage.m
//  WeiqiStory
//
//  Created by xietian on 12-10-29.
//
//

#import "EZHomePage.h"
#import "EZConstants.h"
#import "EZListPage.h"
#import "EZSoundPlayer.h"
#import "EZSoundManager.h"
#import "EZListTablePage.h"

@interface EZHomePage()
{
    EZSoundPlayer* soundPlayer;
}

@end

@implementation EZHomePage


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZHomePage *layer = [EZHomePage node];
	
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
        
        CCSprite* background = [[CCSprite alloc] initWithFile:@"home-page.png"];
        CCMenuItemImage* startButton = [CCMenuItemImage itemWithNormalImage:@"start-button.png" selectedImage:@"start-button-pressed.png" block:^(id sender){
            [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            [[CCDirector sharedDirector] replaceScene:[EZListTablePage node]];
        }];
        
        background.position = ccp(winsize.width/2, winsize.height/2);
        
        CCMenu* menu = [CCMenu menuWithItems:startButton, nil];
        menu.position =  ccp(winsize.width/2, winsize.height/2);
        
        [self addChild:background];
        [self addChild:menu];
        
    }
    
    return self;
}


@end
