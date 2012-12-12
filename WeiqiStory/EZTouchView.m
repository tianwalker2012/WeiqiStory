//
//  EZTouchView.m
//  WeiqiStory
//
//  Created by xietian on 12-12-12.
//
//

#import "EZTouchView.h"

@implementation EZTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    EZDEBUG(@"TouchView begin");
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_touchBlock){
        _touchBlock();
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
