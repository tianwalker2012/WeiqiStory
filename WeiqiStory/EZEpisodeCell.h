//
//  EZEpisodeCell.h
//  WeiqiStory
//
//  Created by xietian on 12-10-17.
//
//

#import <UIKit/UIKit.h>

@interface EZEpisodeCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* name;

@property (strong, nonatomic) IBOutlet UITextView* introduces;

@property (strong, nonatomic) IBOutlet UIImageView* thumbNail;

@end
