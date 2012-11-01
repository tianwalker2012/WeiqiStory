//
//  EZChess2Image.m
//  WeiqiStory
//
//  Created by xietian on 12-10-15.
//
//

#import "EZChess2Image.h"
#import "EZCoord.h"
#import "EZConstants.h"


@implementation EZChess2Image


+ (UIImage*) generateOrgBoard:(NSArray*)coords
{
    CGSize boardSize = CGSizeMake(250, 250);
    UIImage* white = [UIImage imageNamed:@"white-btn-pad"];
    white = [self shrinkImage:white size:CGSizeMake(14, 14)];
    
    UIImage* black = [UIImage imageNamed:@"black-btn-pad"];
    black = [self shrinkImage:black size:CGSizeMake(14, 14)];
    
    UIGraphicsBeginImageContext(boardSize);
    UIImage* image = [UIImage imageNamed:@"inner-board-pad@250x250"];
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    //CGContextTranslateCTM(cgContext, 0, 250);
    //CGContextScaleCTM(cgContext, 1, -1);
    CGContextDrawImage(cgContext, CGRectMake(0, 0, 250, 250), image.CGImage);
    EZDEBUG(@"Background size is:%@", NSStringFromCGSize(image.size));
    //[self drawCtx:cgContext image:image pos:CGPointMake(0, 0)];
    
    
    CGFloat gap = 13.0;
    CGFloat pad = 7.0;
    
    for(EZCoord* coord in coords){
        EZDEBUG(@"Will draw coord x:%i, y:%i", coord.x, coord.y);
        CGPoint pos = CGPointMake(pad+ gap*coord.x, pad + gap*coord.y);
        UIImage* btn = (coord.chessType == kWhiteChess)?white:black;
        
        [self drawCtx:cgContext image:btn pos:pos];
    }
    UIImage* res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;

}

+ (UIImage*) generateChessBoard:(NSArray*)chessCoord size:(CGSize)size
{
    UIImage* res = [self generateOrgBoard:chessCoord];
    return [self shrinkImage:res size:size];
}


+ (UIImage*) generatePartialImage:(UIImage*)image rect:(CGRect)rect finalSize:(CGSize)finalSize
{
    //UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    //orginalSize = image.size;
    CGImageRef partialImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIGraphicsBeginImageContext(finalSize);
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    
    CGContextSetFillColorWithColor(cgContext, [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0].CGColor);
    CGContextFillRect(cgContext, CGRectMake(0, 0, finalSize.width, finalSize.height));

    
    CGContextSetInterpolationQuality(cgContext, kCGInterpolationHigh);
    CGContextSetShouldAntialias(cgContext, true);
    
    //I assume this could achieve the shifting effects
    
    CGContextTranslateCTM(cgContext, 0, finalSize.height);
    
    CGContextScaleCTM(cgContext, 1, -1);
    
    //CGContextScaleCTM(cgContext, finalSize.width/rect.size.width, finalSize.height/rect.size.height);
    //CGContextTranslateCTM(cgContext, rect.origin.x, rect.origin.y);
    
    CGContextDrawImage(cgContext, CGRectMake(0, 0, finalSize.width, finalSize.height), partialImage);
    
    //CGContextDrawTiledImage(cgContext, CGRectMake(-rect.origin.x, -rect.origin.y, finalSize.width, finalSize.height), image.CGImage);
    
    UIImage* tranferred = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tranferred;

}
//Generate adjusted board
+ (UIImage*) generateAdjustedBoard:(NSArray*)coords size:(CGSize)size
{
    UIImage* res = [self generateOrgBoard:coords];
    CGFloat orgWidth = res.size.width;
    
    CGRect alignRect = [self shrinkBoard:coords];
    EZDEBUG(@"alignedRect:%@", NSStringFromCGRect(alignRect));
    int iWidth = MAX(alignRect.size.height,alignRect.size.width);
    //CGFloat scala = orgWidth/size.width;
    
    CGFloat gap = 13.0;
    CGFloat pad = 7.0;
    CGFloat fWidth = 2*pad + gap*iWidth;
    CGFloat orgX = 0.0;
    CGFloat orgY = 0.0;
    if(alignRect.origin.x == 0){
        orgX = 0;
    }
    if(alignRect.origin.y == 0){
        orgY = 0;
    }
    
    if(alignRect.origin.x == 1){
        orgX = orgWidth - fWidth;
    }
    
    if(alignRect.origin.y == 1){
        orgY = orgWidth - fWidth;
    }
    CGRect clippedRect = CGRectMake(orgX, orgY, fWidth, fWidth);
    EZDEBUG(@"Final clippedRect is:%@", NSStringFromCGRect(clippedRect));
    return [self generatePartialImage:res rect:clippedRect finalSize:size];

}

