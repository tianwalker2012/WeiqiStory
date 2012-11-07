//
//  EZRegretAction.m
//  WeiqiStory
//
//  Created by xietian on 12-11-2.
//
//

#import "EZRegretAction.h"
#import "EZChessBoard.h"
#import "EZChessMark.h"
#import "EZCoord.h"
#import "EZChessPosition.h"

@implementation EZRegretAction

- (void) redo:(EZChessBoard*)board animated:(BOOL)animated
{
    if(_position){
        [board putChessman:_position.coord animated:animated];
    }
    
    if(_chessMarks){
        [board putMarks:_chessMarks];
    }
}

@end
