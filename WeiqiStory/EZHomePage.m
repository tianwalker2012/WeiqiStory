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
#import "EZBubble.h"
#import "EZListTablePagePod.h"

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
            EZDEBUG(@"Button get clicked");
            [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                [[CCDirector sharedDirector] replaceScene:[EZListTablePagePod node]];
            }else{
                [[CCDirector sharedDirector] replaceScene:[EZListTablePage node]];
            }
        }];
        
        __weak CCNode* weakSelf = self;
        [self scheduleBlock:^(){
            [EZBubble generatedBubble:weakSelf z:10];
        } interval:1.0 repeat:kCCRepeatForever delay:0.5];

        background.position = ccp(winsize.width/2, winsize.height/2);
        
        CCMenu* menu = [CCMenu menuWithItems:startButton, nil];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            NSInteger deviceType = [[CCFileUtils sharedFileUtils] runningDevice];
            if(deviceType == kCCiPhone5){
                menu.position = ccp(160, 293);
            }else{
                menu.position = ccp(160, 250);
            }
        }else{
            menu.position =  ccp(385, 556);
        }
        
        EZDEBUG(@"Before add background");
        
        [self addChild:background];
        [self addChild:menu];
        EZDEBUG(@"Done with background"); 
        
    }
    
    return self;
}

- (void) onEnter{
    [super onEnter];
    [[EZSoundManager sharedSoundManager] playBackgroundTrack:@"background.mp3"];
}



@end
