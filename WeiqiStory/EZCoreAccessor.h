//
//  EZCoreAccessor.h
//  SqueezitProto
//
//  Created by Apple on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//I assume this is the facade to CoreData, All the core data interaction are through him.
//That's my current assumption. Unless more information disclosed other wise. 
@interface EZCoreAccessor : NSObject {
    
}

//Generate a new DB instance
+ (void) invalidateInstance:(NSString*)dbName;

+ (EZCoreAccessor*) getInstance:(NSString*)dbName;

+ (EZCoreAccessor*) getClientAccessor;

+ (EZCoreAccessor*) getEditorAccessor;

+ (void) cleanClientDB;

+ (void) cleanEditorDB;


//+ (void) setInstance:(EZCoreAccessor*)inst;

+ (NSURL *)applicationDocumentsDirectory;

//Clean the database, if you change the model, the model and exist data base will have a mismatch,
//Need to clean the data for it. 
//What you should do?
//Keep the old data, and do a migration of it.
+ (void) cleanDB:(NSString*)fileName;

//All NSManagedObject should be instantiated from here
- (id) create:(Class)classType;

//po for persistent object
- (BOOL) store:(NSManagedObject*)po;

//Will remove it from storage
- (BOOL) remove:(NSManagedObject*)po;

//If passing nil, System will use "name" to sort the result.
- (NSArray*) fetchAll:(Class)classType sortField:(NSString*)fieldName;

- (id) fetchByID:(NSManagedObjectID*)oid;

- (NSInteger) count:(Class)classType;

- (NSArray*) fetchObject:(Class)classType begin:(NSInteger)begin limit:(NSInteger)limit;

//Fetch object by the specified predication
- (NSArray*) fetchObject:(Class)classType byPredicate:(NSPredicate*)predicate withSortField:(NSString*)sortField;

- (id) initWithDBName:(NSString*)dbName modelName:(NSString*)modelName;

- (void)saveContext;

- (void)performBlock:(void (^)())block;
- (void)performBlockAndWait:(void (^)())block;

@property (strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) NSManagedObjectModel* model;
@property (strong, nonatomic) NSPersistentStoreCoordinator* coordinator;

@end
