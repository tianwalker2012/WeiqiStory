//
//  EZPatternSearcher.h
//  FirstCocos2d
//
//  Created by xietian on 12-9-12.
//
//

#import <Foundation/Foundation.h>


@class EZGoRecord;
//Why do i create this class.
//It is for search the patterns out of somewhere.
//This is just a searcher, decouple it with the database.
@interface EZPatternSearcher : NSObject

+ (EZPatternSearcher*) getInstance;


//@property (strong, nonatomic) NSMutablArray* records;

//Why do we have this?
//All the steps will be stored here.
//So it can be queryed with very high speed.
//All the sub string will be stored in the hash map.
//If the map array list already exist, will append the object to the map.
//What if we remove the steps from this searcher?
@property (strong, nonatomic) NSMutableDictionary* searchMapping;

//This is search interface
- (NSArray*) searchPattern:(NSArray*)currentSteps;


//What's the purpose of this method?
//This is the method for building the search engine.
- (void) addGoRecord:(EZGoRecord*)record;

//Turn one step into 4 steps.So all other directions could be found
//Who will call this?
//Only internal method will call it.
//I expose it simply for the test purpose
- (NSArray*) tranformSteps:(NSArray*)steps;

//This will build index at the hashMap
//The purpose is to simplify the test.
- (void) buildIndex:(NSArray*)steps record:(EZGoRecord*)record;

//This is method mainly for internal usage. Expose it for the purpose of test
- (NSString*) createQueryStr:(NSArray*)steps;

@end
