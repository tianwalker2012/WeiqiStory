//
//  EZBoardPanel.m
//  WeiqiStory
//
//  Created by xietian on 12-10-30.
//
//

#import "EZBoardPanel.h"
#import "EZChess2Image.h"
#import "cocos2d.h"
#import "EZEpisodeVO.h"
#import "EZFileUtil.h"
#import "EZChess2Image.h"

@implementation EZBoardPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
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

- (void) updateWithEpisode:(EZEpisodeVO*)epv
{
    if(!epv.thumbNail){
        epv.thumbNail = [EZImageView generateSmallBoard:epv.basicPattern];
    }
    self.image = epv.thumbNail;

    _name.text =  epv.name;
    _intro.text = epv.introduction;
}


- (id) initWithEpisode:(EZEpisodeVO*) epv
{
    
    //self = [super initWithImage:[EZFileUtil imageFromFile:@"small-board.png"]];
    //CGFloat scale = [UIScreen mainScreen].scale;
    self = [super initWithImage:epv.thumbNail];
    self.userInteractionEnabled = true;
    _name = [[UILabel alloc] initWithFrame:CGRectMake(10, 142, 100, 25)];
    _name.backgroundColor = [UIColor clearColor];
    _name.font = [UIFont fontWithName:@"Adobe Kaiti Std" size:14];
    _name.textColor = [UIColor whiteColor];
    _name.text = epv.name;
    [self addSubview:_name];
    
    _intro = [[UILabel alloc] initWithFrame:CGRectMake(92, 142, 50, 25)];
    _intro.backgroundColor = [UIColor clearColor];
    _intro.font = [UIFont fontWithName:@"Adobe Kaiti Std" size:14];
    _intro.textColor = [UIColor whiteColor];
    _intro.text = epv.introduction;
    [self addSubview:_intro];
    
    //EZImage* chessImage = nil;
    //[self updateWithEpisode:epv];
    UIGestureRecognizer* guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:guesture];
    return self;
}

//Get touched
/**
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"Touch ended");
    if(_tappedBlock){
        _tappedBlock();
    }
}
 **/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/**
- (UIImage*) outputAsImage
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,YES,scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for(EZImage* image in self.images){
        CGRect rect = image.rect;
        //rect.origin.y = self.bounds.size.height - rect.origin.y;
        EZDEBUG(@"images rect:%@", NSStringFromCGRect(rect));
        CGContextDrawImage(ctx, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width/scale, rect.size.height/scale), image.image.CGImage);
    }
    //[_name.layer drawInContext:ctx];
    //[_intro.layer drawInContext:ctx];
    UIImage* res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    EZDEBUG(@"Final image size:%@", NSStringFromCGSize(res.size));
    return res;

}
**/
@end
