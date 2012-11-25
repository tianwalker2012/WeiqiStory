//
//  AppDelegate.m
//  WeiqiStory
//
//  Created by xietian on 12-9-17.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"
#import "EZChessPlay.h"
#import "EZTestSuites.h"
#import "EZChessEditor.h"
#import "EZHomePage.h"
#import "EZListPage.h"
#import "EZEffectTester.h"
#import "EZListTablePage.h"
#import "EZSoundManager.h"
#import "EZEpisodeDownloader.h"
#import "EZFileUtil.h"
#import "EZCoreAccessor.h"
#import "EZListEditPage.h"
#import "EZEpisodeVO.h"
#import "EZChessMoveAction.h"
#import "EZCoord.h"
#import "EZPlayPagePod.h"
#import "EZEnlargeTester.h"
#import "EZListTablePagePod.h"

//#import "EZPlayerStatus.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

//The purpose of this method call is for test purpose.
//Make the whole application as if it is run the first time on the device.
- (void) returnToVirgin
{
    //Clean the databases
    [EZCoreAccessor cleanClientDB];
    //Clean all the audio files
    [EZFileUtil removeAllAudioFiles];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Executed"];
}

- (EZEpisodeVO*) generateEpisodeVO
{
    EZEpisodeVO* res = [[EZEpisodeVO alloc] init];
    res.name = @"黑先";
    res.introduction = @"简介";
    EZChessMoveAction* chessMove = [[EZChessMoveAction alloc] init];
    chessMove.plantMoves = @[[[EZCoord alloc]init:5 y:5],[[EZCoord alloc] init:6 y:6]];
    res.actions = @[chessMove];
    return res;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:YES];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-pad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-pad-hd"];	// Default on iPad RetinaDisplay is "-ipadhd"
    [sharedFileUtils setIPhone5Suffix:@"-hd5"];
    //[self returnToVirgin];
    [EZTestSuites runAllTests];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"Executed"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Executed"];
        [self loadAllFromBundle];
    }
 
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;
    //director_.wantsFullScreenLayout = NO;
	// Display FSP and SPF
	//[director_ setDisplayStats:YES];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

    //This is a block function call. Why not make it blocking call?
    [[EZSoundManager sharedSoundManager] loadSoundEffects:@[sndButtonPress, sndPlantChessman, sndRefuseChessman, sndBubbleBroken]];
	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	//[director_ pushScene:[EZChessEditor scene]];
    //[director_ pushScene:[EZChessPlay scene]];
	//[director_ pushScene:[EZListTablePage scene]];
    //[director_ pushScene:[EZEffectTester scene]];
    [director_ pushScene:[EZHomePage scene]];
    //[director_ pushScene:[EZListEditPage scene]];
    //[director_ pushScene:[[[EZPlayPagePod alloc] initWithEpisode:[self generateEpisodeVO]] createScene]];
    //[director_ pushScene:[EZEnlargeTester node]];
    
    //[director_ pushScene:[EZListTablePagePod node]];
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
//	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
    
	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
	BOOL res = UIInterfaceOrientationIsPortrait(interfaceOrientation);
    EZDEBUG(@"Current orientation is:%i, %@", interfaceOrientation, res?@"supported":@"not supported");
    //Have done some stupid thing?
    return res;
    
}


- (void) loadAllFromBundle
{
    EZEpisodeDownloader* downloader = [[EZEpisodeDownloader alloc] init];
    downloader.isMainBundle = true;
    downloader.baseURL = ((NSURL*)[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@""]]).absoluteString;
    //[downloader downloadEpisode:fileURL completeBlock:nil];
    [downloader downloadAccordingToList:[EZFileUtil fileToURL:@"episode-small.lst"]];
    
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    EZDEBUG(@"Recieved memory warning");
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}
@end

