//
//  TestSuites.m
//  FirstCocos2d
//
//  Created by Apple on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EZTestSuites.h"
#import "EZConstants.h"
#import "EZBoardStatus.h"
#import "EZCoord.h"
#import "EZUploader.h"
#import "SBJson.h"
#import "EZPatternSearcher.h"
//#import "EZCoord.h"
#import "EZGoRecord.h"
#import "EZActionPlayer.h"
#import "EZAction.h"
#import "EZExtender.h"




@interface MyTestBoard : NSObject<EZBoardDelegate>


@end


@implementation MyTestBoard

- (void) putChessman:(EZCoord*)coord animated:(BOOL)animated
{
    EZDEBUG(@"Put chessman get called:%@", coord);
}


- (void) putChessmans:(NSArray*)coords animated:(BOOL)animated
{
    EZDEBUG(@"Put Chessmans get called:%@", coords);
}

//How many steps I will regret.
- (void) regretSteps:(NSInteger)steps  animated:(BOOL)animated
{
    EZDEBUG(@"Regret get called, steps:%i", steps);
}

@end

//Without test, without confidence. 
//Without confidence, without trust.
//Without trust, without intimate relationship
//Without initmate relationship, without feeling
//Lack of feeling, you didn't put yourself into your product.
//Without put yourself into your product, your product will die out of mal-nourishment.
@interface EZTestSuites()

+ (void) testThisSuite;

+ (void) testEZBoardStatus;

+ (void) testCoordConversion;

+ (void) testAvNeighbor;

+ (void) testJsonDownload;

+ (void) testPatternSearcher;

+ (void) testLiterals;

+ (void) testDirectory;

+ (void) testCurrentDirectory;

+ (void) testRecuringBlockIssue;

 
@end

@implementation EZTestSuites



+ (void) runAllTests
{
    //[TestSuites testAvNeighbor];
    //[TestSuites testCoordConversion];
    //[TestSuites testThisSuite];
    //[TestSuites testEZBoardStatus];
    //[TestSuites testJsonDownload];
    //[TestSuites testPatternSearcher];
    //[EZTestSuites testLiterals];
    //[EZTestSuites testRectExtend];
    //[EZTestSuites testDirectory];
    //[EZTestSuites testIterateAllDirectory];
    //[EZTestSuites testCurrentDirectory];
    //[EZTestSuites listAllRecource];
    //[EZTestSuites testRecuringBlockIssue];
}

//What's the purpose of this method, I encounter problem during using the block.
//I need this test to help me understand the block thoroughly. 
+ (void) testRecuringBlockIssue
{
    EZActionPlayer* player = [EZTestSuites initScript];
    [player next];
    
    [player next];
    //[NSThread sleepForTimeInterval:1.0];
    [player next];
    //[NSThread sleepForTimeInterval:3.0]
    
    EZDEBUG(@"Will start replay after 2 second");
    [player performSelector:@selector(replay) withObject:nil afterDelay:2];
    
    EZDEBUG(@"Will start next after another 2 seconds");
    [player performSelector:@selector(next) withObject:nil afterDelay:4];
    
    EZDEBUG(@"Will replay again");
    [player performSelector:@selector(replay) withObject:nil afterDelay:6];
    
    
    EZDEBUG(@"Will replay again");
    [player performSelector:@selector(replay) withObject:nil afterDelay:8];
    
    EZDEBUG(@"Will crash after 10 second");
    [player performBlock:^(){assert(false);} withDelay:24];
}


+ (EZActionPlayer*) initScript
{
    EZAction* preAction = [[EZAction alloc] init];
    preAction.actionType = kPreSetting;
    preAction.preSetMoves = [NSArray arrayWithObjects:[[EZCoord alloc]init:15 y:12],[[EZCoord alloc] init:14 y:13], [[EZCoord alloc] init:13 y:14], nil];
    preAction.name = @"preAction";
    
    EZAction* action = [[EZAction alloc] init];
    action.actionType = kLectures;
    action.audioFiles = [NSArray arrayWithObjects:@"chess-plant.wav",@"chess-plant.wav",nil];
    action.name = @"AudioAction";
    
    EZAction* action1 = [[EZAction alloc] init];
    action1.actionType = kPlantMoves;
    action1.plantMoves = @[[[EZCoord alloc]init:4 y:12],[[EZCoord alloc] init:5 y:13], [[EZCoord alloc] init:6 y:14]];
    action1.unitDelay = 1.0f;
    action1.name = @"Chess1";
    
    EZAction* action2 = [[EZAction alloc] init];
    action2.actionType = kPlantMoves;
    action2.plantMoves = @[[[EZCoord alloc]init:2 y:15],[[EZCoord alloc] init:7 y:19], [[EZCoord alloc] init:17 y:2]];
    action2.unitDelay = 1.0f;
    action2.name = @"Chess2";
    
    EZAction* actionV1 = [[EZAction alloc] init];
    actionV1.actionType = kLectures;
    actionV1.audioFiles = [NSArray arrayWithObjects:@"enemy.wav",nil];
    
    
    EZAction* action3 = [[EZAction alloc] init];
    action3.actionType = kPlantMoves;
    action3.plantMoves = @[[[EZCoord alloc]init:9 y:13]];
    action3.unitDelay = 1.0f;
    
    EZDEBUG(@"Start playing actions");
    
    return [[EZActionPlayer alloc] initWithActions:@[preAction,action,action1,action2,actionV1,action3] chessBoard:[[MyTestBoard alloc] init]];
}


