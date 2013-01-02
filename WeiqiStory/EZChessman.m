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

//I assume this is a cube.
//So make it as simple as possible.
- (NSArray*) calculateTriangle:(CGRect)box
{
    CGFloat length = box.size.height;
    box.origin.x -= 400;
    //Mean 60 degree
    CGFloat angel = M_PI/6;
    CGFloat cosLength = cosf(angel) * length;
    CGFloat shift = (length - cosLength)*0.5;
    
    CGFloat highY = shift + cosLength;
    
    return @[[NSValue valueWithCGPoint:ccp(box.origin.x, box.origin.y + shift)], [NSValue valueWithCGPoint:ccp(box.origin.x+ length*0.5, box.origin.y + highY)], [NSValue valueWithCGPoint:ccp(box.origin.x + length, box.origin.y + shift)]];
    
}


- (void) drawOld
{
    //glEnable(GL_LINE_SMOOTH);
    glLineWidth(4);
    
    NSArray* points = [self calculateTriangle:self.boundingBox];
    
    EZDEBUG(@"BoundingBox is:%@", NSStringFromCGRect(self.boundingBox));
    
    NSValue* nv = [points objectAtIndex:0];
    CGPoint firstP = [nv CGPointValue];
    
    for(NSValue* val in points){
        if(nv != val){
            CGPoint startP = [nv CGPointValue];
            CGPoint endP = [val CGPointValue];
            ccDrawLine(startP, endP);
            nv = val;
        }
    }
    
    CGPoint last = [nv CGPointValue];
    ccDrawLine(last, firstP);
    [super draw];
    
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
            //CGFloat adjustedFontSize = (step>9)?((step>99)?18:20):25;
            //if(self.contentSize.width > 30){
            CGFloat baseSize = self.contentSize.width;
            CGFloat adjustedFontSize = (step>9)?((step>99)?baseSize*0.5:baseSize*0.65):baseSize*0.9;
            //}
            EZDEBUG(@"Number Content Size:%@, adjusted font size:%f",NSStringFromCGSize(self.contentSize), adjustedFontSize);
            
            //if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            //    adjustedFontSize = adjustedFontSize * 5 / 9;
           // }
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
