//
//  EZSmallPanel.h
//  WeiqiStory
//
//  Created by xietian on 12-10-30.
//
//

#import "CCLayer.h"

@interface EZImage : NSObject

@property (nonatomic, strong) UIImage* image;

//The bigger value will cover the smaller value.
@property (nonatomic, assign) NSInteger zOrder;

@property (nonatomic, assign) CGRect rect;

//Whether flip it or not when draw it to the screen.
//Which image can determine by itself.
//The board should not be flipped, this for sure. 
@property (nonatomic, assign) BOOL flip;

- (id) initWithImage:(UIImage*)image rect:(CGRect)rect z:(NSInteger)z flip:(BOOL)flip;

- (id) initWithImage:(UIImage*)image point:(CGPoint)point z:(NSInteger)z;

- (id) initWithImage:(UIImage*)image point:(CGPoint)point z:(NSInteger)z flip:(BOOL)flip;



@end


@interface EZImageView : UIView

@property (readonly, strong) NSMutableArray* images;

//will start with the image of this view.
- (id) initWithImage:(UIImage*)image;


- (id) initWithImage:(UIImage*)image position:(CGPoint)pos;

//Will locate at specified position, will stretch the image to fit.
- (void) addImage:(UIImage*)image rect:(CGRect)rect z:(NSInteger)z;

- (void) addImage:(UIImage *)image position:(CGPoint)pos z:(NSInteger)z;

- (void) addEZImage:(EZImage*)image;

//Will locate a 0,0, with zOrder zero.
- (void) addImage:(UIImage *)image;


//What's the purpose of this method
//Store the whole thing as a image.
- (UIImage*) outputAsImage;

@end
