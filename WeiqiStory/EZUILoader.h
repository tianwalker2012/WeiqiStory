//
//  EZUILoader.h
//  WeiqiStory
//
//  Created by xietian on 12-10-17.
//
//

#import <Foundation/Foundation.h>
#import "EZEpisodeCell.h"
#import "EZEpisodeEditor.h"

//Why do I need this class?
//It is a similiar class as CellHolder, all the customized cell will be load from Nib my me, which is great.
//I love this. 
@interface EZUILoader : NSObject

@property (nonatomic, strong) IBOutlet EZEpisodeCell* episodeCell;
@property (nonatomic, strong) IBOutlet EZEpisodeEditor* episodeEditor;

+ (EZEpisodeCell*) createEpisodeCell;


+ (EZEpisodeEditor*) createEditor;

@end
