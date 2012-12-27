//
//  EZSGFReader.h
//  WeiqiStory
//
//  Created by xietian on 12-12-20.
//
//

#import <Foundation/Foundation.h>

//What's the purpose of this class?
//Read the SGF file to a class object.
//In the mean while can persist class into


/**
 GM the game type: Go is 1
 AP which application generate this on.
 SZ is the size of the chessboard.
 Which is useful when I can use smaller board to display this.
 EV What is the event for this game.
 RE Result of this game, Like B+3.5 OR some other word etc.
 TR mask give position with triangle.
 Cool, how to do this?
 GN game name, yes
 US Who input this game
 SO name of the source.
 N provide name for the current move.
 I can treat it as Comment. Or treat is as a flash Comment.
 LB what's the meaning of this?
 
 BR,WR, The rate of Black player and the Rate of White player.
 Cool, make it useful.
 **/
@class EZChessNode, EZSGFItem, EZEpisodeVO;
@interface EZSGFHelper: NSObject

+ (EZEpisodeVO*) readSGF:(NSString*)fileName;

+ (EZEpisodeVO*) convertNodeToAction:(EZChessNode*)node;

//Turn the chess node into coord which can be deloyed on the board
+ (NSArray*) itemToCoord:(EZSGFItem*)item;


//Turn the label into the mark, which can be displayed on the board
+ (NSArray*) labelToMarks:(EZSGFItem*)item;

@end
