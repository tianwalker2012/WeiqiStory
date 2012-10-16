//
//  EZChess2Image.m
//  WeiqiStory
//
//  Created by xietian on 12-10-15.
//
//

#import "EZChess2Image.h"
#import "EZCoord.h"


@implementation EZChess2Image

//Assume I will give a cubic size to it.
//Inside I will determine how to show it.
//Add the region checkup as goal for next iteration
+ (UIImage*) generateChessBoard:(NSArray*)chessCoord size:(CGSize)size
{
    //Will replace it later.
    //UIView* background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    //The chessman will be shrinked to the gap size.
    UIGraphicsBeginImageContext(size);
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(cgContext, [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor);
    CGContextFillRect(cgContext, CGRectMake(0, 0, size.width, size.height));
    
    CGContextSetStrokeColorWithColor(cgContext, [UIColor colorWithRed:0.8 green:0.7 blue:0.7 alpha:1.0].CGColor);
    
  
    //Draw the context image to it.
    
    CGFloat gap = size.height/19.0;
    CGFloat pad = gap/2.0;
    
    CGFloat startX = pad;
    CGFloat startY = pad;
    CGContextBeginPath(cgContext);
    for(int i = 0; i < 19; i++){
        
        CGContextMoveToPoint(cgContext, startX+ i*gap,0);
        CGContextAddLineToPoint(cgContext, startX + i*gap, size.height);
        
    }
    
    for(int i = 0; i < 19; i++){
        CGContextMoveToPoint(cgContext,0, startY+ i*gap);
        CGContextAddLineToPoint(cgContext,size.width, startY + i*gap);
        
    }
    CGContextStrokePath(cgContext);
    CGContextClosePath(cgContext);
    
    
    CGSize btnSize = CGSizeMake(gap, gap);
    
    //TODO will move the image shrinkage to the initialization part of the code. 
    UIImage* black = [EZChess2Image shrinkImage:[UIImage imageNamed:@"black-btn-pad"] size:btnSize];
    UIImage* white = [EZChess2Image shrinkImage:[UIImage imageNamed:@"white-btn-pad"] size:btnSize];
    
    for(EZCoord* coord in chessCoord){
        CGPoint pos = CGPointMake(pad+ gap*coord.x, pad + gap*coord.y);
        UIImage* btn = (coord.chessType == kWhiteChess)?white:black;
        [self drawCtx:cgContext image:btn pos:pos];
    }
    UIImage* res = UIGraphicsGetImageFromCurrentImageContext();
    return res;
}


//Will shrink image to the proper size
+ (UIImage*) shrinkImage:(UIImage*)image size:(CGSize)size
{
    //UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    UIGraphicsBeginImageContext(size);
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(cgContext, kCGInterpolationHigh);
    CGContextSetShouldAntialias(cgContext, true);
    CGContextTranslateCTM(cgContext, 0, size.height);
    CGContextScaleCTM(cgContext, 1, -1);
    CGContextDrawImage(cgContext, CGRectMake(0, 0, size.width, size.height), image.CGImage);
    UIImage* tranferred = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tranferred;
}


+ (void) drawCtx:(CGContextRef)ctx image:(UIImage*)image pos:(CGPoint)pos
{
    CGSize imgSize = image.size;
    //It depends on 
    CGPoint adjusted = CGPointMake(pos.x - imgSize.width/2, pos.y - imgSize.height/2);
    CGContextDrawImage(ctx, CGRectMake(adjusted.x, adjusted.y, image.size.width, image.size.height), image.CGImage);
}

@end
