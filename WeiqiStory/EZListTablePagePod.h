//
//  EZListTablePagePod.h
//  WeiqiStory
//
//  Created by xietian on 12-11-21.
//
//

#import "EZLayer.h"
#import "cocos2d.h"

@class EZLRUMap;
//What do we need for this class?
//
@interface EZListTablePagePod : EZLayer<UITableViewDelegate, UITableViewDataSource>

+ (CCScene*) scene;


@property (nonatomic, strong) NSMutableDictionary* dirtyFlags;

@property (nonatomic, strong) EZLRUMap* episodeMap;

//Last episode updated from Database
//Will updated if recieved notification
@property (nonatomic, assign) NSInteger recentEpisodes;


@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;
//@property (nonatomic, strong) NSArray* episodes;

@end
