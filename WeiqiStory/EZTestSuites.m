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

#import "EZActionPlayer.h"
#import "EZAction.h"
#import "EZExtender.h"
#import "EZChessMoveAction.h"
#import "EZSoundAction.h"
#import "EZFileUtil.h"
#import "EZPersistentUtil.h"
#import "MEpisode.h"
#import "EZCoreAccessor.h"
#import "EZUploader.h"
#import "EZChess2Image.h"
#import "EZDummyObject.h"
#import "EZEpisode.h"
#import "EZCleanAction.h"
#import "EZChessMark.h"
#import "EZMarkAction.h"
#import "EZCombinedAction.h"
#import "EZShowNumberAction.h"
#import "EZChessMoveAction.h"
#import "EZChessPresetAction.h"
#import "EZSoundAction.h"
#import "EZAudioFile.h"
#import "EZEpisodeVO.h"
#import "EZEpisodeFile.h"
#import "EZEpisodeUploader.h"
#import "EZEpisodeDownloader.h"
#import "EZUILoader.h"
#import "EZEpisodeCell.h"
//#import "EZ"




@interface MyTestBoard : NSObject<EZBoardDelegate>


@end

@interface EZGoRecord : NSObject

@property (nonatomic, strong) NSArray* steps;

@end

@implementation EZGoRecord


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
    //[EZTestSuites testNSObjectToJSON];
    //[EZTestSuites testActionToJson];
    //[EZTestSuites testJsonArrayToArray];
    //[EZTestSuites testAudioActionPersist];
    //[EZTestSuites testCoreData];
    
    //assert(false);
    //[EZTestSuites testUpload];
    //[EZTestSuites testDoubleCoreAccessor];
    //[EZTestSuites testTransform];
    //[EZTestSuites testSimplePersist];
    //[EZTestSuites testPersistOneByOne];
    //[EZTestSuites testAnotherFive];
    //[EZTestSuites testEpisodeToJSON];
 
    //[EZTestSuites testUploadAndDownload];
    //[EZTestSuites testUploadAndDownload];
    //[EZTestSuites testDataDownload];
    //[EZTestSuites testEpisodeFileToJson];
    //[EZTestSuites testEpisodeListUpload];
    //[EZTestSuites testCompleteUpload];
    //[EZTestSuites testCompleteDownload];
    //[EZTestSuites testTransformableProperty];
    //[EZTestSuites testLoadUI];
    //[EZTestSuites testBoardShrinkage];
    //[EZTestSuites listAvailableFont];
    //[EZCoreAccessor cleanClientDB];
    
    //[EZTestSuites testFilePath];
    
    //Befor work on the platform test the whole thing first.
    //[EZTestSuites testUpload];
    [EZTestSuites testListAllFiles];
}

+ (void) testListAllFiles
{
    NSArray* files = [EZFileUtil listAllFiles:NSDocumentDirectory];
    for(NSURL* file in files){
        //EZDEBUG(@"File name:%@", file);
    }
    
    [EZFileUtil removeAllAudioFiles];
    //assert(false);
}


+ (void) testFilePath
{
    NSString* boundleURL = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"audio2012102215.caf"];
    NSString* emptyName = @"";//[File [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@""];
    
    NSString* url = [NSString stringWithFormat:@"%@/%@",emptyName, @"audio2012102215.caf"];
    
    EZDEBUG(@"Final URL:%@, bundleURL:%@",url, boundleURL);
    
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    EZDEBUG(@"Data length:%i", data.length);
    
    data = [NSData dataWithContentsOfURL:[NSURL URLWithString:boundleURL]];
    EZDEBUG(@"BundleData length:%i", data.length);
    
    
    NSURL* episodeFile = [EZFileUtil fileToURL:@"episode20121022141041.ar"];
    NSData* episode = [NSData dataWithContentsOfURL:episodeFile];
    EZDEBUG(@"episode length:%i", episode.length);
    
    episode = [NSData dataWithContentsOfFile:@"episode20121022141041.ar"];
    EZDEBUG(@"direct open:%i", episode.length);
    
    
    EZDEBUG(@"boundleURL:%@, emptyName:%@ name", boundleURL, emptyName);
    assert(false);
}

+ (void) listAvailableFont
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"Font name: %@", [fontNames objectAtIndex:indFont]);
        }
        //[fontNames release];
    }
    //[familyNames release];
    assert(false);
}


