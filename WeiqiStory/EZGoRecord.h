//
//  EZGoRecords.h
//  FirstCocos2d
//
//  Created by xietian on 12-9-12.
//
//

#import <Foundation/Foundation.h>

//What's the purpose of this class?
//The steps and patterns are stored in the database.
//This is the objects represent the GoRecords.
//Who will use?
//The Board object will use it.
//Currently is will only store steps.
//Later I will add audio and text with it.
//Add them later. Not now,Focus on now.
@interface EZGoRecord : NSObject


@property (strong, nonatomic) NSArray* steps;

//- (BOOL) compare:(NSArray*)steps;

@end
