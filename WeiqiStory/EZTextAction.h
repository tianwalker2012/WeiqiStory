//
//  EZTextAction.h
//  WeiqiStory
//
//  Created by xietian on 12-12-25.
//
//

#import <Foundation/Foundation.h>
#import "EZAction.h"

//What's the purpos of this class?
//This class is to show some text to user,
//Just keep a mockup so that later I will figure out how to do thing.
//I guess,
//I may invoke some animation to trigger the focus from user.
//But, this is ok, let's gradually evolve it.
//Both the C and N type will be display by this.
//The only difference is the time, right?

//Why I come up with the popup ideas?
//User are focusing on the ChessBoard, so you should have some animation to illustrate that.
typedef enum {
    kStoneComment,//The difference between these 2 is that, one is for the particular chess move
    kStatusComment//This is for the current status
}EZTextType;

@interface EZTextAction : EZAction

@property (nonatomic, strong) NSString* text;

@property (nonatomic, strong) NSString* prevText;

@property (nonatomic, assign) EZTextType type;

@end