//Test the simplest cases
+ (void) testBoardShrinkage
{
    EZCoord* coord = [[EZCoord alloc] init:2 y:2];
    CGRect res = [EZChess2Image shrinkBoard:@[coord]];
    
    EZDEBUG(@"Result:%@", NSStringFromCGRect(res));
    assert(res.origin.x == 0);
    assert(res.origin.y == 0);
    assert(res.size.width == 8);
    assert(res.size.height == 8);
    
    coord = [[EZCoord alloc] init:16 y:2];
    res = [EZChess2Image shrinkBoard:@[coord]];
    assert(res.origin.x == 1);
    assert(res.origin.y == 0);
    assert(res.size.width == 8);
    assert(res.size.height == 8);
    
    coord = [[EZCoord alloc] init:2 y:16];
    res = [EZChess2Image shrinkBoard:@[coord]];
    assert(res.origin.x == 0);
    assert(res.origin.y == 1);
    assert(res.size.width == 8);
    assert(res.size.height == 8);
    
    coord = [[EZCoord alloc] init:16 y:16];
    res = [EZChess2Image shrinkBoard:@[coord]];
    assert(res.origin.x == 1);
    assert(res.origin.y == 1);
    assert(res.size.width == 8);
    assert(res.size.height == 8);
    
    coord = [[EZCoord alloc] init:2 y:2];
    coord = [[EZCoord alloc] init:8 y:8];
    res = [EZChess2Image shrinkBoard:@[coord]];
    assert(res.origin.x == 0);
    assert(res.origin.y == 0);
    assert(res.size.width == 9);
    assert(res.size.height == 9);
    

    assert(false);
}

+ (void) testLoadUI
{
    EZEpisodeCell* cell = [EZUILoader createEpisodeCell];
    EZDEBUG("Cell info:%@", cell);
    
    assert(cell.name);
    assert(cell.introduces);
    assert(cell.thumbNail);
    assert(false);
}

+ (void) testTransformableProperty
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    
    EZEpisode* episode = [accessor create:[EZEpisode class]];
    
    EZAction* action1 = [[EZAction alloc] init];
    action1.name = @"action1";
    episode.actions = @[action1];
    //[accessor saveContext];
    [accessor store:episode];
    EZEpisode* fetched =  [clientAccessor1 fetchByID:episode.objectID];
    [clientAccessor1.context refreshObject:fetched mergeChanges:YES];
    EZDEBUG(@"fetched:%@, org:%@", fetched.name, action1.name);
    assert([fetched.name isEqualToString:episode.name]);
    assert(fetched.actions.count == 1);
    
    EZAction* act2 = [[EZAction alloc] init];
    act2.name = @"act2";
    episode.actions = @[action1, act2];
    [accessor saveContext];
    
    [fetched.managedObjectContext refreshObject:fetched mergeChanges:YES];
    assert(fetched.actions.count == 2);
    
    assert(false);
    
}

+ (void) testCompleteDownload
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    //NSString* fileURL = @"http://192.168.10.104:3000/episode20121019165738.ar";
    NSString* listURL = @"http://192.168.10.104:3000/episode.lst";
    EZEpisodeDownloader* downloader = [[EZEpisodeDownloader alloc] init];
    downloader.baseURL = @"http://192.168.10.104:3000";
    [downloader downloadAccordingToList:[NSURL URLWithString:listURL]];
    //[downloader downloadEpisode:[NSURL URLWithString:fileURL] completeBlock:nil];
    [NSThread sleepForTimeInterval:5];
    NSArray* arr = [accessor fetchAll:[EZEpisode class] sortField:@"name"];
    assert(arr.count == 2);
    
    EZEpisode* retEp1 = [arr objectAtIndex:0];
    assert(retEp1.audioFiles.count == 2);
    EZAudioFile* file1 = [retEp1.audioFiles objectAtIndex:0];
    EZAudioFile* file2 = [retEp1.audioFiles objectAtIndex:1];
    NSData* data1 = [NSData dataWithContentsOfURL:file1.getFileURL];
    NSData* data2 = [NSData dataWithContentsOfURL:file2.getFileURL];
    
    EZDEBUG(@"file:%@, length:%i", file1.fileName, data1.length);
    EZDEBUG(@"file:%@, length:%i", file2.fileName, data2.length);
    
    assert(retEp1.completed);
    assert(data1.length > 0);
    assert(data2.length > 0);
    
    EZEpisode* retEp2 = [arr objectAtIndex:1];
    assert(retEp2.audioFiles.count == 1);
    EZAudioFile* file3 = [retEp2.audioFiles objectAtIndex:0];
    NSData* data3 = [NSData dataWithContentsOfURL:file3.getFileURL];
    
    EZDEBUG(@"file:%@, length:%i", file3.fileName, data3.length);
    assert(data3.length > 0);
    assert(retEp2);
    
    assert(false);

}

