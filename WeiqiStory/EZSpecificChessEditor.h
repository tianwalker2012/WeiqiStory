//
//  EZSpecificChessEditor.h
//  WeiqiStory
//
//  Created by xietian on 12-12-18.
//
//

#import "cocos2d.h"

//What's the purpose of this class?
//It is a specialized editor, the purpose if to fix a particular action in a episode.


@class EZEpisodeVO;
@interface EZSpecificChessEditor : CCLayer

+ (CCScene*) scene;


- (CCScene*) createScene;

- (id) initWithEpisode:(EZEpisodeVO*)epv playedPos:(NSInteger)pos;

@property (nonatomic, strong) EZEpisodeVO* currentEpisode;
@property (nonatomic, assign) NSInteger removedPos;
@property (nonatomic, strong) NSMutableArray* changedActions;

@end
