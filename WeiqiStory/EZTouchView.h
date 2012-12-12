//
//  EZTouchView.h
//  WeiqiStory
//
//  Created by xietian on 12-12-12.
//
//

#import <UIKit/UIKit.h>
#import "EZConstants.h"

//Why do I need this?
//I simply need a touch enabled view, so that I could be conviniently create any kind of button I need
@interface EZTouchView : UIView

@property (nonatomic, strong) EZOperationBlock touchBlock;

@end
