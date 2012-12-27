//
//  EZGame.h
//  WeiqiStory
//
//  Created by xietian on 12-12-26.
//
//

#import <Foundation/Foundation.h>


//Why differentiate those?
//Should we add the organially?
//I guess so.
typedef enum{
    kGameOtherType,
    kGameSurvive,
    kGameWhole,
    kGameEndSkill
} EZGameType;

@interface EZGameVO : NSObject

//It is GN or EV
//GN take prority.
@property (nonatomic, strong) NSString* gameName;

@property (nonatomic, strong) NSString* result;

@property (nonatomic, assign) BOOL blackFirst;

@property (nonatomic, strong) NSString* blackName;

@property (nonatomic, strong) NSString* whiteName;

@property (nonatomic, assign) EZGameType gameType;

@end

