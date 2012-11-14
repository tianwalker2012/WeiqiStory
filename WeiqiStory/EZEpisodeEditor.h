//
//  EZEpisodeEditor.h
//  WeiqiStory
//
//  Created by xietian on 12-11-13.
//
//

#import <UIKit/UIKit.h>
#import "EZConstants.h"

@interface EZEpisodeEditor : UIView

@property (nonatomic, strong) IBOutlet UILabel* nameTitle;
@property (nonatomic, strong) IBOutlet UILabel* introTitle;
@property (nonatomic, strong) IBOutlet UITextField* name;
@property (nonatomic, strong) IBOutlet UITextField* intro;

@property (nonatomic, strong) IBOutlet UIButton* saveBtn;
@property (nonatomic, strong) IBOutlet UIButton* deleteBtn;

@property (nonatomic, strong) EZOperationBlock saveClicked;
@property (nonatomic, strong) EZOperationBlock deleteClicked;

- (IBAction) deleteAct:(id)sender;

- (IBAction) saveAct:(id)sender;

@end
