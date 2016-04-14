//
//  ZOLDataStore.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLDataStore.h"

#import "ZOLDetailTableViewController.h"

#import "ZOLTabBarViewController.h"

@implementation ZOLDataStore

# pragma mark - Singleton

+ (instancetype)dataStore
{
    static ZOLDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[ZOLDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _user = [[ZOLUser alloc]init];
        _client = [[ZOLCloudKitClient alloc]init];
        _mainFeed = [[NSMutableArray alloc]init];
    }

    return self;
}

-(void)populateMainFeed
{
    NSPredicate *publishedHoneymoons = [NSPredicate predicateWithFormat:@"%K BEGINSWITH %@", @"Published", @"YES"];
    CKQuery *intializeMainFeed = [[CKQuery alloc]initWithRecordType:@"Honeymoon" predicate:publishedHoneymoons];
    
    [self.client queryRecordsWithQuery:intializeMainFeed orCursor:nil fromDatabase:self.client.database everyRecord:^(CKRecord *record) {
        ZOLHoneymoon *thisHoneymoon = [[ZOLHoneymoon alloc]init];
        
        CKAsset *coverPictureAsset = record[@"CoverPicture"];
        UIImage *coverPic = [self.client retrieveUIImageFromAsset:coverPictureAsset];
        thisHoneymoon.coverPicture = coverPic;
        
        NSNumber *ratingVal = record[@"RatingStars"];
        thisHoneymoon.rating = [ratingVal floatValue];
        
        thisHoneymoon.honeymoonDescription = record[@"Description"];
        
        [self.mainFeed insertObject:thisHoneymoon atIndex:0];
    } completionBlock:^(CKQueryCursor *cursor, NSError *error) {
        if (error)
        {
            NSLog(@"Error initializing main feed: %@", error.localizedDescription);
        }
        else
        {
            self.mainFeedCursor = cursor;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MainFeedPopulated" object:nil];
        }
    }];
}

- (void)readRecords_Resurs:(CKDatabase *)database
                     query:(CKQuery *)query
                    cursor:(CKQueryCursor *)cursor
{
    
    CKQueryOperation *operation;
 
//(1)first time through we are passing in a query and will enter the else statement:
    if (query != nil) {
        operation = [[CKQueryOperation alloc] initWithQuery: query];
        
    } else {
        operation = [[CKQueryOperation alloc] initWithCursor: cursor];
    }
//(we enter the block below, fetch the record)
    operation.recordFetchedBlock = ^(CKRecord *record) {
        
        [self.fetchedRecords addObject:record];
    };
    operation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error) {
        BOOL noMoreCursorsAvailable = cursor == nil;
        BOOL weHaveAnError = error != nil;
        
        if (noMoreCursorsAvailable || weHaveAnError) {
            
// We're done in the event that there are no more crusors or an error occured
            dispatch_async(dispatch_get_main_queue(), ^{ [self readRecordsDone: error == nil ? nil : [error localizedDescription]]; });
        }
        else {
// If we don't have an error and there is another cursor, get next batch (using cursors until crusor == nil)
            dispatch_async(dispatch_get_main_queue(), ^{ [self readRecords_Resurs: database query: nil cursor: cursor]; });
            
        }
    };
    
    [database addOperation: operation]; // when we FIRST hit this method, this is when the cursor first comes into play, until this line of code, we are only dealing with the fetching the query. Afeter we hit this line, we begin using the cursor.
 
    
}

- (void)readRecordsDone: (NSString *)errorMsg
{
    if (errorMsg) {
        NSLog(@"Error: %@", errorMsg.description); //OR errorMesg OR errorMesg.debugDescription
    }
    
    else{
        
        NSLog(@"all batches are finished!");
 
    }
    
    //Do we need to set up a NSNotification to let the tableview know the record is finished/fully loaded?
}

# pragma mark - Core Data stack

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "https---learn.co.HoneymoonApp" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HoneymoonApp" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HoneymoonApp.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}
//
//#pragma mark - Core Data Fetch
//
////-(void)fetchData
////{
////    NSFetchRequest *requestData = [NSFetchRequest fetchRequestWithEntityName:@"User"];
////    self.users = [self.managedObjectContext executeFetchRequest:requestData error:nil];
////    if (self.users.count == 0)
////    {
////        User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
////        newUser.username = @"Sam";
////        newUser.password = @"1234567";
////        
////        [self saveContext];
////    }
////}
//
@end
