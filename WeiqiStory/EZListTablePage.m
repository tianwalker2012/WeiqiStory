//
//  EZListTablePage.m
//  WeiqiStory
//
//  Created by xietian on 12-11-7.
//
//

#import "EZListTablePage.h"
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
#import "EZTableViewCell.h"
#import "EZSoundManager.h"
#import "EZSimpleImageView.h"
#import "EZCoreAccessor.h"
#import "EZExtender.h"
#import "EZCoreAccessor.h"

@interface EZListTablePage()
{
    //EZUIViewWrapper* scrollWrapper;
    //UIScrollView* scroll;
    UITableView* _tableView;
    //NSMutableArray* _episodes;
    
    //It is there mean not dirty.
    //Not exist mean dirty
    NSMutableDictionary* dict;
}

@end

@implementation EZListTablePage

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZListTablePage *layer = [EZListTablePage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168+17;
}


- (NSInteger) totalEpisodes
{
    return [[EZCoreAccessor getClientAccessor] count:[EZEpisode class]];
}

- (NSInteger) currentRows
{
    
    int row = _recentEpisodes / 4;
    int col = _recentEpisodes % 4;
    if(col > 0){
        row ++;
    }
    return row;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self currentRows];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//Time to release the resources
- (void) cleanCell:(UITableViewCell*) cell
{
    for(UIView* view in cell.subviews){
        if([view.class isSubclassOfClass:[EZBoardPanel class]]){
            [view removeFromSuperview];
        }
    }
}

- (void) refreshView:(UITableViewCell*) cell
{
    for(UIView* view in cell.subviews){
        if([view.class isSubclassOfClass:[EZBoardPanel class]]){
            //[view removeFromSuperview];
            EZDEBUG(@"Will refresh some view");
            [view setNeedsDisplay];
        }
    }
}


