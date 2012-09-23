//
//  MainMenu.m
//  FirstCocos2d
//
//  Created by xietian on 12-9-13.
//
//

#import "MainPage.h"
#import "EZConstants.h"
#import "EZResponsiveRegion.h"

@implementation MainPage
@synthesize goPlaying, goTraining, configure;


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainPage *layer = [MainPage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
   
	return scene;
}

- (id) init
{
    self = [super init];
    if(self){
        CGSize size = [CCDirector sharedDirector].winSize;
        //CCSprite* background = [[CC]]
        
        
    }
    
    return self;
}


//When this will get called
- (void) onEnterTransitionDidFinish
{
    EZDEBUG(@"onEnterTransitionDidFinish");
    //Manually call it.
    //[[EZGameManager sharedGameManager] preloadFiles:[NSArray arrayWithObjects:@"enemy.wav",@"chess-plant.wav", nil]];
    
    //PLAYSOUNDEFFECT(@"chess-plant.wav");
    [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:2];
    [goPlaying onEnterTransitionDidFinish];
    [goTraining onEnterTransitionDidFinish];
    [configure onEnterTransitionDidFinish];
}

- (void) onExit
{
    EZDEBUG(@"onExit");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

@end
