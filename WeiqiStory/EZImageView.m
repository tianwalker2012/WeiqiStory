//
//  EZSmallPanel.m
//  WeiqiStory
//
//  Created by xietian on 12-10-30.
//
//

#import "EZImageView.h"
#import "EZConstants.h"
#import "EZChess2Image.h"

@implementation EZImage

- (id) initWithImage:(UIImage*)image rect:(CGRect)rect z:(NSInteger)z
{
    self = [super init];
    _image = image;
    _rect = rect;
    _zOrder = z;
    
    return self;
}

- (id) initWithImage:(UIImage*)image point:(CGPoint)point z:(NSInteger)z
{
   return [self initWithImage:image rect:CGRectMake(point.x,point.y,image.size.width, image.size.height) z:z];
}

@end

@implementation EZImageView

//will start with the image of this view.
- (id) initWithImage:(UIImage*)image
{
    return [self initWithImage:image position:CGPointMake(0, 0)];
}

- (id) initWithImage:(UIImage*)image position:(CGPoint)pos
{
    self = [super initWithFrame:CGRectMake(pos.x, pos.y, image.size.width, image.size.height)];
    self.clipsToBounds = TRUE;
    _images = [[NSMutableArray alloc] init];
    image = [EZChess2Image flipImage:image];
    [_images addObject:[[EZImage alloc] initWithImage:image rect:CGRectMake(0, 0, image.size.width, image.size.height) z:0]];
    //This may not be necessary, anyway do no harm, right?
    //[self setNeedsDisplay];
    return self;
}

- (void) addEZImage:(EZImage*)image
{
    image.image = [EZChess2Image flipImage:image.image];
    [_images addObject:image];
    [_images sortUsingComparator:^(EZImage* img1, EZImage* img2){
        return img1.zOrder - img2.zOrder;
    }];
    [self setNeedsDisplay];
}

- (void) addImage:(UIImage *)image position:(CGPoint)pos z:(NSInteger)z
{
    [self addImage:image rect:ezrect(pos.x, pos.y, image.size.width, image.size.height) z:z];
}

//Will locate at specified position, will stretch the image to fit.
- (void) addImage:(UIImage*)image rect:(CGRect)rect z:(NSInteger)z;
{
    [self addEZImage:[[EZImage alloc] initWithImage:image rect:rect z:z]];
    
}
//Will locate a 0,0, with zOrder zero.
- (void) addImage:(UIImage *)image
{
    [self addImage:image rect:CGRectMake(0, 0, image.size.width, image.size.height) z:0];
}

- (void) drawRect:(CGRect)rect
{
    
    EZDEBUG(@"Begin draw the images");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    //CGContextScaleCTM(ctx, 1, -1);
    for(EZImage* image in _images){
        CGRect rect = image.rect;
        //rect.origin.y = self.bounds.size.height - rect.origin.y;
        CGContextDrawImage(ctx, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height), image.image.CGImage);
    }
}

@end
