//
//  EZListPage.m
//  WeiqiStory
//
//  Created by xietian on 12-10-29.
//
//

#import "EZListPage.h"
#import "EZConstants.h"
#import "EZChess2Image.h"
#import "EZCoord.h"
#import "EZUIViewWrapper.h"
#import "EZExtender.h"
#import "EZImageView.h"
#import "EZEpisode.h"
#import "EZEpisodeVO.h"
#import "EZEpisodeDownloader.h"
#import "EZBoardPanel.h"
#import "EZPlayPage.h"
#import "EZCoreAccessor.h"
#import "EZEpisode.h"
#import "EZEpisodeVO.h"
#import "EZFileUtil.h"

@interface EZListPage()
{
    EZUIViewWrapper* scrollWrapper;
    UIScrollView* scroll;
    NSMutableArray* _episodes;
}

@end

@implementation EZListPage

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZListPage *layer = [EZListPage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}


- (void) loadEpisode
{
    
    /**
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    NSArray* episodes = [accessor fetchAll:[EZEpisode class] sortField:nil];
    EZDEBUG(@"Fetched:%i", episodes.count);
    for(EZEpisode* ep in episodes){
        [self showEpisode:[[EZEpisodeVO alloc] initWithPO:ep]];
    }
     **/
    EZEpisodeDownloader* downloader = [[EZEpisodeDownloader alloc] init];
    NSURL* fileURL = [EZFileUtil fileToURL:@"episode20121022141041.ar"];
    downloader.baseURL = ((NSURL*)[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@""]]).absoluteString;
    [downloader downloadEpisode:fileURL completeBlock:nil];
    //[downloader downloadAccordingToList:listURL];
    
}
//We will only support potrait orientation
- (id) init
{
    self = [super init];
    if(self){
        CGSize winsize = [CCDirector sharedDirector].winSize;
        //CCSprite* background = [[CC]]
        
        CCSprite* background = [[CCSprite alloc] initWithFile:@"listpage.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:background.displayFrame name:@"listpage.png"];
       
        background.position = ccp(winsize.width/2, winsize.height/2);
        [self addChild:background z:10];
        
        
        CCSprite* smallBoard = [[CCSprite alloc] initWithFile:@"small-board.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:smallBoard.displayFrame name:@"small-board.png"];
        [self addScrollView];
        _episodes = [[NSMutableArray alloc] init];
        
        //Download the source from the server
        //[self startDownload];
        //[self loadEpisode];
        [self startDownload];
    }
    return self;
}

//List all available Fonts on iOS.

- (void) onEnter
{
    [super onEnter];
    [[CCDirector sharedDirector].view addSubview:scroll];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadedEpisode:) name:EpisodeDownloadDone object:nil];
}

