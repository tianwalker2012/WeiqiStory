//
//  EZListTablePagePod.m
//  WeiqiStory
//
//  Created by xietian on 12-11-21.
//
//

#import "EZListTablePagePod.h"
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
#import "EZBubble.h"
#import "EZLRUMap.h"
#import "EZPlayPagePod.h"

@interface EZListTablePagePod()
{
    //EZUIViewWrapper* scrollWrapper;
    //UIScrollView* scroll;
    UITableView* _tableView;
    //NSMutableArray* _episodes;
    
    //It is there mean not dirty.
    //Not exist mean dirty
    NSMutableDictionary* dict;
    
    BOOL isFirstTime;
    
    //I will move the preloading 
    BOOL isPreloading;
}

@end

@implementation EZListTablePagePod

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZListTablePagePod *layer = [EZListTablePagePod node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger deviceType = [[CCFileUtils sharedFileUtils] runningDevice];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 168+17;
    }else{
        return 168+10;
    }
}


- (NSInteger) totalEpisodes
{
    return [[EZCoreAccessor getClientAccessor] count:[EZEpisode class]];
}

- (NSInteger) currentRows
{
    
    NSInteger base = 2;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        base = 4;
    }
    
    int row = _recentEpisodes / base;
    int col = _recentEpisodes % base;
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


- (void) dealloc
{
    EZDEBUG(@"EZListTablePagePod Released");
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
    
    
    CGFloat widthGap = 16;
    CGFloat panelWidth = 142;
    NSInteger base = 2;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        base = 4;
        widthGap = 45;
        
    }
    int startPos = indexPath.row * base;
    int endPos = startPos + base;
    if(endPos > _recentEpisodes){
        endPos = _recentEpisodes;
    }
    
    //int col = (indexPath.ro-1) % 4;
    
    
    EZDEBUG(@"current row %i, will add item:%i",indexPath.row, (endPos - startPos));
    for(int i = startPos; i < endPos; i++){
        CGFloat xPos = (widthGap + panelWidth) * (i - startPos);
        
        EZEpisodeVO* epv = [self getEpisode:i];
        
        //if(epv.thumbNail == nil){
        //    epv.thumbNail = [EZImageView generateSmallBoard:epv.basicPattern];
        //}
        UIImage* smallboard = [EZFileUtil imageFromDocument:epv.thumbNailFile scale:[[UIScreen mainScreen] scale]];
        //smallboard.scale = [[UIScreen mainScreen] scale];
        epv.thumbNail = smallboard;
        
        EZBoardPanel* panel = [[EZBoardPanel alloc] initWithEpisode:epv];
        panel.userInteractionEnabled = true;
        EZDEBUG(@"row:%i ,The completeBoard size:%@, isMainThread:%@, epv.name:%@", indexPath.row, NSStringFromCGSize(smallboard.size), [NSThread isMainThread]?@"YES":@"NO", epv.name);
        
        [panel setPosition:ccp(xPos, 0)];
        panel.tappedBlock = ^(){
            EZDEBUG(@"The episode %@ get tapped", epv.name);
            [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            
            CCScene* nextScene = nil;
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                EZPlayPage* playPage = [[EZPlayPage alloc] initWithEpisode:epv];
                nextScene = [playPage createScene];
            }else{
                EZPlayPagePod* playPage = [[EZPlayPagePod alloc] initWithEpisode:epv currentPos:i];
               
    EZDEBUG(@"Tapped index:%i, instance pointer:%i, readback value:%i", i, (int)playPage, playPage.currentEpisodePos);
                nextScene = [playPage createScene];
            }
            
            [tableView removeFromSuperview];
            [[CCDirector sharedDirector] replaceScene:nextScene];
            
        };
        [cell addSubview:panel];
        EZDEBUG(@"Added panel to cell subView");
    }
    //UIView* testHide =  [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    //testHide.backgroundColor = [UIColor redColor];
    //[cell addSubview:testHide];
    //[self refreshView:cell];
    return cell;
}

- (void) addTableView
{
    NSInteger runningDevice = [[CCFileUtils sharedFileUtils] runningDevice];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(35, 150, 703, 826) style:UITableViewStylePlain];
    }else{
        if(runningDevice == kCCiPhone5){
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 69, 300, 480) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 69, 300, 383) style:UITableViewStylePlain];
        }
    }
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}

