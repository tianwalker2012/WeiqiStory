//
//  EZListEditPage.h
//  WeiqiStory
//
//  Created by xietian on 12-11-13.
//
//

#import "cocos2d.h"


@class EZLRUMap;
@interface EZListEditPage : CCLayer<UITableViewDataSource, UITableViewDelegate>

+ (CCScene*) scene;

@property (nonatomic, strong) NSMutableDictionary* dirtyFlags;

//@property (nonatomic, strong) EZLRUMap* episodeMap;

//Last episode updated from Database
//Will updated if recieved notification
//@property (nonatomic, assign) NSInteger recentEpisodes;

@end
