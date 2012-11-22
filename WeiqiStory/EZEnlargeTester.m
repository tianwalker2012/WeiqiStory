//
//  EZEnlargeTester.m
//  WeiqiStory
//
//  Created by xietian on 12-11-21.
//
//

#import "EZEnlargeTester.h"
#import "EZResizeChessBoard.h"
#import "EZChessBoard.h"
#import "EZChessBoardWrapper.h"

@implementation EZEnlargeTester

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EZEnlargeTester *layer = [EZEnlargeTester node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	return scene;
}

//We will only support potrait orientation
- (id) init
{
    self = [super init];
    if(self){
        
        
        EZResizeChessBoard* chessBoard = [[EZResizeChessBoard alloc] initWithOrgBoard:@"chess-board.png" orgRect:CGRectMake(13, 13, 271, 271) largeBoard:@"chess-board-large.png" largeRect:CGRectMake(27, 27, 632, 632)];
        
        EZDEBUG(@"Before seting Content size:%@", NSStringFromCGSize(chessBoard.contentSize));
        chessBoard.contentSize = CGSizeMake(297, 297);
        EZDEBUG(@"After settting content size:%@", NSStringFromCGSize(chessBoard.contentSize));
        [self addChild:chessBoard];
        
        //This proved the orginal 
        
        /**
        EZChessBoard* board = [[EZChessBoard alloc] initWithFile:@"chess-board.png" touchRect:CGRectMake(13, 13, 271, 271) rows:19 cols:19];
        
        //testBoard.scale = 1.5;
        EZChessBoardWrapper* testBoard = [[EZChessBoardWrapper alloc] initWithBoard:board];
        
        testBoard.anchorPoint = ccp(0, 0);
        testBoard.position = ccp(20, 20);
        testBoard.contentSize = CGSizeMake(297, 297);
        
        [self addChild:testBoard];
        **/
        //Let's debug the virual cursor issue, why no cursor show off.
        
    }
    
    return self;
}

@end