+ (void) testCompleteUpload
{
    
    EZEpisodeUploader* uploader = [[EZEpisodeUploader alloc] init];
    uploader.uploadBaseURL = @"http://192.168.10.104:3000/upload";
    uploader.downloadBaseURL = @"http://192.168.10.104:3000";
    
    [uploader cleanList];
    
    [uploader performBlock:^(){
        EZEpisodeVO* episode = [[EZEpisodeVO alloc] init];
        episode.name = @"episode 1";
        
        EZAudioFile* file1 = [[EZAudioFile alloc] init];
        file1.fileName = @"firstVoice.wav";
        file1.inMainBundle = true;
        
        EZAudioFile* file2 = [[EZAudioFile alloc] init];
        file2.fileName = @"enemy.wav";
        file2.inMainBundle = true;
        episode.audioFiles = @[file1, file2];
        
        EZEpisodeVO* episode2 = [[EZEpisodeVO alloc] init];
        episode2.name = @"episode 2";

        EZAudioFile* file3 = [[EZAudioFile alloc] init];
        file3.fileName = @"chess-plant.wav";
        file3.inMainBundle = true;
        episode2.audioFiles = @[file3];
        
        [uploader uploadEpisodes:@[episode, episode2] completBlk:nil];
        
    } withDelay:2];
    
    [uploader performBlock:^(){
        //The purpose of this code is to make sure our code get executed.
        //Release my precious recognition power for more important staff. 
        assert(false);
    
    } withDelay:5];
    
}

+ (void) testEpisodeListUpload
{
    EZEpisodeUploader* uploader = [[EZEpisodeUploader alloc] init];
    uploader.uploadBaseURL = @"http://192.168.10.104:3000/upload";
    uploader.downloadBaseURL = @"http://192.168.10.104:3000";
    float delay = 2;
    
    
    [uploader cleanList];
    
    [uploader performBlock:^(){
    
        EZDEBUG(@"Upload the first list");
        [uploader updateList:@"file1"];
        //[NSThread sleepForTimeInterval:5];
    } withDelay:delay];
    
    delay +=2;
    [uploader performBlock:^(){
        EZDEBUG(@"Upload the second list");
        [uploader updateList:@"file2"];
    } withDelay:delay];
    
    
    delay +=2;
    
    [uploader performBlock:^(){
        NSArray* list = [uploader getEpisodeList];
        EZDEBUG(@"Returned list:%i", list.count);
        assert(list.count == 2);
        assert(false);
    } withDelay:delay];
    
}

+ (void) testEpisodeFileToJson
{
    EZEpisodeFile* epfile = [[EZEpisodeFile alloc] init];
    epfile.fileName = @"filename1";
    epfile.createTime = [NSDate date];
    NSString* jsonStr = @[epfile].JSONRepresentation;
    
    NSArray* arr = jsonStr.JSONValue;
    EZEpisodeFile* retFile = [[EZEpisodeFile alloc] initDict:[arr objectAtIndex:0]];
    assert([retFile.fileName isEqualToString:epfile.fileName]);
    
    EZDEBUG(@"Files:%@", jsonStr);
    assert(false);
}

+ (void) testDataDownload
{
    EZDEBUG(@"Before no exist IP");
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.10.104:999/comeOn"]];
    EZDEBUG(@"After non exist IP");
    assert(data == nil);
    assert(data.length == 0);
    
    EZDEBUG(@"Before correct file");
    NSData* data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.10.104:3000/TestFile.ar"]];
    EZDEBUG(@"After correct file");
    assert(data2 !=nil);
    assert(data2.length > 0);
    
    EZDEBUG(@"Before wrong file");
    NSData* data3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.10.104:3000/WrongFile"]];
    EZDEBUG(@"After wrong file");
    assert(data3 == nil);
    assert(data3.length == 0);

    
    assert(false);
}

