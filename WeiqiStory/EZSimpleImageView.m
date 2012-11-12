//
//  EZSimpleImageView.m
//  WeiqiStory
//
//  Created by xietian on 12-11-12.
//
//

#import "EZSimpleImageView.h"

@implementation EZSimpleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.contentScaleFactor = [UIScreen mainScreen].scale;
    }
    return self;
}

- (id) initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    //self.contentScaleFactor = [UIScreen mainScreen].scale;
    UIGestureRecognizer* guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:guesture];
    return self;
}


//Use guesturer recognizer.
//Why not use the raw event?
//Let's experiment.
- (void) tapped:(id) sender
{
    EZDEBUG(@"Tapped");
    if(_tappedBlock){
        _tappedBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
