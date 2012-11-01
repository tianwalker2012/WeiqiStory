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


- (id) initWithCoords:(NSArray*)coords
{
    
    self = [super initWithImage:[UIImage imageNamed:@"small-board"]];
    EZImage* chessImage =[[EZImage alloc] initWithImage:[EZChess2Image generateAdjustedBoard:coords size:CGSizeMake(130, 130)] point:ccp(6,6) z:2];
    
    EZImage* chessFrame = [[EZImage alloc] initWithImage:[UIImage imageNamed:@"small-board-frame"] point:ccp(5, 5) z:3];
    
    [self addEZImage:chessFrame];
    [self addEZImage:chessImage];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(10, 142, 70, 25)];
    _name.backgroundColor = [UIColor clearColor];
    _name.font = [UIFont fontWithName:@"Adobe Kaiti Std" size:14];
    //label.text = [NSString stringWithFormat:@"第%i讲", _episodes.count];
    _name.textColor = [UIColor whiteColor];
    
    _intro = [[UILabel alloc] initWithFrame:CGRectMake(92, 142, 50, 25)];
    _intro.backgroundColor = [UIColor clearColor];
    _intro.font = [UIFont fontWithName:@"Adobe Kaiti Std" size:14];
    _intro.textColor = [UIColor whiteColor];
    [self addSubview:_name];
    [self addSubview:_intro];
    UIGestureRecognizer* guesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:guesture];
    return self;
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
