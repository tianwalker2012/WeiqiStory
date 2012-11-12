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

@interface EZListTablePage()
{
    //EZUIViewWrapper* scrollWrapper;
    //UIScrollView* scroll;
    UITableView* _tableView;
    NSMutableArray* _episodes;
    
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


- (void) loadAllFromBundle
{
    EZEpisodeDownloader* downloader = [[EZEpisodeDownloader alloc] init];
    downloader.baseURL = ((NSURL*)[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@""]]).absoluteString;
    //[downloader downloadEpisode:fileURL completeBlock:nil];
    [downloader downloadAccordingToList:[EZFileUtil fileToURL:@"episode-small.lst"]];
     
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168+17;
}


- (NSInteger) currentRows
{
    int row = _episodes.count / 4;
    int col = _episodes.count % 4;
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
        if([view.class isSubclassOfClass:[EZSimpleImageView class]]){
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
    if(endPos > _episodes.count){
        endPos = _episodes.count;
    }
    
    //int col = (indexPath.ro-1) % 4;
    
    CGFloat widthGap = 45;
    CGFloat panelWidth = 142;
    EZDEBUG(@"current row %i, will add item:%i",indexPath.row, (endPos - startPos));
    for(int i = startPos; i < endPos; i++){
        CGFloat xPos = (widthGap + panelWidth) * (i - startPos);
        
        EZEpisodeVO* epv = [_episodes objectAtIndex:i];
        if(!epv.completeBoard){
            EZBoardPanel* panel = [[EZBoardPanel alloc] initWithEpisode:epv];
            epv.completeBoard = [panel outputAsImage];
        }
        
        EZImageView* orgView = [[EZImageView alloc] initWithImage:epv.completeBoard];
        [orgView setPosition:ccp(300, 400)];
        [tableView addSubview:orgView];
        
        EZDEBUG(@"The completeBoard size:%@", NSStringFromCGSize(epv.completeBoard.size));
        EZSimpleImageView* imageView = [[EZSimpleImageView alloc] initWithImage:epv.completeBoard];
        //EZBoardPanel* panel = [cell.panels objectForKey:NSStringFromCGPoint(position)];
        
        [imageView setPosition:ccp(xPos, 0)];
        imageView.tappedBlock = ^(){
                EZDEBUG(@"The episode %@ get tapped", epv.name);
                EZPlayPage* playPage = [[EZPlayPage alloc] initWithEpisode:epv];
                [_tableView removeFromSuperview];
                [[CCDirector sharedDirector] pushScene:[playPage createScene]];
                [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            };
            
        [cell addSubview:imageView];
        
    }
    //UIView* testHide =  [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    //testHide.backgroundColor = [UIColor redColor];
    //[cell addSubview:testHide];
    //[self refreshView:cell];
    return cell;
}

//When could I reuse the cells?
- (UITableViewCell *)tableViewOld:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EZTableViewCell* cell = nil; //= (EZTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        EZDEBUG(@"dequeue invisible cell");
        cell = [tableView dequeueReusableCellWithIdentifier:@"smallboard"];
    }else{
        EZDEBUG(@"Find a visible Cell, for index:%i", indexPath.row);
    }
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
    if(endPos > _episodes.count){
        endPos = _episodes.count;
    }

    //int col = (indexPath.ro-1) % 4;
    
    CGFloat widthGap = 45;
    CGFloat panelWidth = 142;
    EZDEBUG(@"current row %i, will add item:%i",indexPath.row, (endPos - startPos));
    for(int i = startPos; i < endPos; i++){
        CGFloat xPos = (widthGap + panelWidth) * (i - startPos);
        
        CGPoint position = ccp(xPos, 0);
        
        
        EZEpisodeVO* epv = [_episodes objectAtIndex:i];
        EZBoardPanel* panel = [cell.panels objectForKey:NSStringFromCGPoint(position)];
        
        if(![_dirtyFlags objectForKey:[NSString stringWithFormat:@"%i",i]] || ![cell isIndexExist:ccp(i, xPos)]){
            //[_dirtyFlags setValue:@"" forKey:[NSString stringWithFormat:@"%i",i]];
            //[cell addIndex:ccp(i, xPos)];
            EZDEBUG(@"start update panel:%@, at position:%@", epv.name, NSStringFromCGPoint(position));
            if(!panel){
                panel = [[EZBoardPanel alloc] initWithEpisode:epv];
                [panel setPosition:ccp(xPos, 0)];
                [cell.panels setValue:panel forKey:NSStringFromCGPoint(position)];
            }else{
                EZDEBUG(@"Reuse the panel, name:%@ for %@ position:%@", panel.name.text, epv.name, NSStringFromCGPoint(position));
                [panel updateWithEpisode:epv];
            }
            //panel.name.text = [NSString stringWithFormat:@"%@:%i, xPos:%f", epv.name, i, xPos];
            //panel.intro.text = epv.introduction;
            
            panel.tappedBlock = ^(){
                EZDEBUG(@"The episode %@ get tapped", epv.name);
                EZPlayPage* playPage = [[EZPlayPage alloc] initWithEpisode:epv];
                [_tableView removeFromSuperview];
                [[CCDirector sharedDirector] pushScene:[playPage createScene]];
                [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            };

        }else if([cell isIndexExist:ccp(i, xPos)]){
            EZDEBUG(@"%@:panel is exist and not dirty, let's relax, panel name:%@", epv.name, panel.name.text);
        }
        
               
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
        
        
        CCSprite* smallBoard = [CCSprite spriteWithFile:@"small-board.png"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:smallBoard.displayFrame name:@"small-board.png"];
        [self addTableView];
        _episodes = [[NSMutableArray alloc] init];
        
        //Download the source from the server
        //[self startDownload];
        [self loadAllFromBundle];
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
    [_episodes addObject:epv];
    
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
    [self  executeBlockInMainThread:^(){
        [self showEpisode:episode];
        
    }];
}


@end