+ (void) testUploadAndDownload
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    //EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    id created = [accessor create:[EZEpisode class]];
    EZDEBUG(@"Created class:%@, detail:%@",[created class], created);
    
    EZEpisode* episode = created;
    EZDEBUG(@"episode class:%@", episode.class);
    
    episode.name = @"cool guy";
    EZAudioFile* audioFile = [[EZAudioFile alloc] init];
    audioFile.fileName = @"Cool1";
    audioFile.downloaded = true;
    episode.audioFiles = @[audioFile];
    
    
    EZCombinedAction* combine = [[EZCombinedAction alloc] init];
    
    EZChessMoveAction* move = [[EZChessMoveAction alloc] init];
    EZCoord* coord  = [[EZCoord alloc] init:10 y:11];
    move.plantMoves = @[coord];
    
    EZChessPresetAction* presetMove = [[EZChessPresetAction alloc] init];
    presetMove.preSetMoves = @[coord];
    
    combine.actions = @[move, presetMove];
    episode.actions = @[combine];
    
    EZEpisodeVO* vo = [[EZEpisodeVO alloc] initWithPO:episode];
    NSArray* episodes = @[vo];
    EZDEBUG(@"Before achieve");
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:episodes];
    
    EZUploader* uploader = [[EZUploader alloc] initWithURL:[NSURL URLWithString:@"http://192.168.10.104:3000/upload"]];
    
    [uploader uploadToServer:data fileName:@"TestFile.ar" contentType:@"Archieve" resultBlock:^(id resp){
    
        
        
        NSLog(@"Upload successful:%@, mainThread:%i, currentThread:%i", resp, (int)[NSThread mainThread], (int)[NSThread currentThread]);
        
        NSData* downloaded = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.10.104:3000/TestFile.ar"]];
        
        NSLog(@"The downloaded count:%i", downloaded.length);
        
        NSArray* retArr = [NSKeyedUnarchiver unarchiveObjectWithData:downloaded];
        
        assert(retArr.count == 1);
        
        EZEpisodeVO* retEpisode = [retArr objectAtIndex:0];
        assert([episode.name isEqualToString:retEpisode.name]);
        assert(retEpisode.audioFiles.count == 1);
        EZAudioFile* file = [retEpisode.audioFiles objectAtIndex:0];
        
        assert([file.fileName isEqualToString:audioFile.fileName]);
        
        assert(retEpisode.actions.count == 1);
        
        EZCombinedAction* retCombine = [retEpisode.actions objectAtIndex:0];
        assert(retCombine.actions.count == 2);
        
        
        assert(false);

    
    }];
    
}
+ (void) testEpisodeToJSON
{
    
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    //EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    id created = [accessor create:[EZEpisode class]];
    EZDEBUG(@"Created class:%@, detail:%@",[created class], created);
    
    EZEpisode* episode = created;
    EZDEBUG(@"episode class:%@", episode.class);
    
    episode.name = @"cool guy";
    EZAudioFile* audioFile = [[EZAudioFile alloc] init];
    audioFile.fileName = @"Cool1";
    audioFile.downloaded = true;
    episode.audioFiles = @[audioFile];
    
    
    
    //NSString* jsonStr = episodes.JSONRepresentation;
    //EZDEBUG(@"Json string:%@", jsonStr);
    
    //NSMutableData* storedData = [[NSMutableData alloc] init];
    //NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:storedData];
    //[archiver setValue:episode forKey:@"root"];
    EZEpisodeVO* vo = [[EZEpisodeVO alloc] initWithPO:episode];
    NSArray* episodes = @[vo];
    EZDEBUG(@"Before achieve");
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:episodes];
    
    EZDEBUG(@"After achieve");
    
    NSArray* retArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    assert(retArr.count == 1);
    
    EZEpisodeVO* retEpisode = [retArr objectAtIndex:0];
    assert([episode.name isEqualToString:retEpisode.name]);
    assert(retEpisode.audioFiles.count == 1);
    EZAudioFile* file = [retEpisode.audioFiles objectAtIndex:0];
    
    assert([file.fileName isEqualToString:audioFile.fileName]);
    
    assert(false);
    
}

+ (void) testAnotherFive
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    
    EZSoundAction* moveact = [[EZSoundAction alloc] init];
    
    
    moveact.name = @"Sound";
    
    EZAudioFile* audio = [[EZAudioFile alloc] init];
    audio.fileName = @"CoolFile";
    audio.inMainBundle = true;
    audio.downloaded = true;
    
    moveact.audioFiles = @[audio];
    
    EZEpisode* episode = [accessor create:[EZEpisode class]];
    episode.name = @"One";
    episode.actions = @[moveact];
    [accessor saveContext];
    
    NSArray* arr = [clientAccessor1 fetchAll:[EZEpisode class] sortField:@"name"];
    EZEpisode* retEpisode = [arr objectAtIndex:0];
    EZSoundAction* retSna = [retEpisode.actions objectAtIndex:0];
    assert([retSna.name isEqualToString:moveact.name]);
    assert(retSna.audioFiles.count == 1);
    
    EZAudioFile* retAudio = [retSna.audioFiles objectAtIndex:0];
    assert(retAudio.downloaded);
    assert(retAudio.inMainBundle);
    assert([audio.fileName isEqualToString:retAudio.fileName]);
    
    assert(false);
}

+ (void) testAnotherFour
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    
    EZChessPresetAction* moveact = [[EZChessPresetAction alloc] init];
    
    EZCoord* move = [[EZCoord alloc] init:10 y:11];
    moveact.preSetMoves = @[move];
    moveact.name = @"Move";
    
    EZEpisode* episode = [accessor create:[EZEpisode class]];
    episode.name = @"One";
    episode.actions = @[moveact];
    [accessor saveContext];
    
    NSArray* arr = [clientAccessor1 fetchAll:[EZEpisode class] sortField:@"name"];
    EZEpisode* retEpisode = [arr objectAtIndex:0];
    EZChessPresetAction* retSna = [retEpisode.actions objectAtIndex:0];
    assert([retSna.name isEqualToString:moveact.name]);
    assert(retSna.preSetMoves.count == 1);
    
    
    assert(false);
}

