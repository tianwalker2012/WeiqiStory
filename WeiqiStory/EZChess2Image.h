//
//  EZChess2Image.h
//  WeiqiStory
//
//  Created by xietian on 12-10-15.
//
//

#import <Foundation/Foundation.h>

//What's the purpose of this calss?
//Turn the planted chess into a image.
//This is a cost process, so just run it once for alll the downloaded coords.
//Interesting.
//My current plan, implement it as a ChessBoardDelegate.
//No keep it simple and stupid in current iteration.
//So pass a list of Coord or ChessMan to it.
//So that I could plant it as I expected. then output the image to desired size.
@interface EZChess2Image : NSObject



+ (UIImage*) generateChessBoard:(NSArray*)chessCoord size:(CGSize)size;


//Will shrink image to the proper size
+ (UIImage*) shrinkImage:(UIImage*)image size:(CGSize)size;


+ (UIImage*) generatePartialImage:(UIImage*)image rect:(CGRect)rect;

//Why do we flip the image?
//For what purpose?
//If not flip it the image we show use CGContext will be upside down.
+ (UIImage*) flipImage:(UIImage*) image;


//Calculate what's the maximum size for the selected coord
//The output is a CGRect.
//x:0 mean left, x:1 mean right
//y:0 mean top, y:1 mean bottom
//sizeX mean how many col,
//SizeY mean how many row.
//If you are using Cubic board
//You can just pick the maximum size
+ (CGRect) shrinkBoard:(NSArray*)coords;

//Generate adjusted board
+ (UIImage*) generateAdjustedBoard:(NSArray*)coords size:(CGSize)size;


+ (UIImage*) generateOrgBoard:(NSArray*)coords;

//Draw the picture in the middle point
+ (void) drawCtx:(CGContextRef)ctx image:(UIImage*)image pos:(CGPoint)pos;

@end
