//
//  EZEpisodeInputer.m
//  WeiqiStory
//
//  Created by xietian on 12-10-4.
//
//

#import "EZEpisodeInputer.h"
#import "EZConstants.h"

@interface EZEpisodeInputer ()

@end

@implementation EZEpisodeInputer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) awakeFromNib
{
    EZDEBUG(@"Awake from Nib");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) cancelClicked:(id)sender
{
    //[self.presentingViewController dismissModalViewControllerAnimated:YES];
    EZDEBUG(@"Cancel clicked");
    if(_cancelBlock){
        _cancelBlock(self);
    }
}

- (IBAction) saveClicked:(id)sender
{
    EZDEBUG(@"Save clicked");
    if(_confirmBlock){
        _confirmBlock(self);
    }
}

#pragma marks textField delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    EZDEBUG(@"Should EndEditing");
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    EZDEBUG(@"textFieldDidEndEditing get called");
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    EZDEBUG(@"Should clear get called");
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    EZDEBUG("Should return get called");
    return true;
}


#pragma marks textView delegate

//When this will get called.
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    EZDEBUG(@"shouldEndEditing");
    return true;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    EZDEBUG(@"didEndEditing");
}


- (void)textViewDidChangeSelection:(UITextView *)textView
{
    EZDEBUG(@"didChange Seletion get called");
}

@end