+ (void) testAnotherThree
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    
    EZChessMoveAction* moveact = [[EZChessMoveAction alloc] init];
    
    EZCoord* move = [[EZCoord alloc] init:10 y:11];
    moveact.plantMoves = @[move];
    moveact.name = @"Move";
    
    EZEpisode* episode = [accessor create:[EZEpisode class]];
    episode.name = @"One";
    episode.actions = @[moveact];
    [accessor saveContext];
    
    NSArray* arr = [clientAccessor1 fetchAll:[EZEpisode class] sortField:@"name"];
    EZEpisode* retEpisode = [arr objectAtIndex:0];
    EZChessMoveAction* retSna = [retEpisode.actions objectAtIndex:0];
    assert([retSna.name isEqualToString:moveact.name]);
    assert(retSna.plantMoves.count == 1);
        
    
    assert(false);
}


+ (void) testAnotherTwo
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    
    EZShowNumberAction* sna = [[EZShowNumberAction alloc] init];
    sna.curShowStep = 1;
    sna.curStartStep = 2;
    sna.preShowStep = 3;
    sna.preStartStep = 4;
    EZEpisode* episode = [accessor create:[EZEpisode class]];
    episode.name = @"One";
    episode.actions = @[sna];
    [accessor saveContext];
    
    NSArray* arr = [clientAccessor1 fetchAll:[EZEpisode class] sortField:@"name"];
    EZEpisode* retEpisode = [arr objectAtIndex:0];
    EZShowNumberAction* retSna = [retEpisode.actions objectAtIndex:0];
    assert(sna.curStartStep == retSna.curStartStep);
    assert(sna.curShowStep == retSna.curShowStep);
    assert(sna.preShowStep == retSna.preShowStep);
    assert(sna.preStartStep == retSna.preStartStep);
    
    
    assert(false);
}

//Better on case a time, keep the room clean.
+ (void) testAnotherOne
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    EZCombinedAction* combine = [[EZCombinedAction alloc] init];
    combine.name = @"combine";
    
    
    EZMarkAction* cm = [[EZMarkAction alloc] init];
    EZChessMark* mark = [[EZChessMark alloc] initWithText:@"TestMark" fontSize:10 coord:nil];
    cm.name = @"Mark";
    cm.marks = @[mark];
    

    combine.actions = @[cm];
    
    EZEpisode* episode = [accessor create:[EZEpisode class]];
    episode.name = @"Cool2";
    episode.introduction = @"A very cool guy2";
    episode.actions = @[combine];
    
    EZDEBUG(@"Before save context");
    [accessor saveContext];
    EZDEBUG(@"After save context");
    NSArray* arr = [clientAccessor1 fetchAll:[EZEpisode class] sortField:nil];
    EZDEBUG(@"Fetched all back");
    EZEpisode* retEpisode = [arr objectAtIndex:0];
    EZCombinedAction* retCm = [retEpisode.actions objectAtIndex:0];
    assert([retCm.name isEqualToString:combine.name]);
    assert(retCm.actions.count == 1);

}

+ (void) testPersistOneByOne
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    EZEpisode* episode = [accessor create:[EZEpisode class]];
    episode.name = @"Cool";
    episode.introduction = @"A very cool guy";
    
    EZMarkAction* cm = [[EZMarkAction alloc] init];
    EZChessMark* mark = [[EZChessMark alloc] initWithText:@"TestMark" fontSize:10 coord:nil];
    cm.name = @"Mark";
    cm.marks = @[mark];
    
    episode.actions = @[cm];
    [accessor saveContext];
    
    NSArray* arr = [clientAccessor1 fetchAll:[EZEpisode class] sortField:nil];
    
    EZEpisode* retEpisode = [arr objectAtIndex:0];
    EZMarkAction* retCm = [retEpisode.actions objectAtIndex:0];
    assert([retCm.name isEqualToString:cm.name]);
    assert(retCm.marks.count == 1);

    assert(false);

}

