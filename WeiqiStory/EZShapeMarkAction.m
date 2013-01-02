//
//  EZShapeMarkAction.m
//  WeiqiStory
//
//  Created by xietian on 12-12-28.
//
//

#import "EZShapeMarkAction.h"
#import "EZActionPlayer.h"
#import "EZChessBoard.h"

@implementation EZShapeMarkAction

- (id) init
{
    self = [super init];
    self.syncType = kSync;
    return self;
}

- (void) undoAction:(EZActionPlayer*)player
{
    for(EZCoord* coord in _coords){
        EZDEBUG(@"Will undo marks type:%i, at position:%@", _shapeType, coord);
        [player.board removeMark:coord animAction:NO];
    }
}

//For the subclass, override this method.
- (void) actionBody:(EZActionPlayer*)player
{
    for(EZCoord* coord in _coords){
        EZDEBUG(@"I am put mark image now");
        //EZShape* shape = [[EZShape alloc] init];
        EZChessBoard* chessBoard = (EZChessBoard*)player.board;
        
        EZDEBUG(@"Chessboard is large:%@", chessBoard.isLargeBoard?@"Yes":@"No");
        CCSprite* shape = [CCSprite spriteWithFile:chessBoard.isLargeBoard?@"triangular-large.png": @"triangular.png"];
        
        //EZChessBoard* chessBoard = (EZChessBoard*)player.board;
        //shape.contentSize = chessBoard.estimatedChessmanSize;
        EZDEBUG(@"Will draw shape:%i, at position:%@, contentSize:%@", _shapeType, coord, NSStringFromCGSize(shape.contentSize));
        [chessBoard putMark:shape coord:coord animAction:nil];
    
        
        /**
        EZChessBoard* chessBoard = (EZChessBoard*)player.board;
        for(int i = 0; i < 10 ; i++){
        EZShape* shapeEx = [[EZShape alloc] init];
        shapeEx.lineWidth = 4;
        shapeEx.contentSize = CGSizeMake(300, 300);
        shapeEx.position = ccp(i*50, i*50);
        
        [chessBoard addChild:shapeEx z:10];
        }
         **/
    }
}


@end
