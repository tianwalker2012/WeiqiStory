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
#import "EZFileUtil.h"
#import "EZTouchView.h"
#import "EZFlexibleResizeBoard.h"
#import "EZShape.h"

@interface EZEnlargeTester()
{
    //EZFlexibleBoard* flexBoard;
    EZFlexibleResizeBoard* flexBoard;
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


- (void) testTouch
{
    EZTouchView* touchView = [[EZTouchView alloc] initWithFrame:[CCDirector sharedDirector].view.bounds];
    touchView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    touchView.touchBlock = ^(){
        EZDEBUG(@"Touch view get touched");
    };
    
    [[CCDirector sharedDirector].view addSubview:touchView];
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
        
        _studyBoardHolder = [[CCNode alloc] init];
        _studyBoardHolder.contentSize = CGSizeMake(320, 397);
        _studyBoardHolder.anchorPoint = ccp(0.5, 0);
        _studyBoardHolder.position = ccp(320/2, 0);

        [self addChild:_studyBoardHolder];
        
        flexBoard = [[EZFlexibleResizeBoard alloc] initWithBoard:@"chess-board-large.png" boardTouchRect:CGRectMake(27, 27, 632, 632) visibleSize:CGSizeMake(300, 300)];
        flexBoard.anchorPoint = ccp(0.5, 0.5);
        flexBoard.position = ccp(320/2, 400/2);
        
        //[flexBoard.chessBoard putChessmans:@[[[EZCoord alloc] init:2 y:15],[[EZCoord alloc]init:12 y:15],[[EZCoord alloc]init:14 y:14]] animated:NO];
        flexBoard.basicPatterns = nil;//@[[[EZCoord alloc] init:1 y:1],[[EZCoord alloc]init:12 y:15],[[EZCoord alloc]init:14 y:14]];
        [_studyBoardHolder addChild:flexBoard];
        
        CCSprite* shapeMark = [CCSprite spriteWithFile:@"triangular-large.png"];
        [flexBoard.chessBoard putMark:shapeMark coord:[[EZCoord alloc] init:5 y:5] animAction:nil];
        
        shapeMark = [CCSprite spriteWithFile:@"triangular-large.png"];
        [flexBoard.chessBoard putMark:shapeMark coord:[[EZCoord alloc] init:6 y:6] animAction:nil];
        
        shapeMark = [CCSprite spriteWithFile:@"triangular-large.png"];
        [flexBoard.chessBoard putMark:shapeMark coord:[[EZCoord alloc] init:7 y:7] animAction:nil];
        
        
        //EZShape* shape  = [[EZShape alloc] init];
        //shape.contentSize = CGSizeMake(38, 38);
        //[flexBoard.chessBoard putMark:shape coord:[[EZCoord alloc]init:8 y:8] animAction:nil];
        
        //shape  = [[EZShape alloc] init];
        //shape.contentSize = CGSizeMake(38, 38);
        //[flexBoard.chessBoard putMark:shape coord:[[EZCoord alloc]init:10 y:10] animAction:nil];
        
        
        //[self addChild:_studyBoardHolder];
        //UIImageView* imageView = [[UIImageView alloc] initWithImage:[EZFileUtil imageFromFile:@"lock.png"]];
        //imageView.contentScaleFactor = 2;
        //[[CCDirector sharedDirector].view addSubview:imageView];
        
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
        
        EZDEBUG(@"Why it doesn't work to setup the frame");
        
        /**
        UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //UIActivityIndicatorView* ac
        [activityIndicator setFrame:CGRectMake(0, 0, 200, 200)];
    
        activityIndicator.center = ccp(160, 240);
        activityIndicator.backgroundColor = [UIColor colorWithRed:0.5 green:0.3 blue:0.3 alpha:0.5];
        [[CCDirector sharedDirector].view addSubview:activityIndicator];
        [activityIndicator startAnimating];

        **/
        
        //[[CCDirector sharedDirector].view addSubview:touchView];
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
