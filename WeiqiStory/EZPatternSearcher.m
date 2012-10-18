//
//  EZPatternSearcher.m
//  FirstCocos2d
//
//  Created by xietian on 12-9-12.
//
//

#import "EZPatternSearcher.h"
//#import "EZGoRecord.h"
#import "EZCoord.h"

@implementation EZPatternSearcher
@synthesize searchMapping;

static EZPatternSearcher* searcher;


- (id) init
{
    self = [super init];
    if(self){
        searchMapping = [[NSMutableDictionary alloc]init];
        //Why do I need this?
        //Initially, I am thinking about store the index to this array.
        //Now seems not necessary. Let's remove it
        //records = [[NSArray alloc]init];
    }
    return self;
}

+ (EZPatternSearcher*) getInstance
{
    if(searcher==nil){
        searcher = [[EZPatternSearcher alloc] init];
    }
    return searcher;
}

//Will get pattern out
- (NSArray*) searchPattern:(NSArray*)currentSteps
{
    NSString* queryStr = [self createQueryStr:currentSteps];
    NSArray* res = [searchMapping objectForKey:queryStr];
    return res;
}

//This is method mainly for internal usage. Expose it for the purpose of test
- (NSString*) createQueryStr:(NSArray*)steps
{
    NSMutableString* queryStr = [[NSMutableString alloc]initWithString:@""];
    for(EZCoord* coord in steps){
        [queryStr appendFormat:@".%i,%i",coord.x, coord.y];
    }
    return queryStr;
}


//What's the purpose of this method?
//This is the method for building the search engine.
- (void) addGoRecord:(EZGoRecord*)record
{
    //Why I have this method?
    //Because a pattern can be applied to 8 directions.
    //If you don't understand what I am saying.
    //Imagine, you could rotata the chess board, the pattern on chess will be changed, right?
    //Can you say it is not the same pattern?
    //If your another is NO, then you know what I am doing here
    NSArray* allSteps = nil;//[self tranformSteps:record.steps];
    for(NSArray* step in allSteps){
        [self buildIndex:step record:record];
    }
    
}

//Turn one step into 4 steps.So all other directions could be found
//Who will call this?
//Only internal method will call it.
//I expose it simply for the test purpose
//Pay attention to the consistency.
- (NSArray*) tranformSteps:(NSArray*)steps
{
    NSArray* org = steps;
    NSMutableArray* mirrorH = [[NSMutableArray alloc] initWithCapacity:steps.count];
    NSMutableArray* mirrorV = [[NSMutableArray alloc] initWithCapacity:steps.count];
    NSMutableArray* mirrorDiag = [[NSMutableArray alloc] initWithCapacity:steps.count];
    NSMutableArray* orgNDiag = [[NSMutableArray alloc] initWithCapacity:steps.count];
    NSMutableArray* mirrorHNDiag = [[NSMutableArray alloc] initWithCapacity:steps.count];
    NSMutableArray* mirrorVNDiag = [[NSMutableArray alloc] initWithCapacity:steps.count];
    NSMutableArray* mirrorDiagNDiag = [[NSMutableArray alloc] initWithCapacity:steps.count];
    NSArray* res = [NSArray arrayWithObjects:org,mirrorH, mirrorV,mirrorDiag, orgNDiag, mirrorHNDiag, mirrorVNDiag, mirrorDiagNDiag, nil];
    for(EZCoord* bc in org){
        //Reverse the x
        EZCoord* mh = [[EZCoord alloc] init:18-bc.x y:bc.y];
        [mirrorH addObject:mh];
        
        EZCoord* mv = [[EZCoord alloc] init:bc.x y:18-bc.y];
        [mirrorV addObject:mv];
        
        EZCoord* md = [[EZCoord alloc] init:18-bc.x y:18-bc.y];
        [mirrorDiag addObject:md];
        
        [orgNDiag addObject:[[EZCoord alloc] init:bc.y y:bc.x]];
        
        [mirrorHNDiag addObject:[[EZCoord alloc] init:mh.y y:mh.x]];
        [mirrorVNDiag addObject:[[EZCoord alloc] init:mv.y y:mv.x]];
        [mirrorDiagNDiag addObject:[[EZCoord alloc] init:md.y y:md.x]];
        
    }
    return res;
}

//This will be method really build the index
- (void) buildIndex:(NSArray*)steps record:(EZGoRecord*)record
{
    NSMutableString* accumuStr = [[NSMutableString alloc] initWithString:@""];
    for(EZCoord* coord in steps){
        [accumuStr appendFormat:@".%i,%i",coord.x,coord.y];
        NSMutableArray* indexedSteps = [searchMapping objectForKey:accumuStr];
        if(indexedSteps){
            if(![indexedSteps containsObject:record]){
                [indexedSteps addObject:record];
            }
        }else{
            indexedSteps = [[NSMutableArray alloc] init];
            [indexedSteps addObject:record];
            [searchMapping setValue:indexedSteps forKey:accumuStr];
        }
    }
    
}

@end