+ (void) testCurrentDirectory
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString* currentpath = [manager currentDirectoryPath];
    EZDEBUG(@"CurrentPath:%@", currentpath);
    NSString * applicationPath = [[NSBundle mainBundle] bundlePath];
    EZDEBUG(@"Current Path:%@", applicationPath);
    
    assert(false);
}

+ (void) listAllRecource
{
    NSString* dirStr = @"file://localhost/var/mobile/Applications/3F95146A-937C-49E6-9863-47D6076AEACF/WeiqiStory.app/";
    NSError* error;
    
    NSURL* url = [NSURL URLWithString:dirStr];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray* contents = [manager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    
    EZDEBUG(@"Content size:%i, content:%@",contents.count, contents);
    assert(false);
    
}

+ (void) testIterateAllDirectory
{
    EZDEBUG(@"Begin to get directory information");
    NSArray* allDirType = @[
    @(NSApplicationDirectory),
    @(NSLibraryDirectory),
    @(NSUserDirectory),
    @(NSDocumentationDirectory),
    @(NSDocumentDirectory),
    @(NSCoreServiceDirectory),
    @(NSAutosavedInformationDirectory),
    @(NSDesktopDirectory),
    @(NSCachesDirectory),
    @(NSApplicationSupportDirectory),
    @(NSDownloadsDirectory),
    @(NSMoviesDirectory),
    @(NSMusicDirectory),
    @(NSPicturesDirectory),
    @(NSSharedPublicDirectory),
    @(NSAllApplicationsDirectory),
    @(NSAllLibrariesDirectory)];
    for(NSNumber* num in allDirType){
        [EZTestSuites evaluateDir:num.unsignedIntegerValue];
    }
    assert(false);
}

+ (void) evaluateDir:(NSSearchPathDirectory)dirType
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray* urls = [manager URLsForDirectory:dirType inDomains:NSUserDomainMask];
    EZDEBUG(@"The Type:%i URLS count is:%i, content:%@",dirType, urls.count,urls);
    
    for(NSURL* url in urls){
        NSError* error;
        NSArray* contents = [manager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        
        EZDEBUG(@"Content size:%i, content:%@",contents.count, contents);
    }
}
//What's the purpose of this test?
//Get myself fully understood what is the directory.
+ (void) testDirectory
{
    //NSString *theFiles;
    NSFileManager *manager = [NSFileManager defaultManager];
        
    NSArray* urls = [manager URLsForDirectory:NSApplicationDirectory inDomains:NSAllDomainsMask];
    EZDEBUG(@"The URLS for the Application count is:%i, content:%@",urls.count,urls);
    
    for(NSURL* url in urls){
        NSError* error;
        NSArray* contents = [manager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    
        EZDEBUG(@"Content size:%i, content:%@",contents.count, contents);
    }
    
//    assert(false);
}

+ (void) testRectExtend
{
    CGRect org = CGRectMake(5, 5, 100, 100);
    CGRect extended = CGRectInset(org, -4, -4);
    EZDEBUG(@"Extended:%@",NSStringFromCGRect(extended));
    assert(extended.size.width == 108);
    assert(extended.origin.x == 1);
    //assert(false);
}

+ (void) testLiterals
{
    NSString* coolguy = @("100");
    NSNumber* number = @('x');
    NSNumber* number2 = @(128ul);
    
    NSArray* arr = @[@"cool", @"guy", @"me"];
    
    NSDictionary* dict = @{@"key1":@"val1", @"key2":@"val2"};
    
    //NSMutableDictionary
    NSMutableDictionary* mutDict = @{@"key1":@"val1"}.mutableCopy;
    
    //mutDict[@"key1"] = @"val2";
    
    //EZDEBUG(@"Value2:%@",dict[@"key2"]);
    //assert([@"val2" isEqualToString:]);
    
    
    EZDEBUG(@"Print all the value:%@, %i, %i, %@",coolguy, number.intValue, number2.intValue, arr);
    assert(false);
}
//The problem not solved, 
+ (void) testPatternSearcher
{
    EZCoord* step1 = [[EZCoord alloc] init:1 y:2];
    EZCoord* step2 = [[EZCoord alloc] init:3 y:4];
    EZCoord* step3 = [[EZCoord alloc] init:5 y:6];
    EZCoord* step4 = [[EZCoord alloc] init:4 y:4];
    
    EZGoRecord* goRecord = [[EZGoRecord alloc] init];
    goRecord.steps = [NSArray arrayWithObjects:step1,step2,step3,nil];
    
    EZGoRecord* allRecord = [[EZGoRecord alloc] init];
    allRecord.steps = [NSArray arrayWithObjects:step1,step2,step3,step4,nil];
    EZPatternSearcher* searcher = [EZPatternSearcher getInstance];
    [searcher addGoRecord:goRecord];
    //[searcher addGoRecord:allRecord];
    
    NSArray* res = [searcher searchPattern:[NSArray arrayWithObjects:step1,nil]];
    assert(res.count == 1);
    
    res = [searcher searchPattern:[NSArray arrayWithObject:[[EZCoord alloc] init:2 y:1]]];
    assert(res.count == 1);
    
    res = [searcher searchPattern:[NSArray arrayWithObject:[[EZCoord alloc] init:16 y:17]]];
    assert(res.count == 1);
    
    res = [searcher searchPattern:[NSArray arrayWithObject:[[EZCoord alloc] init:17 y:16]]];
    assert(res.count == 1);
    
    res = [searcher searchPattern:[NSArray arrayWithObject:[[EZCoord alloc] init:17 y:2]]];
    assert(res.count == 1);
    
    res = [searcher searchPattern:[NSArray arrayWithObject:[[EZCoord alloc] init:2 y:17]]];
    assert(res.count == 1);
    
    res = [searcher searchPattern:[NSArray arrayWithObject:[[EZCoord alloc] init:16 y:1]]];
    assert(res.count == 1);
    
    res = [searcher searchPattern:[NSArray arrayWithObject:[[EZCoord alloc] init:1 y:16]]];
    assert(res.count == 1);
    
    res = [searcher searchPattern:[NSArray arrayWithObjects:[[EZCoord alloc]init:1 y:16],[[EZCoord alloc] init:3 y:4], nil]];
    assert(res.count == 0);
    
    res = [searcher searchPattern:[NSArray arrayWithObjects:[[EZCoord alloc]init:1 y:16],[[EZCoord alloc] init:3 y:14], nil]];
    assert(res.count == 1);
    
    [searcher addGoRecord:allRecord];
    
    res = [searcher searchPattern:[NSArray arrayWithObjects:[[EZCoord alloc]init:1 y:16],[[EZCoord alloc] init:3 y:14],[[EZCoord alloc] init:5 y:12], nil]];
    assert(res.count == 2);

    res = [searcher searchPattern:[NSArray arrayWithObjects:[[EZCoord alloc]init:1 y:16],[[EZCoord alloc] init:3 y:14],[[EZCoord alloc] init:5 y:12], [[EZCoord alloc] init:4 y:14] ,nil]];
    assert(res.count == 1);
    
    //assert(false);
    
    
}

+ (void) testJsonDownload
{
    EZUploader* uploader = [[EZUploader alloc] init];
    NSDictionary* dict = [uploader getFromServer];
    EZDEBUG(@"Downloaded content:%@", dict.JSONRepresentation);
    
    //assert([[dict objectForKey:@"cool"] isEqualToString:@"guy"]);
    NSString* value = [dict objectForKey:@"cool"];
    assert([value isEqualToString:@"guy"]);
    assert(false);
}

+ (void) testAvNeighbor
{
    EZBoardStatus* bd = [[EZBoardStatus alloc] initWithSize:CGRectMake(0, 0, 30, 30) lineGap:3 totalLines:10];
    EZCoord* coord = [[EZCoord alloc] init:0 y:0];
    NSArray* neigbors = [bd availableNeigbor:coord];
    EZDEBUG(@"Neigbors count %i", neigbors.count);
    assert(neigbors.count == 2);
    EZCoord* plusX = [neigbors objectAtIndex:0];
    EZCoord* plusY = [neigbors objectAtIndex:1];
    
    assert(plusX.x == 1 && plusX.y == 0);
    assert(plusY.x == 0 && plusY.y == 1);
    
    
    
    coord = [[EZCoord alloc] init:0 y:2];
    neigbors = [bd availableNeigbor:coord];
    assert(neigbors.count == 3);
    EZCoord* minusY = [neigbors objectAtIndex:0];
    EZCoord* minusX = nil;
    plusX = [neigbors objectAtIndex:1];
    plusY = [neigbors objectAtIndex:2];
    
    EZDEBUG(@"org:%@,PlusX:%@, plusY:%@, minusY:%@",coord, plusX, plusY, minusY);
    
    assert(plusX.x == 1 && plusX.y == coord.y);
    assert(plusY.x == 0 && plusY.y == coord.y + 1);
    assert(minusY.x == 0 && minusY.y == coord.y - 1);
    
    
    coord = [[EZCoord alloc] init:9 y:9];
    neigbors = [bd availableNeigbor:coord];
    assert(neigbors.count == 2);
    
    coord = [[EZCoord alloc] init:2 y:9];
    neigbors = [bd availableNeigbor:coord];
    assert(neigbors.count == 3);
    
    coord = [[EZCoord alloc] init:2 y:2];
    neigbors = [bd availableNeigbor:coord];
    assert(neigbors.count == 4);
    
    //Strictly speak, this test case is bad,
    //Because it depends on the internal implementation
    //This is for the convinience of my test
    minusX = [neigbors objectAtIndex:0];
    minusY = [neigbors objectAtIndex:1];
    plusX = [neigbors objectAtIndex:2];
    plusY = [neigbors objectAtIndex:3];
    
    EZDEBUG(@"org:%@,PlusX:%@, plusY:%@, minusY:%@, minuX:%@",coord, plusX, plusY, minusY, minusX);
    
    assert(plusX.x == coord.x+1 && plusX.y == coord.y);
    assert(plusY.x == coord.x && plusY.y == coord.y + 1);
    assert(minusY.x == coord.x && minusY.y == coord.y - 1);
    assert(minusX.x == coord.x-1 && minusX.y == coord.y);
    
    assert(false);
}

+ (void) testCoordConversion
{
    EZCoord* bd = [[EZCoord alloc] init:1 y:2];
    short converted = [bd toNumber];
    EZDEBUG(@"The converted:%i", converted);
    assert(converted == 258);
    
    bd = [EZCoord fromNumber:514];
    assert(bd.x == 2);
    assert(bd.y == 2);
    
   // assert(false);
    
}

//Test is ok.
//Let's integrate with the code and check how's going.
+ (void) testEZBoardStatus
{
    EZBoardStatus* bds = [[EZBoardStatus alloc] initWithSize:CGRectMake(5, 5, 25, 25) lineGap:5 totalLines:4];
    CGPoint adjusted = [bds adjustLocation:CGPointMake(7, 7)];
    EZDEBUG(@"Org:%@ , Adjusted: %@",NSStringFromCGPoint(CGPointMake(7, 7)), NSStringFromCGPoint(adjusted));
    assert(adjusted.x == 10);
    assert(adjusted.y == 10);
    
    adjusted = [bds adjustLocation:CGPointMake(13, 13)];
    EZDEBUG(@"Org:%@, Adjusted: %@", NSStringFromCGPoint(CGPointMake(13, 13)), NSStringFromCGPoint(adjusted));
    
    assert(adjusted.x == 15);
    assert(adjusted.y == 15);
    
    
    adjusted = [bds adjustLocation:CGPointMake(23, 23)];
    EZDEBUG(@"Org:%@, Adjusted: %@", NSStringFromCGPoint(CGPointMake(23, 23)), NSStringFromCGPoint(adjusted));
    assert(adjusted.x == 25);
    assert(adjusted.y == 25);
    
    
    adjusted = [bds adjustLocation:CGPointMake(0, 100)];
    EZDEBUG(@"Org:%@, Adjusted: %@", NSStringFromCGPoint(CGPointMake(0, 100)), NSStringFromCGPoint(adjusted));
    assert(adjusted.x == 10);
    assert(adjusted.y == 25);
    
    assert(false);
    
}

+ (void) testThisSuite
{
    assert(false);
}

@end