//When this will get called?
//I will only load batch size records then update the tableView accordingly
//I have some issue, normally, it will query the full size of the database.
//Now I only load what I need.
//I assume this will be called, whenever I get loaded.
- (void) preload
{
    EZDEBUG(@"Preload begin");
    NSArray* addedEpisodes = [[EZCoreAccessor getClientAccessor] fetchObject:[EZEpisode class] begin:_recentEpisodes limit:PodBatchFetchSize];
    EZDEBUG("Preloaded:%i", addedEpisodes.count);
    if(addedEpisodes.count > 0){
        NSInteger count = 0;
        int prevRow = [self currentRows];
        for(EZEpisode* ep in addedEpisodes){
            EZEpisodeVO* epv = [[EZEpisodeVO alloc] initWithPO:ep];
            [_episodeMap setObject:epv forKey:@(_recentEpisodes + count)];
            count ++;
        }
        _recentEpisodes += addedEpisodes.count;
        int curRow = [self currentRows];
        EZDEBUG(@"Preload previousRows:%i, totalEpisodes:%i, curRow:%i", prevRow, _recentEpisodes, curRow);
        if(curRow > prevRow){
            NSMutableArray* insertedPath = [[NSMutableArray alloc] initWithCapacity:curRow - prevRow];
            for(int i = prevRow; i < curRow; i++){
                [insertedPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            //EZDEBUG(@"Inserted Rows:%i", insertedPath.count);
            [_tableView insertRowsAtIndexPaths:insertedPath withRowAnimation:UITableViewRowAnimationFade];
            //EZDEBUG(@"Inserted Rows completed");
        }
        if(prevRow > 0){
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:prevRow - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        //I need to identify the performance bottleneck.
        EZDEBUG(@"Preload end");
    }
}

//I will test
//All the method will call this.
//To check if we need to load more rows or not.
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    
    //What's the purpose of this?
    //Check if user scroll more than
    float y = offset.y + bounds.size.height;
    float h = size.height;
    
    EZDEBUG(@"offset.y:%f, bounds.size.height:%f, insect:%f, total height:%f",y, bounds.size.height, inset.bottom,h);
    NSInteger base = 2;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        base = 4;
    }
    float preload_distance = 50;
    if((y + preload_distance) > h || (_recentEpisodes % base) > 0) {
        NSLog(@"load more rows");
        [self preload];
    }
}

//What's the responsbility of this method
//First I will check what's the lastest accessed position?
//later will add query the database, if the limit reached.
- (void) loadFromDB:(NSInteger)pos limit:(NSInteger)limit
{
    NSInteger mostRecent = ((NSNumber*)[_episodeMap recentlyVisited]).integerValue;
    NSInteger begin = pos;
    if(mostRecent > pos){ //I need to read from, mean user scroll up.
        begin = pos - limit + 1;
        if(begin < 0){
            begin = 0;
        }
    }
    NSArray* arr = [[EZCoreAccessor getClientAccessor] fetchObject:[EZEpisode class] begin:begin limit:limit];
    NSInteger count = 0;
    for(EZEpisode* ep in arr){
        EZEpisodeVO* epv = [[EZEpisodeVO alloc] initWithPO:ep];
        EZDEBUG(@"Add record:%i, name:%@ to cache", begin+count, epv.name);
        [_episodeMap setObject:epv forKey:@(begin + count)];
        count ++;
    }
}

- (EZEpisodeVO*) getEpisode:(NSInteger)pos
{
    EZEpisodeVO* res = [_episodeMap getObjectForKey:@(pos)];
    if(res == nil){
        EZDEBUG(@"%i didn't exist in map, let fetch from DB", pos);
        NSInteger loadSize = PodBatchFetchSize;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            loadSize = BatchFetchSize;
        }
        [self loadFromDB:pos limit:loadSize];
        res = [_episodeMap getObjectForKey:@(pos)];
        if(!res){
            EZDEBUG(@"Pos:%i is null", pos);
            assert(false);
        }
        
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
        
        //EZDEBUG(@"Loaded background");
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:background.displayFrame name:@"list-page.png"];
        
        background.position = ccp(winsize.width/2, winsize.height/2);
        [self addChild:background];
        
        
        
        /** refresh is not necessary
         CCMenu* refreshButton = [CCMenu menuWithItems:[CCMenuItemImage itemWithNormalImage:@"refresh-button-pad.png" selectedImage:@"refresh-button-pressed-pad.png" block:^(id sender){
         EZDEBUG(@"Refresh clicked");
         [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
         [self reloadEpisode];
         
         }], nil];
         refreshButton.position = ccp(678, 949);
         **/
        //[self addChild:refreshButton];
        //CCSprite* smallBoard = [CCSprite spriteWithFile:@"small-board.png"];
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:smallBoard.displayFrame name:@"small-board.png"];
        [self addTableView];
        //_episodes = [[NSMutableArray alloc] init];
        _recentEpisodes = [[EZCoreAccessor getClientAccessor] count:[EZEpisode class]];
        
        
        //What's the purpose of this code, to make sure my image generation is ok,
        //The iPod4 is ok, only iPod5 have some issues.
        //Did this tell me anything?
        
        //NSInteger loadSize = PodBatchFetchSize;
        NSInteger initialSize = 12;
        NSInteger cacheSize = 24;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            initialSize = 24;
            cacheSize = 32;
        }
        
        _episodeMap = [[EZLRUMap alloc] initWithLimit:cacheSize];
        
        
        __weak CCNode* weakSelf = self;
        [self loadFromDB:0 limit:initialSize];
        EZDEBUG(@"loadedFromDB, map count %i", _episodeMap.count);
        [self scheduleBlock:^(){
            [EZBubble generatedBubble:weakSelf z:10];
        } interval:1.0 repeat:kCCRepeatForever delay:0.5];
        isFirstTime = true;
        /**
        CGFloat scale = [UIScreen mainScreen].scale;
        NSArray* coords = @[[[EZCoord alloc] init:2 y:2], [[EZCoord alloc] init:3 y:3]];
        UIImage* board = [EZChess2Image generateOrgBoard:coords];//[EZChess2Image generateAdjustedBoard:coords size:CGSizeMake(130*scale, 130*scale)];
        [_tableView addSubview:[[UIImageView alloc] initWithImage:board]];
         EZDEBUG(@"Added generated table:%@, scale:%f", NSStringFromCGSize(board.size), board.scale);
        **/
        //[self loadEpisode];
        //[self startDownload];
    }
    return self;
}

