//
//  EZListTablePage.h
//  WeiqiStory
//
//  Created by xietian on 12-11-7.
//
//

#import "cocos2d.h"

@interface EZListTablePage : CCLayer<UITableViewDelegate, UITableViewDataSource>

+ (CCScene*) scene;


@property (nonatomic, strong) NSMutableDictionary* dirtyFlags;

@end
