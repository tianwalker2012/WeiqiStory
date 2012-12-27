//
//  EZChessManual.h
//  WeiqiStory
//
//  Created by xietian on 12-12-20.
//
//

#import <Foundation/Foundation.h>

//Why do I have this class?
//This will represent a complete chess manual.
//Should I have other things?
//I need to have the mapping from the 2 Character acronym to my complete name.
//Also I need to be able to persistent to SGF files.
//Ok, with above requirements, I could go ahead and implement what I need.
@interface EZChessManual : NSObject

//The player name for black stone
@property (nonatomic, strong) NSString* blackName;

//The Player name for hold white stone.
@property (nonatomic, strong) NSString* whiteName;

//Only available for quizz
//AB, AW was right formula.
@property (nonatomic, strong) NSArray* basicPattern;




@end