+ (void) testSimplePersist
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    EZEpisode* episode = [accessor create:[EZEpisode class]];
    episode.name = @"Cool";
    episode.introduction = @"A very cool guy";
    
    
    
    EZAction* act = [[EZAction alloc] init];
    act.syncType = 10;
    act.unitDelay = 2.9;
    act.name = @"act1";
    
    EZCleanAction* cleanAct = [[EZCleanAction alloc] init];
    EZCoord* coord = [[EZCoord alloc] init:10 y:15];
    EZChessMark* chessMark = [[EZChessMark alloc] initWithText:@"Mark" fontSize:50 coord:coord];
    cleanAct.cleanedMoves = @[coord];
    cleanAct.cleanedMarks = @[chessMark];
    cleanAct.name = @"cleanact1";
    
    episode.actions = @[act, cleanAct];
    [accessor saveContext];
    
    NSArray* arr = [clientAccessor1 fetchAll:[EZEpisode class] sortField:@"name"];
    
    
    EZEpisode* ep = [arr objectAtIndex:0];
    
    EZDEBUG(@"Immediately after fetch:%@", ep.name);
    assert([ep.name isEqualToString:episode.name]);
    
    
   
    //[accessor saveContext];
    
    //[ep.managedObjectContext refreshObject:ep mergeChanges:YES];
    
    EZDEBUG(@"Compare actions");
    EZAction* act1 = [ep.actions objectAtIndex:0];
    EZAction* act2 = [ep.actions objectAtIndex:1];
    
    EZDEBUG(@"Before exchange");
    EZCleanAction* cleanAct1 = (EZCleanAction*)act2;
    EZDEBUG(@"after cast oldName:%@, new Name:%@", act.name, act1);
    
    
    if(![act1.name isEqualToString:act.name]){
        cleanAct1 = (EZCleanAction*)act1;
        act1 = act2;
        //Make sure the sequence is right.
    }

    
    EZDEBUG(@"Class type:%@, name type:%@, act1 pointer:%i", act1.class, act1.name.class, (int)act1);
    EZDEBUG(@"Object name:%@", act1.name);
    assert([act1.name isEqualToString:act.name]);
    assert(act1.syncType == act.syncType);
    assert(act1.unitDelay == act.unitDelay);

   
    assert(cleanAct1.cleanedMarks.count == 1);
    assert(cleanAct1.cleanedMoves.count == 1);
    
    EZCoord* retCoord = [cleanAct1.cleanedMoves objectAtIndex:0];
    EZChessMark* retMark = [cleanAct1.cleanedMarks objectAtIndex:0];
    
    assert(retCoord.x == coord.x);
    assert(retCoord.y == coord.y);
    assert(retCoord.chessType == coord.chessType);
    
    
    assert(retMark.fontSize == chessMark.fontSize);
    assert([chessMark.text isEqualToString:retMark.text]);
    assert(chessMark.coord.x == coord.x);
    assert(chessMark.coord.y == coord.y);
    assert(chessMark.coord.chessType == coord.chessType);
    
    
    assert(false);
    
}


+ (void) testTransform
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* clientDB = [EZCoreAccessor getClientAccessor];
    MEpisode* episode  = [clientDB create:[MEpisode class]];
    episode.name = @"cool";
    episode.thumbNail = [EZChess2Image generateChessBoard:nil size:CGSizeMake(100, 100)];
    episode.dummy = [[EZDummyObject alloc]init];
    //episode.dummy.name = @"smart";
    
    EZDummyObject* dummy2 = [[EZDummyObject alloc] init];
    dummy2.name = @"smart dummy";
    episode.dummys = @[dummy2];
    
    [clientDB saveContext];
    
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    NSArray* arr = [clientAccessor1 fetchAll:[MEpisode class] sortField:@"name"];
    assert(arr.count == 1);
    MEpisode* res = [arr objectAtIndex:0];
    
    assert(res.thumbNail != nil);
    //assert(res.thumbNail.size.width == 100);
    //assert([@"smart" isEqualToString:res.dummy.name]);
    
    EZDummyObject* dummyInList = [res.dummys objectAtIndex:0];
    EZDEBUG(@"Dummy in list:%@", dummyInList.name);
    assert([dummyInList.name isEqualToString:dummy2.name]);
    
    EZDEBUG(@"res:%@, origin:%@, image:%@", res, episode, res.thumbNail);
    assert(false);
    
}