//When could I reuse the cells?
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZTableViewCell* cell = nil; //= (EZTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"smallboard"];
    
    if(cell == nil){
        EZDEBUG(@"Create new cell");
        cell = [[EZTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"smallboard"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        EZDEBUG(@"Reuse old cell");
        [self cleanCell:cell];
    }
    int startPos = indexPath.row * 4;
    int endPos = startPos + 4;
    if(endPos > _recentEpisodes){
        endPos = _recentEpisodes;
    }
    
    //int col = (indexPath.ro-1) % 4;
    
    CGFloat widthGap = 45;
    CGFloat panelWidth = 142;
    
   
                         
    EZDEBUG(@"current row %i, will add item:%i",indexPath.row, (endPos - startPos));
    for(int i = startPos; i < endPos; i++){
        CGFloat xPos = (widthGap + panelWidth) * (i - startPos);
        
        EZEpisode* ep = [self getEpisode:i];
        
        if(ep.thumbNail == nil){
            ep.thumbNail = [EZImageView generateSmallBoard:ep.basicPattern];
            [[EZCoreAccessor getClientAccessor] saveContext];
        }
        
        EZBoardPanel* panel = [[EZBoardPanel alloc] initWithEpisodePO:ep];
        panel.userInteractionEnabled = true;
        EZDEBUG(@"The completeBoard size:%@", NSStringFromCGSize(ep.thumbNail.size));
        
        [panel setPosition:ccp(xPos, 0)];
        panel.tappedBlock = ^(){
                EZDEBUG(@"The episode %@ get tapped", ep.name);
                [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
                EZPlayPage* playPage = [[EZPlayPage alloc] initWithEpisode:ep];
                [_tableView removeFromSuperview];
                [[CCDirector sharedDirector] pushScene:[playPage createScene]];
               
            };
        [cell addSubview:panel];
        
    }
    //UIView* testHide =  [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    //testHide.backgroundColor = [UIColor redColor];
    //[cell addSubview:testHide];
    //[self refreshView:cell];
    return cell;
}


- (void) addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(35, 150, 703, 826) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}


//What's the responsbility of this method
//First I will check what's the lastest accessed position?
//later will add query the database, if the limit reached.
- (void) loadFromDB:(NSInteger)pos limit:(NSInteger)limit
{
    NSInteger mostRecent = ((NSNumber*)[_episodeMap recentlyVisited]).integerValue;
    NSInteger begin = pos;
    if(mostRecent > pos){ //I need to read from, mean user scroll up.
        begin = pos - BatchFetchSize + 1;
        if(begin < 0){
            begin = 0;
        }
    }
    NSArray* arr = [[EZCoreAccessor getClientAccessor] fetchObject:[EZEpisode class] begin:begin limit:BatchFetchSize];
    NSInteger count = 0;
    for(EZEpisode* ep in arr){
        [_episodeMap setObject:ep forKey:@(begin + count)];
        count ++;
    }
}

- (EZEpisode*) getEpisode:(NSInteger)pos
{
    EZEpisode* res = [_episodeMap getObjectForKey:@(pos)];
    if(res == nil){
        EZDEBUG(@"didn't exist in map, let fetch from DB");
        [self loadFromDB:pos limit:BatchFetchSize];
        res = [_episodeMap getObjectForKey:@(pos)];
    }
    return res;
}

//We will only support potrait orientation
- (id) init
{
    self = [super init];
    if(self){
        CGSize winsize = [CCDirector sharedDirector].winSize;
        //CCSprite* background = [[CC]]
        _dirtyFlags = [[NSMutableDictionary alloc] init];
        CCSprite* background = [CCSprite spriteWithFile:@"list-page.png"];
        
        EZDEBUG(@"Loaded background");
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:background.displayFrame name:@"list-page.png"];
        
        background.position = ccp(winsize.width/2, winsize.height/2);
        [self addChild:background z:10];
        
        
        //CCSprite* smallBoard = [CCSprite spriteWithFile:@"small-board.png"];
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:smallBoard.displayFrame name:@"small-board.png"];
        [self addTableView];
        //_episodes = [[NSMutableArray alloc] init];
        EZDEBUG(@"Added tableView");
        _recentEpisodes = [[EZCoreAccessor getClientAccessor] count:[EZEpisode class]];
        EZDEBUG(@"recentEpisodes:%i", _recentEpisodes);
        _episodeMap = [[EZLRUMap alloc] initWithLimit:30];
        EZDEBUG(@"map initalized");
        //Download the source from the server
        //[self startDownload];
        [self loadFromDB:0 limit:30];
        EZDEBUG(@"loadedFromDB, map count %i", _episodeMap.count);
        //[self loadEpisode];
        //[self startDownload];
    }
    return self;
}



//List all available Fonts on iOS.

- (void) onEnter
{
    [super onEnter];
    [[CCDirector sharedDirector].view addSubview:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadedEpisode:) name:EpisodeDownloadDone object:nil];
}

- (void) onExit
{
    [super onExit];
    [_tableView removeFromSuperview];
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
    int previousRow = [self currentRows];
    //[_episodes addObject:epv];
    EZDEBUG(@"Before Query for data:%i", _recentEpisodes);
    _recentEpisodes = [[EZCoreAccessor getClientAccessor] count:[EZEpisode class]];
    EZDEBUG(@"After Query for data:%i", _recentEpisodes);
    int curRow = [self currentRows];

    if(curRow > previousRow){
        EZDEBUG(@"Add new row");
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(curRow - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        EZDEBUG(@"Reuse old rows");
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(curRow - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


//Make sure the episode was which send by the notification
- (void) downloadedEpisode:(NSNotification*) notify
{
    EZDEBUG(@"currentThread:%i, mainThread:%i",(int)[NSThread currentThread], (int)[NSThread mainThread]);
    EZEpisodeVO* episode = notify.object;
    EZDEBUG(@"Object id:%i, thumberNail:%@", (int)episode, episode.thumbNail);
    //[_episodes addObject:episode];
    [self showEpisode:episode];
    
}


@end
