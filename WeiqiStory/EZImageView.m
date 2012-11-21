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
#import "EZFileUtil.h"
#import "cocos2d.h"

@implementation EZImage

- (id) initWithImage:(UIImage*)image rect:(CGRect)rect z:(NSInteger)z flip:(BOOL)flip
{
    self = [super init];
    _image = image;
    _rect = rect;
    _zOrder = z;
    _flip = flip;
    return self;
}

- (id) initWithImage:(UIImage*)image point:(CGPoint)point z:(NSInteger)z flip:(BOOL)flip
{
    return [self initWithImage:image rect:CGRectMake(point.x,point.y,image.size.width, image.size.height) z:z flip:flip];
}

- (id) initWithImage:(UIImage*)image point:(CGPoint)point z:(NSInteger)z
{
    return [self initWithImage:image rect:CGRectMake(point.x,point.y,image.size.width, image.size.height) z:z flip:TRUE];
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
    //Change the board generation.
    return [self initWithImage:image position:pos flip:TRUE];
}

- (id) initWithImage:(UIImage*)image position:(CGPoint)pos flip:(BOOL)flip
{
    CGFloat scale = [UIScreen mainScreen].scale;
    self = [super initWithFrame:CGRectMake(pos.x, pos.y, image.size.width/scale, image.size.height/scale)];
    self.clipsToBounds = TRUE;
    //This is important for support the retina resolution screen. 
    self.contentScaleFactor = [UIScreen mainScreen].scale;
    _images = [[NSMutableArray alloc] init];
    //DRY principle
    [self addEZImage:[[EZImage alloc] initWithImage:image rect:CGRectMake(0, 0, image.size.width, image.size.height) z:0 flip:flip]];
    //This may not be necessary, anyway do no harm, right?
    //[self setNeedsDisplay];
    return self;
}

- (void) addEZImage:(EZImage*)image
{
    if(image.flip){
        image.image = [EZChess2Image flipImage:image.image];
    }
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
    [self addEZImage:[[EZImage alloc] initWithImage:image rect:rect z:z flip:TRUE]];
    
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
        CGContextDrawImage(ctx, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width/self.contentScaleFactor, rect.size.height/self.contentScaleFactor), image.image.CGImage);
    }
}

//I do this to speedup the whole process.
+ (UIImage*) generateSmallBoard:(NSArray*) coords
{
    CGFloat scale = [UIScreen mainScreen].scale;
    EZImageView* imageView = [[EZImageView alloc] initWithImage:[EZFileUtil imageFromFile:@"small-board.png"]];
    UIImage* boardImg = [EZChess2Image generateAdjustedBoard:coords size:CGSizeMake(130*scale, 130*scale)];
    [imageView addEZImage:[[EZImage alloc] initWithImage:boardImg point:ccp(7, 7) z:2 flip:FALSE]];
    EZImage* chessFrame = [[EZImage alloc] initWithImage:[EZFileUtil imageFromFile:@"small-chessboard-frame.png"] point:ccp(5, 5) z:3];
    [imageView addEZImage:chessFrame];
    
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size,YES,scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for(EZImage* image in imageView.images){
        CGRect rect = image.rect;
        //rect.origin.y = self.bounds.size.height - rect.origin.y;
        //EZDEBUG(@"images rect:%@", NSStringFromCGRect(rect));
        CGContextDrawImage(ctx, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width/scale, rect.size.height/scale), image.image.CGImage);
    }
    //[_name.layer drawInContext:ctx];
    //[_intro.layer drawInContext:ctx];
    UIImage* res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //EZDEBUG(@"Final image size:%@", NSStringFromCGSize(res.size));
    return res;
}

@end
