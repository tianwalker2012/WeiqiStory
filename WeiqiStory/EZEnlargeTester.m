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
#import "EZFlexibleBoard.h"

@interface EZEnlargeTester()
{
    EZFlexibleBoard* flexBoard;
    CCSprite* chessBoard;
    CCSprite* chessMan;
}


@end


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
        
        self.isTouchEnabled = true;
        /**
        EZResizeChessBoard* chessBoard = [[EZResizeChessBoard alloc] initWithOrgBoard:@"chess-board.png" orgRect:CGRectMake(13, 13, 271, 271) largeBoard:@"chess-board-large.png" largeRect:CGRectMake(27, 27, 632, 632)];
        
        EZDEBUG(@"Before seting Content size:%@", NSStringFromCGSize(chessBoard.contentSize));
        chessBoard.contentSize = CGSizeMake(297, 297);
        EZDEBUG(@"After settting content size:%@", NSStringFromCGSize(chessBoard.contentSize));
        [self addChild:chessBoard];
        **/
        //This proved the orginal 
        
        /**
        EZChessBoard* board = [[EZChessBoard alloc] initWithFile:@"chess-board-large.png" touchRect:CGRectMake(13, 13, 271, 271) rows:19 cols:19];
        
        
        
        
        
        board.scale = 2;
        EZDEBUG(@"chessBoard boundingSize:%@", NSStringFromCGRect(board.boundingBox));
        
        //testBoard.scale = 1.5;
        EZChessBoardWrapper* testBoard = [[EZChessBoardWrapper alloc] initWithBoard:board];
        
        testBoard.anchorPoint = ccp(0, 0);
        testBoard.position = ccp(20, 20);
        testBoard.contentSize = CGSizeMake(297, 297);
        board.cursorHolder = testBoard;
        [self addChild:testBoard];
         **/
        flexBoard = [[EZFlexibleBoard alloc] initWithBoard:@"chess-board-large.png" boardTouchRect:CGRectMake(27, 27, 632, 632) visibleSize:CGSizeMake(300, 300)];
        flexBoard.anchorPoint = ccp(0.5, 0.5);
        flexBoard.position = ccp(320/2, 300/2);
        
        [flexBoard.chessBoard putChessmans:@[[[EZCoord alloc] init:2 y:15],[[EZCoord alloc]init:12 y:15],[[EZCoord alloc]init:14 y:14]] animated:NO];
        //flexBoard.basicPatterns = @[[[EZCoord alloc] init:1 y:1],[[EZCoord alloc]init:12 y:15],[[EZCoord alloc]init:14 y:14]];
        [self addChild:flexBoard];
        
        
        //Following code is to understand the mechanism of local and world space transition.
        //After take some hard time, finally, I got the understanding about it.
        //I love this. 
        chessBoard = [CCSprite spriteWithFile:@"chess-board.png"];
        EZDEBUG(@"chessBoard size:%@", NSStringFromCGSize(chessBoard.contentSize));
        
        chessMan = [CCSprite spriteWithFile:@"point-finger-black.png"];
        EZDEBUG(@"chessMan size:%@", NSStringFromCGSize(chessMan.contentSize));
        chessMan.position = ccp(30, 30);
        chessMan.anchorPoint = ccp(0, 0);
        //[chessBoard addChild:chessMan];
        
        
        chessBoard.position = ccp(50, 50);
        chessBoard.anchorPoint = ccp(0, 0);
        //[self addChild:chessBoard];
        //Let's debug the virual cursor issue, why no cursor show off.
        
        UIButton* zoomIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        zoomIn.frame = CGRectMake(0, 0, 88, 44);
        [zoomIn setTitle:@"Zoom in" forState:UIControlStateNormal];
        [zoomIn addTarget:self action:@selector(zoomIn:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        
        
        
        UIButton* zoomOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        zoomOut.frame = CGRectMake(200, 0, 88, 44);
        [zoomOut setTitle:@"Zoom out" forState:UIControlStateNormal];
        [zoomOut addTarget:self action:@selector(zoomOut:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        
        
        UIButton* scaleCenter = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        scaleCenter.frame = CGRectMake(0, 66, 88, 44);
        [scaleCenter setTitle:@"Zoom out" forState:UIControlStateNormal];
        [scaleCenter addTarget:self action:@selector(scaleCenter:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        
        [[CCDirector sharedDirector].view addSubview:zoomIn];
        [[CCDirector sharedDirector].view addSubview:zoomOut];
        [[CCDirector sharedDirector].view addSubview:scaleCenter];
    }
    
    return self;
}

- (void) scaleCenter:(id) sender
{
    chessMan.scale = 1;
    [self changeAnchor:chessMan changedAnchor:ccp(0.5, 0.5)];
    chessMan.scale = 1.5;
}

- (void) changeAnchor:(CCNode*)node changedAnchor:(CGPoint)changedAnchor
{
    CGSize dimension = node.contentSize;
    
    CGPoint orgAnchor = node.anchorPoint;
    
    CGFloat orgX = orgAnchor.x * dimension.width;
    
    CGFloat orgY = orgAnchor.y * dimension.height;
    
    CGFloat changeX = changedAnchor.x * dimension.width;
    
    CGFloat changeY = changedAnchor.y * dimension.height;
    
    CGPoint changedPos = ccp(node.position.x+(changeX - orgX), node.position.y+(changeY - orgY));
    CGPoint orgPos = node.position;
    node.position = changedPos;
    node.anchorPoint = changedAnchor;
    EZDEBUG(@"orgAnchor %@,changeAnchor:%@, org position:%@, changed Position:%@",NSStringFromCGPoint(orgAnchor), NSStringFromCGPoint(changedAnchor), NSStringFromCGPoint(orgPos), NSStringFromCGPoint(changedPos));
}

- (void) zoomIn:(id)sender
{
    /**
    EZDEBUG(@"Zoom in get called");
    CGPoint pt = ccp(10, 10);
    CGPoint globalPt = [chessMan convertToWorldSpace:pt];
    EZDEBUG(@"pt:%@, global Point:%@", NSStringFromCGPoint(pt), NSStringFromCGPoint(globalPt));
    assert(globalPt.x == 50+30+10);
    
    globalPt = ccp(30, 30);
    CGPoint localPt = [chessMan convertToNodeSpace:globalPt];
    EZDEBUG(@"gloable Point %@, localPT:%@", NSStringFromCGPoint(globalPt), NSStringFromCGPoint(localPt));
    assert(localPt.x == -50);
    **/
    
    //chessMan.scale = 1;
    //[self changeAnchor:chessMan changedAnchor:ccp(0.9, 0.9)];
    //chessMan.scale = 1.5;
    //CGFloat orgScale = flexBoard.chessBoard.scale;
    //[flexBoard scaleBoardTo:orgScale*1.1];
    EZDEBUG(@"FlexBoard boundingBox:%@, clippingRegion:%@", NSStringFromCGRect(flexBoard.boundingBox), NSStringFromCGRect(flexBoard.clippingRegion));
     [flexBoard recalculateBoardRegion];
}

- (void) zoomOut:(id)sender
{
    EZDEBUG(@"Zoom out get called");
    //[flexBoard scaleBoardTo:1];
    //chessMan.scale = 1;
    //[self changeAnchor:chessMan changedAnchor:ccp(0.1, 0.1)];
    //chessMan.scale = 1.5;
    CGFloat orgScale = flexBoard.chessBoard.scale;
    [flexBoard scaleBoardTo:orgScale*0.9];
}

@end