//List all available Fonts on iOS.

- (void) onEnter
{
    [super onEnter];
    //if(![[EZSoundManager sharedSoundManager] isBackgrondPlaying]){
    //    [[EZSoundManager sharedSoundManager] playBackgroundTrack:@"background.mp3"];
    //}
    [[CCDirector sharedDirector].view addSubview:_tableView];
    //if(!isFirstTime){
    //[self reloadEpisode];
    [self scrollViewDidScroll:_tableView];
    //}
    isFirstTime = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadedEpisode:) name:EpisodeDownloadDone object:nil];
}

- (void) onExit
{
    [super onExit];
    //[[EZSoundManager sharedSoundManager]stopBackground];
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

//Actually, I can cover the functionality of the old one.
- (void) reloadEpisode
{
    int previousRow = [self currentRows];
    int previousEpisodes = _recentEpisodes;
    
    _recentEpisodes = [[EZCoreAccessor getClientAccessor] count:[EZEpisode class]];
    int curRow = [self currentRows];
    
    if(previousEpisodes == _recentEpisodes){
        EZDEBUG(@"no increased episodes, quit");
        return;
    }
    EZDEBUG(@"previousEpisode:%i, currentEpisode:%i, currentRow:%i, previousRow:%i",previousEpisodes, _recentEpisodes, curRow, previousRow);
    if(curRow > previousRow){
        NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:curRow - previousRow];
        for(int i = previousRow; i < curRow; i++){
            NSIndexPath* ipath = [NSIndexPath indexPathForRow:i inSection:0];
            CGRect irect = [_tableView rectForRowAtIndexPath:ipath];
            EZDEBUG(@"added-row:%i, %@",i, NSStringFromCGRect(irect));
            [arr addObject:ipath];
        }
        
        [_tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
        
    }else{
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(curRow - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void) showEpisode:(EZEpisodeVO*)epv
{
    [self scrollViewDidScroll:_tableView];
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