+ (void) testUpload
{
    EZUploader* uploader = [[EZUploader alloc] init];
    uploader.url = [NSURL URLWithString:@"http://192.168.10.104:3000/upload"];
    [uploader uploadToServer:[@"Some data" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"upload.txt" contentType:@"Joke" resultBlock:^(id sender){
        NSHTTPURLResponse* response = sender;
        EZDEBUG(@"Response detail:%i", response.statusCode);
        assert(false);
    }];
    //assert(false);
}


//What's the purpose of this test?
//Make sure the 2 accessor not interfere with each other.
+ (void) testDoubleCoreAccessor
{
    [EZCoreAccessor cleanClientDB];
    [EZCoreAccessor cleanEditorDB];
    
    EZCoreAccessor* clientAccessor = [EZCoreAccessor getClientAccessor];
    
    EZCoreAccessor* clientAccessor1 = [[EZCoreAccessor alloc] initWithDBName:ClientDB modelName:CoreDBModel];
    
    EZCoreAccessor* editorAccessor = [EZCoreAccessor getEditorAccessor];
    MEpisode* mp = [clientAccessor create:[MEpisode class]];
    mp.name = @"coolguy";
    
    MEpisode* mp2 = [clientAccessor create:[MEpisode class]];
    mp2.name = @"hotgirl";
    
    
    
    [clientAccessor saveContext];
    
    NSArray* storeObjs = [clientAccessor fetchAll:[MEpisode class] sortField:@"name"];
    assert(storeObjs.count == 2);
    
    storeObjs = [clientAccessor1 fetchAll:[MEpisode class] sortField:@"name"];
    assert(storeObjs.count == 2);
    
    NSArray* editorObjs = [editorAccessor fetchAll:[MEpisode class] sortField:nil];
    assert(editorObjs.count == 0);
    
    MEpisode* res1 = [storeObjs objectAtIndex:0];
    MEpisode* res2 = [storeObjs objectAtIndex:1];
    
    EZDEBUG(@"fetched:%@, old:%@", mp.name, res1.name);
    assert([res1.name isEqualToString:mp.name]);
    assert([res2.name isEqualToString:mp2.name]);
    
    [mp.managedObjectContext refreshObject:mp mergeChanges:NO];
    mp.name = @"coolMaster";
    //[mp.managedObjectContext]
    //I assume this time. the change will not persist anymore
    
    [clientAccessor saveContext];
    
    storeObjs = [clientAccessor1 fetchAll:[MEpisode class] sortField:@"name"];
    assert(storeObjs.count == 2);
    
    res1 = [storeObjs objectAtIndex:0];
    EZDEBUG(@"new:%@, old:%@, %i, %i", res1.name, mp.name, (int)res1, (int)mp);
    [res1.managedObjectContext refreshObject:res1 mergeChanges:YES];
    //I default the mp, so I assume the change to the MP will not update to database. s
    //Let's check how's going.
    assert([res1.name isEqualToString:mp.name]);
    EZDEBUG(@"org name:%@, cross context:%@", mp.name, res1.name);
    //Let's very if our assumption make sense or not.
    assert(false);

}


+ (void) testCoreData
{
    [EZCoreAccessor cleanClientDB];
    EZCoreAccessor* accessor = [EZCoreAccessor getClientAccessor];
    MEpisode* mp = (MEpisode*)[accessor create:[MEpisode class]];
    EZDEBUG(@"Stored object:%@", mp);
    mp.name = @"Coolguy";
    [accessor store:mp];
    NSArray* arr = [accessor fetchAll:[MEpisode class] sortField:nil];
    assert(arr.count == 1);
    
    MEpisode* fetched = [arr objectAtIndex:0];
    assert([fetched.name isEqualToString:mp.name]);
    assert(!fetched.isFault);
    //[fetched.managedObjectContext refreshObject:fetched mergeChanges:NO];
    //assert(fetched.isFault);
    fetched = nil;
    arr = nil;
    EZDEBUG(@"fetched should be released");
    
    //assert(false);
}

+ (void) testAudioActionPersist
{
    EZSoundAction* action1 = [[EZSoundAction alloc] init];
    NSURL* realURL =  [EZFileUtil fileToURL:@"Come.caf"];
    NSURL* fakeURL = [NSURL URLWithString:@"file://Come.caf"];
    EZDEBUG(@"Before to show the url string");
    EZDEBUG(@"real:%@, fake:%@", realURL.absoluteString, fakeURL.absoluteString);
    EZDEBUG(@"Real json:%@, fake:%@", realURL.proxyForJson, fakeURL.proxyForJson);
    
    //assert(false);
    action1.audioFiles = @[realURL];
    action1.currentAudio = 1;
    
    NSDictionary* actDict = action1.actionToDict;
    NSString* jsonStr = actDict.JSONRepresentation;
    EZDEBUG(@"JSON:%@", jsonStr);
    
    EZSoundAction* backAct = [[EZSoundAction alloc] initWithDict:jsonStr.JSONValue];
    assert(backAct.audioFiles.count == 1);
    NSURL* url = [backAct.audioFiles objectAtIndex:0];
    NSString* abosulteURL = url.absoluteString;
    NSString* orgURL = [[action1.audioFiles objectAtIndex:0] absoluteString];
    EZDEBUG(@"backed URL:%@, orgURL:%@", abosulteURL, orgURL);
    assert([abosulteURL isEqualToString:orgURL]);
    
    assert(false);
    
}

+ (void) testJsonArrayToArray
{
    
    id arrs = @[@""];
    id arrMutables = @[@""].mutableCopy;
    assert([[arrs class] isSubclassOfClass:[NSArray class]]);
    assert([[arrMutables class] isSubclassOfClass:[NSMutableArray class]]);
    
    EZChessMoveAction* chessMove = [[EZChessMoveAction alloc] init];
    chessMove.currentMove = 10;
    EZCoord* coord1 = [[EZCoord alloc] initChessType:kBlackChess x:10 y:11];
    EZCoord* coord2 = [[EZCoord alloc] initChessType:kWhiteChess x:12 y:13];
    chessMove.plantMoves = @[coord1, coord2];
    
    EZChessMoveAction* chessMove2 = [[EZChessMoveAction alloc] init];
    chessMove2.currentMove = 11;
    EZCoord* coord11 = [[EZCoord alloc] initChessType:kBlackChess x:5 y:11];
    EZCoord* coord12 = [[EZCoord alloc] initChessType:kWhiteChess x:7 y:13];
    chessMove2.plantMoves = @[coord11, coord12];
    
    NSArray* dictArrs = [EZAction actionsToCollections:@[chessMove, chessMove2]];
    NSString* jsonStr = dictArrs.JSONRepresentation;
    EZDEBUG(@"JSON String:%@",jsonStr);
    NSArray* actions = [EZAction collectionToActions:jsonStr.JSONValue];
    
    EZDEBUG(@"turned action is:%i", actions.count);
    EZChessMoveAction* backAct1 = [actions objectAtIndex:0];
    EZChessMoveAction* backAct2 = [actions objectAtIndex:1];
    
    assert(backAct1.currentMove == chessMove.currentMove);
    assert(backAct2.currentMove == chessMove2.currentMove);
    
    EZCoord* backCoord1 = [backAct1.plantMoves objectAtIndex:0];
    EZCoord* backCoord2 = [backAct1.plantMoves objectAtIndex:1];
    assert(coord1.x == backCoord1.x);
    assert(coord1.y == backCoord1.y);
    assert(coord1.chessType == backCoord1.chessType);
    
    assert(coord2.x == backCoord2.x);
    assert(coord2.y == backCoord2.y);
    assert(coord2.chessType == backCoord2.chessType);

    
    
    
 //   assert(false);
}

+ (void) testActionToJson
{
    EZChessMoveAction* chessMove = [[EZChessMoveAction alloc] init];
    chessMove.currentMove = 10;
    EZCoord* coord1 = [[EZCoord alloc] initChessType:kBlackChess x:10 y:11];
    EZCoord* coord2 = [[EZCoord alloc] initChessType:kWhiteChess x:12 y:13];
    chessMove.plantMoves = @[coord1, coord2];
    
    NSDictionary* dict = [chessMove actionToDict];
    NSString* jsonStr = dict.JSONRepresentation;
    
    EZDEBUG(@"The dict string:%@", jsonStr);
    NSDictionary* backDict = jsonStr.JSONValue;
    
    EZChessMoveAction* backChessMove = [EZAction dictToAction:backDict];
    assert(backChessMove.plantMoves.count == 2);
    assert(backChessMove.currentMove == 10);
    
    EZCoord* backCoord1 = [backChessMove.plantMoves objectAtIndex:0];
    EZCoord* backCoord2 = [backChessMove.plantMoves objectAtIndex:1];
    assert(coord1.x == backCoord1.x);
    assert(coord1.y == backCoord1.y);
    assert(coord1.chessType == backCoord1.chessType);
    
    assert(coord2.x == backCoord2.x);
    assert(coord2.y == backCoord2.y);
    assert(coord2.chessType == backCoord2.chessType);

    //assert(false);
}
//What's the purpose of this method, I encounter problem during using the block.
//I need this test to help me understand the block thoroughly. 
+ (void) testRecuringBlockIssue
{
    EZActionPlayer* player;// = [EZTestSuites initScript];
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

/**
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
 
 **/


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

#pragma marks To test how to turn NSObject to Json. back and forth.
+ (void) testNSObjectToJSON
{
    NSDictionary* nd = @{@"cool":@(25), @"guy":@(0.5f),@"some":@"guy"};
    NSString* jsonStr = nd.JSONRepresentation;
    EZDEBUG(@"jsonStr:%@", jsonStr);
    
    NSDictionary* jsonVal = jsonStr.JSONValue;
    NSNumber* num = [jsonVal objectForKey:@"cool"];
    assert(num.intValue == 25);
    
    NSArray* arr = @[@"coolguy", nd, jsonVal];
    
    EZDEBUG(@"Arr string:%@", arr.JSONRepresentation);
    
    NSArray* jsonArr = arr.JSONRepresentation.JSONValue;
    assert(jsonArr.count == 3);
    
    NSDictionary* jsonDict = [jsonArr objectAtIndex:1];
    assert([@"guy" isEqualToString:[jsonDict objectForKey:@"some"]]);
    
    
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
