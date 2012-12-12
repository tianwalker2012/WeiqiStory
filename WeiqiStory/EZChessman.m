//
//  EZChessman.m
//  WeiqiStory
//
//  Created by xietian on 12-9-19.
//
//

#import "EZChessman.h"
#import "EZConstants.h"

@interface EZChessman()
{
    CCLabelTTF* numberText;
}

@end

@implementation EZChessman
@synthesize showStep, step, isBlack, showedStep;

- (EZChessman*) initWithFile:(NSString*)imgFile step:(NSInteger)stp showStep:(BOOL)show isBlack:(BOOL)black
{
    self = [super initWithFile:imgFile];
    if(self){
        step = stp;
        showedStep = stp;
        self.isBlack = black;
        self.showStep = show;
    }
    return self;
}

- (EZChessman*) initWithSpriteFrameName:(NSString*)imgFile step:(NSInteger)stp showStep:(BOOL)show isBlack:(BOOL)black
{
    self = [self initWithSpriteFrameName:imgFile step:stp showStep:show isBlack:black showedStep:stp];
    return self;
}

- (EZChessman*) initWithSpriteFrameName:(NSString*)imgFile step:(NSInteger)stp showStep:(BOOL)show isBlack:(BOOL)black  showedStep:(NSInteger)showStp
{
    self = [super initWithSpriteFrameName:imgFile];
    if(self){
        step = stp;
        showedStep = showStp;
        self.isBlack = black;
        self.showStep = show;
    }
    return self;

}

- (void) setShowStep:(BOOL)show
{
    if(numberText){
        //Release the memory as soon as possible
        EZDEBUG(@"Will remove the old text");
        //[numberText removeAllChildrenWithCleanup:YES];
        [numberText removeFromParentAndCleanup:YES];
        numberText = nil;
    }
    if(show){
        if((showedStep+1)>0){
            CGRect boundBox = self.boundingBox;
            EZDEBUG(@"Will show the text:%@, color:%@, step:%i", NSStringFromCGRect(boundBox), isBlack?@"black":@"white", step);
            CGFloat adjustedFontSize = (step>9)?((step>99)?18:20):25;
            if(self.contentSize.width > 30){
                adjustedFontSize = (step>9)?((step>99)?36:40):50;
            }
            EZDEBUG(@"Number Content Size:%@, adjusted font size:%f",NSStringFromCGSize(self.contentSize), adjustedFontSize);
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                adjustedFontSize = adjustedFontSize * 5 / 9;
            }
            numberText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",showedStep+1] fontName:@"Arial" fontSize:adjustedFontSize];
            //I assume the default color is White
            if(!isBlack){
                numberText.color = ccc3(0,0,0);
            }
            numberText.position = ccp(boundBox.size.width/2, boundBox.size.height/2);
            [self addChild:numberText];
        }
    }
    
    showStep = show;
}

@end
