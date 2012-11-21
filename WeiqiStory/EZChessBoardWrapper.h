//
//  EZChessBoardWrapper.h
//  WeiqiStory
//
//  Created by xietian on 12-11-21.
//
//

#import "cocos2d.h"

@class EZChessBoard;
//The purpose of this is to test whether chessboard can be wrapped or not.
//This is a clean room test methodology.
//Expecting it to get the bugs out.
@interface EZChessBoardWrapper : CCNode<CCTargetedTouchDelegate>

- (id) initWithBoard:(EZChessBoard*) board;

@property (nonatomic, strong) EZChessBoard* board;

@end
