//
//  EZEpisodeEditor.m
//  WeiqiStory
//
//  Created by xietian on 12-11-13.
//
//

#import "EZEpisodeEditor.h"

@implementation EZEpisodeEditor

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) deleteAct:(id)sender
{
    if(_deleteClicked){
        _deleteClicked();
    }
}

- (void) saveAct:(id)sender
{
    if(_saveClicked){
        _saveClicked();
    }
}

@end
