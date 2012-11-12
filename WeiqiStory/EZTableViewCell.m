//
//  EZTableViewCell.m
//  WeiqiStory
//
//  Created by xietian on 12-11-8.
//
//

#import "EZTableViewCell.h"

@implementation EZTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _panels = [[NSMutableDictionary alloc] init];
        _currentIndexs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

//For get about the position
//Mean not support the insert yet.
- (BOOL) isIndexExist:(CGPoint)pos
{
    NSString* key = [NSString stringWithFormat:@"%f", pos.x];
    NSNumber* value = [_currentIndexs objectForKey:key];
    if(value && value.floatValue == pos.y){
        return YES;
    }
    return NO;
}

- (void) addIndex:(CGPoint)pos
{
    NSString* key = [NSString stringWithFormat:@"%f", pos.x];
    [_currentIndexs setValue:@(pos.y) forKey:key];
}

@end