//Assume I will give a cubic size to it.
//Inside I will determine how to show it.
//Add the region checkup as goal for next iteration
//All the board and line are drawn by using the Core Graphic Code.
//I will shift to the image code instead.
//The original code have some issue,
//It should be a reversed image.
//Let's check it out.
+ (UIImage*) generateChessBoardOld:(NSArray*)chessCoord size:(CGSize)size
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


//Why do we flip the image?
//For what purpose?
//If not flip it the image we show use CGContext will be upside down.
+ (UIImage*) flipImage:(UIImage*) image
{
    return [self shrinkImage:image size:image.size];
}

//Will shrink image to the proper size
+ (UIImage*) shrinkImage:(UIImage*)image size:(CGSize)size
{
    //UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    UIGraphicsBeginImageContext(size);
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(cgContext, kCGInterpolationHigh);
    CGContextSetShouldAntialias(cgContext, true);
    //CGContextTranslateCTM(cgContext, 0, size.height);
    //CGContextScaleCTM(cgContext, 1, -1);
    CGContextDrawImage(cgContext, CGRectMake(0, 0, size.width, size.height), image.CGImage);
    UIImage* tranferred = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tranferred;
}

//Calculate what's the maximum size for the selected coord
+ (CGRect) shrinkBoard:(NSArray*)coords
{
    //How many colomn will add
    int padding = 1;
    int minXGap = 9;
    int minYGap = 9;
    
    int minX = 18;
    int maxX = 0;
    
    int minY = 18;
    int maxY = 0;
    //Set the init value to extreme,
    //So if nothing changed, assume all the input data are legal.
    int orgX = 0;
    int orgY = 0;
    int sizeX = 9;
    int sizeY = 9;
    
    
    for(EZCoord* coord in coords){
        if(coord.x < minX){
            minX = coord.x;
        }
        
        if(coord.x > maxX){
            maxX = coord.x;
        }
        
        if(coord.y > maxY){
            maxY = coord.y;
        }
        
        if(coord.y < minY){
            minY = coord.y;
        }
    }

    int leftDelta = minX - 0;
    int rightDelta = 18 - maxX;
    
    int topDelta = minY - 0;
    int bottomDelta = 18 - maxY;
    
    //EZDEBUG(@"leftDelta:%i, rightDelta:%i, topDelta:%i, bottomDelta:%i", leftDelta, rightDelta, topDelta, bottomDelta);
    
    if(leftDelta < rightDelta){
        //Align to left
        orgX = 0;
        sizeX = maxX + padding;
    }else{
        //Align to right
        orgX = 1;
        sizeX = 18 - minX + 1;
    }
    
    if(topDelta < bottomDelta){
        //Align to top
        orgY = 0;
        sizeY = maxY + padding;
    }else{
        orgY = 1;
        sizeY = 18 - minY + 1;
    }
    
    if(sizeX > 18){
        sizeX = 18;
    }else if(sizeX < minXGap){
        sizeX = minXGap;
    }
    
    if(sizeY > 18){
        sizeY = 18;
    }else if(sizeY < minYGap){
        sizeY = minYGap;
    }
    return CGRectMake(orgX, orgY, sizeX, sizeY);
}


+ (void) drawCtx:(CGContextRef)ctx image:(UIImage*)image pos:(CGPoint)pos
{
    CGSize imgSize = image.size;
    //It depends on 
    CGPoint adjusted = CGPointMake(pos.x - imgSize.width/2, pos.y - imgSize.height/2);
    CGContextDrawImage(ctx, CGRectMake(adjusted.x, adjusted.y, image.size.width, image.size.height), image.CGImage);
}

@end
