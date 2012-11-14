//
//  EZListEditPage.m
//  WeiqiStory
//
//  Created by xietian on 12-11-13.
//
//

#import "EZListEditPage.h"
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
#import "EZLRUMap.h"
#import "EZEditPage.h"
#import "EZUploader.h"
#import "EZEpisodeUploader.h"

@interface EZListEditPage()
{
    //EZUIViewWrapper* scrollWrapper;
    //UIScrollView* scroll;
    UITableView* _tableView;
    NSMutableArray* _episodes;
    
    //It is there mean not dirty.
    //Not exist mean dirty
    NSMutableDictionary* dict;
    EZEpisodeUploader* uploader;
}

@end

@implementation EZListEditPage

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZListEditPage *layer = [EZListEditPage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}


- (void) loadAllFromBundle
{
    EZEpisodeDownloader* downloader = [[EZEpisodeDownloader alloc] init];
    downloader.baseURL = ((NSURL*)[NSURL fileURLWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@""]]).absoluteString;
    //[downloader downloadEpisode:fileURL completeBlock:nil];
    [downloader downloadAccordingToList:[EZFileUtil fileToURL:@"episode.lst"]];
    
}

/**
 - (void) loadFromCoreDB
 {
 NSArray* eps = [[EZCoreAccessor getClientAccessor] fetchAll:[EZEpisode class] sortField:nil];
 EZDEBUG(@"Total size is:%i", eps.count);
 for(EZEpisode* episode in eps){
 EZEpisodeVO* epv = [[EZEpisodeVO alloc] initWithPO:episode];
 [_episodes addObject:epv];
 }
 
 }
 **/
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


- (NSInteger) totalEpisodes
{
    return [[EZCoreAccessor getClientAccessor] count:[EZEpisode class]];
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
        
        EZEpisodeVO* epv = [self getEpisode:i];
        
        if(epv.thumbNail == nil){
            epv.thumbNail = [EZImageView generateSmallBoard:epv.basicPattern];
        }
        
        EZBoardPanel* panel = [[EZBoardPanel alloc] initWithEpisode:epv];
        panel.userInteractionEnabled = true;
        EZDEBUG(@"The completeBoard size:%@", NSStringFromCGSize(epv.completeBoard.size));
        
        [panel setPosition:ccp(xPos, 0)];
        panel.tappedBlock = ^(){
            EZDEBUG(@"The episode %@ get tapped", epv.name);
            [[EZSoundManager sharedSoundManager] playSoundEffect:sndButtonPress];
            EZEditPage* editPage = [[EZEditPage alloc] initWithEpisode:epv];
            
            editPage.deletedEpisode = ^(){
                //It may cause some issue if data removed
                EZDEBUG(@"Will remove data");
                [_episodes removeObjectAtIndex:i];
                [tableView reloadData];
            };
            
            editPage.savedEpisode = ^(){
                EZDEBUG(@"Will save the episode to database");
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            
            [_tableView removeFromSuperview];
            [[CCDirector sharedDirector] pushScene:[editPage createScene]];
            
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



- (EZEpisodeVO*) getEpisode:(NSInteger)pos
{
    EZEpisodeVO* res = [_episodes objectAtIndex:pos];
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
        NSArray* arr = [[EZCoreAccessor getClientAccessor] fetchAll:[EZEpisode class] sortField:nil];
        
        _episodes = [[NSMutableArray alloc] initWithCapacity:arr.count];
        for(EZEpisode* ep in arr){
            [_episodes addObject:[[EZEpisodeVO alloc] initWithPO:ep]];
        }
        
        
        CCMenu* uploadButton = [CCMenu menuWithItems:[CCMenuItemFont itemWithString:@"Upload all"
        block:^(id sender){
            EZDEBUG(@"Will upload all, count:%i", _episodes.count);
            //What I need to do here?
            //Change all the episode names.
            //removed the generated board image.
            //Then upload.
            for(int i = 0; i < _episodes.count; i++){
                EZEpisodeVO* epv = [_episodes objectAtIndex:i];
                NSString* name = [epv.name substringToIndex:2];
                //NSString* finalName = [NSString stringWithFormat:@"第%i题:%@",i+1, name];
                EZDEBUG(@"FinalName: %@", name);
                epv.name = name;
                epv.completeBoard = nil;
            }
            uploader = [[EZEpisodeUploader alloc] init];
            [uploader uploadOnlyEpisodes:_episodes];
            
        }], nil];
        
        uploadButton.position = ccp(60, 960);
        [self addChild:uploadButton z:10];
        EZDEBUG(@"Added the upload button");
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


@end

