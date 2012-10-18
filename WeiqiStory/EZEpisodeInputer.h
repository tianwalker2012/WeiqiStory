//
//  EZEpisodeInputer.h
//  WeiqiStory
//
//  Created by xietian on 12-10-4.
//
//

#import <UIKit/UIKit.h>
#import "EZConstants.h"

@interface EZEpisodeInputer : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton* confirm;
@property (strong, nonatomic) IBOutlet UIButton* cancel;

@property (strong, nonatomic) IBOutlet UITextField* name;
@property (strong, nonatomic) IBOutlet UITextView* description;

@property (strong, nonatomic) EZEventBlock confirmBlock;

@property (strong, nonatomic) EZEventBlock cancelBlock;

- (IBAction) cancelClicked:(id)sender;

- (IBAction) saveClicked:(id)sender;


@end