- (void) onExit
{
    [super onExit];
    [scroll removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) startDownload
{
    EZEpisodeDownloader *downloader = [[EZEpisodeDownloader alloc] init];
    downloader.baseURL = DownloadBaseURL;
    NSURL* listURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", DownloadBaseURL, ServerListFile]];
    EZDEBUG(@"Start downloading");
    [downloader downloadAccordingToList:listURL];
}


- (void) showEpisode:(EZEpisodeVO*)epv
{
    [_episodes addObject:epv];
    int col = (_episodes.count-1) % 4;
    int row = (_episodes.count-1) / 4;

    CGFloat initX = 0;
    CGFloat initY = 0;
    CGFloat widthGap = 45;
    CGFloat heightGap = 17;
    
    CGFloat panelWidth = 142;
    CGFloat panelHeight = 168;

    
    CGFloat scrollHeight = (row-1)* heightGap + row* panelHeight;

    EZDEBUG(@"content height:%f, scrollHeight:%f", scroll.contentSize.height, scrollHeight);
    if(scroll.contentSize.height < scrollHeight){
        EZDEBUG(@"Adjust the scroll height accordingly");
        scroll.contentSize = CGSizeMake(scroll.contentSize.width, scrollHeight);
    }
    
    CGFloat xPos = (widthGap + panelWidth) * col + initX;
    CGFloat yPos = (heightGap + panelHeight) * row + initY;
    EZDEBUG(@"count:%i, col:%i, row:%i, xPos:%f, yPos:%f",_episodes.count, col, row, xPos, yPos);
    EZBoardPanel* panel = [[EZBoardPanel alloc] initWithEpisode:epv];
    [panel setPosition:ccp(xPos, yPos)];
    
    //panel.name.text = [NSString stringWithFormat:@"第%i讲", _episodes.count];
    //panel.intro.text = epv.introduction;
    panel.tappedBlock = ^(){
        EZDEBUG(@"The episode %@ get tapped", epv.name);
        //EZPlayPage* playPage = [[EZPlayPage alloc] initWithEpisode:epv];
        //[[CCDirector sharedDirector] pushScene:[playPage createScene]];
    };
    [scroll addSubview:panel];
    
}


- (void) showEpisodeOld:(EZEpisodeVO*) epv
{
    [_episodes addObject:epv];
    int col = (_episodes.count-1) % 4;
    int row = (_episodes.count-1) / 4;
    
    CGFloat initX = 0;
    CGFloat initY = 0;
    CGFloat widthGap = 45;
    CGFloat heightGap = 17;
    
    CGFloat panelWidth = 142;
    CGFloat panelHeight = 168;
    
    CGFloat xPos = (widthGap + panelWidth) * col + initX;
    CGFloat yPos = (heightGap + panelHeight) * row + initY;
    
    EZDEBUG(@"count:%i, col:%i, row:%i, xPos:%f, yPos:%f",_episodes.count, col, row, xPos, yPos);
    EZImage* chessImage =[[EZImage alloc] initWithImage:[EZChess2Image generateAdjustedBoard:epv.basicPattern size:CGSizeMake(130, 130)] point:ccp(6,6) z:2];
    
    EZImage* chessFrame = [[EZImage alloc] initWithImage:[UIImage imageNamed:@"small-board-frame"] point:ccp(5, 5) z:3];
    
    EZImageView* smallPanel = [[EZImageView alloc] initWithImage:[UIImage imageNamed:@"small-board"] position:ccp(xPos, yPos)];
    //UIImageView*  = [[UIImageView alloc] initWithImage:smallPanel];
    [smallPanel addEZImage:chessFrame];
    [smallPanel addEZImage:chessImage];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 142, 70, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Adobe Kaiti Std" size:14];
    label.text = [NSString stringWithFormat:@"第%i讲", _episodes.count];
    label.textColor = [UIColor whiteColor];
    
    UILabel* intro = [[UILabel alloc] initWithFrame:CGRectMake(92, 142, 50, 25)];
    intro.backgroundColor = [UIColor clearColor];
    intro.font = [UIFont fontWithName:@"Adobe Kaiti Std" size:14];
    intro.text = epv.introduction;
    intro.textColor = [UIColor whiteColor];
    
    
    [smallPanel addSubview:label];
    [smallPanel addSubview:intro];
    [scroll addSubview:smallPanel];
    
    
}
//Make sure the episode was which send by the notification
- (void) downloadedEpisode:(NSNotification*) notify
{
    EZDEBUG(@"currentThread:%i, mainThread:%i",(int)[NSThread currentThread], (int)[NSThread mainThread]);
    EZEpisodeVO* episode = notify.object;
    EZDEBUG(@"Object id:%i, thumberNail:%@", (int)episode, episode.thumbNail);
    [self  executeBlockInMainThread:^(){
        [self showEpisode:episode];
        
    }];
}



- (void) addScrollView
{
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(35, 150, 702, 826)];
    //scroll.backgroundColor = [UIColor hexToColor:@"8ca841"];
    scroll.contentSize = CGSizeMake(702, 826*2);
    scroll.delegate = self;
    
    /**
    EZCoord* coord1 = [[EZCoord alloc] init:17 y:17];
    EZCoord* coord2 = [[EZCoord alloc] init:16 y:16];
    EZCoord* coord3 = [[EZCoord alloc] init:15 y:15];
    
    EZImage* chessImage =[[EZImage alloc] initWithImage:[EZChess2Image generateAdjustedBoard:@[coord1, coord2, coord3] size:CGSizeMake(130, 130)] point:ccp(6,6) z:2];
        
    EZImage* chessFrame = [[EZImage alloc] initWithImage:[UIImage imageNamed:@"small-board-frame"] point:ccp(5, 5) z:3];
    
    EZImageView* smallPanel = [[EZImageView alloc] initWithImage:[UIImage imageNamed:@"small-board"]];
    //UIImageView*  = [[UIImageView alloc] initWithImage:smallPanel];
    [smallPanel addEZImage:chessFrame];
    [smallPanel addEZImage:chessImage];
    [scroll addSubview:smallPanel];
     **/
}

