//
//  EZListTablePage.h
//  WeiqiStory
//
//  Created by xietian on 12-11-7.
//
//

#import "cocos2d.h"
#import "EZLRUMap.h"

@interface EZListTablePage : CCLayer<UITableViewDelegate, UITableViewDataSource>

+ (CCScene*) scene;


@property (nonatomic, strong) NSMutableDictionary* dirtyFlags;

@property (nonatomic, strong) EZLRUMap* episodeMap;

//Last episode updated from Database
//Will updated if recieved notification
@property (nonatomic, assign) NSInteger recentEpisodes;
//@property (nonatomic, strong) NSArray* episodes;

@end
