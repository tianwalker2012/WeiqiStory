//
//  EZBackground.m
//  WeiqiStory
//
//  Created by xietian on 13-1-3.
//
//

#import "EZBackground.h"
#import "EZConstants.h"
#import "EZExtender.h"
#import "cocos2d.h"
#import "EZFileUtil.h"

@implementation EZBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
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

- (id) initWithHeader:(NSString*)header body:(NSString*)body tail:(NSString*)tail
{
    self = [super init];
    _header = [[UIImageView alloc] initWithImage:[EZFileUtil imageFromFile:header scale:[UIScreen mainScreen].scale]];
    [_header setPosition:ccp(0, 0)];
    
    _tail = [[UIImageView alloc ] initWithImage:[EZFileUtil imageFromFile:tail scale:[UIScreen mainScreen].scale]];
    [_tail setPosition:ccp(0, _body.bounds.size.height - _tail.bounds.size.height)];
    //assume the body occupy the whole view
    _body = [[UIImageView alloc] initWithImage:[EZFileUtil imageFromFile:body scale:[UIScreen mainScreen].scale]];
    self.frame = CGRectMake(0, 0, _body.bounds.size.width, _header.bounds.size.height+_body.bounds.size.height+_tail.bounds.size.height);

    [_body setPosition:ccp(0, _header.bounds.size.height)];
    [self addSubview:_body];
    [self addSubview:_header];
    [self addSubview:_tail];
    self.clipsToBounds = true;
    return self;
}

- (void) layoutSubviews{
    EZDEBUG(@"layoutSubViews:%@", [NSThread callStackSymbols]);
    EZDEBUG(@"Current bounds:%@", NSStringFromCGRect(self.bounds));
    [super layoutSubviews];
    //I assume the bounds already change. 
    //_body.frame = CGRectMake(0, 0, _body.bounds.size.width,  _body.frame.size.height - _header.bounds.size.height - _tail.bounds.size.height);
    _body.frame = CGRectMake(0, 0, _body.bounds.size.width, self.bounds.size.height - _header.bounds.size.height - _tail.bounds.size.height);
    [_body setPosition:ccp(0, _header.bounds.size.height)];
    [_tail setPosition:ccp(0, self.bounds.size.height - _tail.bounds.size.height)];
    
}

@end