//What's the purpose of this method?
//This method is to create the whole board in a scroll view.
- (void) addScrollViewOld
{
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(35, 150, 702, 826)];
    scroll.backgroundColor = [UIColor hexToColor:@"8ca841"];
    scroll.contentSize = CGSizeMake(702, 826*2);
    scroll.delegate = self;
    
    
    UIView* parentView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 300, 300)];
    parentView.backgroundColor = [UIColor hexToColor:@"ccc"];
    UIView* chileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    chileView.backgroundColor = [UIColor hexToColor:@"dba554"];
    
    [parentView addSubview:chileView];
    
    ////parentView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 50);
    //CGAffineTransform  transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 50);
    //parentView.transform = CGAffineTransformScale(transform , 1, -1);
    //parentView.transform = transform;
    //parentView.transform = CGAffineTransformConcat(transform, CGAffineTransformInvert(transform));
    UIView* chileView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 50, 50)];
    chileView2.backgroundColor = [UIColor hexToColor:@"ffdd22"];
    [parentView addSubview:chileView2];
    [scroll addSubview:parentView];
    
    
    //CGAffineTransform
    //scrollWrapper = [EZUIViewWrapper wrapperForUIView:scroll];
    //scrollWrapper.anchorPoint = ccp(0, 0);
    //scrollWrapper.position = ccp(35, 74);
    //scrollWrapper.contentSize = CGSizeMake(702, 826);
    //[self addChild:scrollWrapper z:20];
}

- (void) addCCNodeBoard
{
    
    CCSprite* smallBoard = [[CCSprite alloc] initWithFile:@"small-board.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:smallBoard.displayFrame name:@"small-board.png"];
    EZCoord* coord1 = [[EZCoord alloc] init:17 y:17];
    EZCoord* coord2 = [[EZCoord alloc] init:16 y:16];
    EZCoord* coord3 = [[EZCoord alloc] init:15 y:15];
    
    UIImage* chessImage = [EZChess2Image generateAdjustedBoard:@[coord1, coord2, coord3] size:CGSizeMake(130, 130)];
    
    
    CGFloat initX = 36;
    CGFloat initY = 144;
    CGFloat widthGap = 45;
    CGFloat heightGap = 17;
    CGFloat boardWidth = smallBoard.boundingBox.size.width;
    CGFloat boardHeight = smallBoard.boundingBox.size.height;
    
    EZDEBUG(@"The board boundingBox is:%@", NSStringFromCGRect(smallBoard.boundingBox));
    
    for(int i = 0; i < 4; i++){
        for(int j = 0; j < 4; j++){
            //CCSprite* board = [CCSprite spriteWithSpriteFrameName:@"small-bard.png"];
            CCSprite* board = [CCSprite spriteWithFile:@"small-board.png"];
            board.anchorPoint = ccp(0, 0);
            CGFloat xPos = (widthGap + boardWidth) * i + initX;
            CGFloat yPos = (heightGap + boardHeight) * j + initY;
            board.position = ccp(xPos, yPos);
            EZDEBUG(@"Position:%@", NSStringFromCGPoint(board.position));
            [self addChild:board];
            
            CCSprite* chess = [CCSprite spriteWithCGImage:chessImage.CGImage key:@"chessboard"];
            chess.anchorPoint = ccp(0,0);
            chess.position = ccp(7, 33);
            
            CCSprite* frame = [CCSprite spriteWithFile:@"small-board-frame.png"];
            frame.position = ccp(5, 31);
            frame.anchorPoint = ccp(0,0);
            [board addChild:chess];
            [board addChild:frame];
        }
    }

}


#pragma mark scroll view delegate method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    EZDEBUG(@"Did scroll");
}// any offset changes
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2); // any zoom scale changes

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    EZDEBUG(@"Begin dragging:%@", NSStringFromCGPoint(scrollView.contentOffset));
}
// called on finger up if the user dragged. velocity is in points/second. targetContentOffset may be changed to adjust where the scroll view comes to rest. not called when pagingEnabled is YES
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    EZDEBUG(@"Will end dragging:%@", NSStringFromCGPoint(scrollView.contentOffset));
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    EZDEBUG(@"did End Dragging:%@", NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    EZDEBUG(@"begingDecelerate:%@", NSStringFromCGPoint(scrollView.contentOffset));
}// called on finger up as we are moving
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    EZDEBUG(@"didEndDecelerate:%@", NSStringFromCGPoint(scrollView.contentOffset));
}// called when scroll view grinds to a halt

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    EZDEBUG(@"End scroll animation:%@", NSStringFromCGPoint(scrollView.contentOffset));
}// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating

//When this will get called?
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    EZDEBUG(@"View for zoom in scrollView:%@", NSStringFromCGPoint(scrollView.contentOffset));
    return nil;
}// return a view that will be scaled. if delegate returns nil, nothing happens
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2){
    EZDEBUG(@"Begin zoom in");
}// called before the scroll view begins zooming its content
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    EZDEBUG(@"End of Zoom in");
    //It will tell you scale, based on the scale do you job.
    //Can I fade in the bigger and clearer view based on the scale?
}// scale between minimum and maximum. called after any 'bounce' animations

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    EZDEBUG(@"Should Scroll to Top");
    return TRUE;
}// return a yes if you want to scroll to the top. if not defined, assumes YES
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    EZDEBUG(@"Did scroll to TOP");
}


@end
