//
//  EZBackground.h
//  WeiqiStory
//
//  Created by xietian on 13-1-3.
//
//

#import <UIKit/UIKit.h>

@interface EZBackground : UIView


- (id) initWithHeader:(NSString*)header body:(NSString*)body tail:(NSString*)tail;

@property (nonatomic, strong) UIImageView* header;
@property (nonatomic, strong) UIImageView* body;
@property (nonatomic, strong) UIImageView* tail;

@end
