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
    dispatch_once(&onceToken, ^
    {
        NSLog(@"about to init data store for the first time.");
        _sharedDataStore = [[ZOLDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _user = [[ZOLUser alloc] init];
        _client = [[ZOLCloudKitClient alloc]init];
        _mainFeed = [[NSMutableArray alloc]init];
    }

    return self;
}

-(void)populateMainFeedWithCompletion:(void (^)(NSError *error))completionBlock
{
    NSPredicate *publishedHoneymoons = [NSPredicate predicateWithFormat:@"%K BEGINSWITH %@", @"Published", @"YES"];
    CKQuery *intializeMainFeed = [[CKQuery alloc]initWithRecordType:@"Honeymoon" predicate:publishedHoneymoons];
    NSArray *keysNeeded = @[@"Description", @"Published", @"RatingStars", @"Name"];
    
    [self.client queryRecordsWithQuery:intializeMainFeed orCursor:nil fromDatabase:self.client.database forKeys:keysNeeded withQoS:NSQualityOfServiceDefault everyRecord:^(CKRecord *record)
    {
        ZOLHoneymoon *thisHoneymoon = [[ZOLHoneymoon alloc]init];
        
        CKAsset *coverPictureAsset = record[@"CoverPicture"];
        UIImage *coverPic = [self.client retrieveUIImageFromAsset:coverPictureAsset];
        thisHoneymoon.coverPicture = coverPic;
        
        NSNumber *ratingVal = record[@"RatingStars"];
        thisHoneymoon.rating = [ratingVal floatValue];
        thisHoneymoon.honeymoonDescription = record[@"Description"];
        thisHoneymoon.honeymoonID = record.recordID;
        thisHoneymoon.userName = record[@"Name"];
        thisHoneymoon.createdDate = record.creationDate;
        
        CKReference *honeymoonRef = [[CKReference alloc]initWithRecordID:thisHoneymoon.honeymoonID action:CKReferenceActionDeleteSelf];
        NSPredicate *findImages = [NSPredicate predicateWithFormat:@"%K == %@", @"Honeymoon", honeymoonRef];
        CKQuery *findImagesQuery = [[CKQuery alloc]initWithRecordType:@"Image" predicate:findImages];
        NSArray *captionKey = @[@"Caption", @"Honeymoon"];
        
        [self.client queryRecordsWithQuery:findImagesQuery orCursor:nil fromDatabase:self.client.database forKeys:captionKey withQoS:NSQualityOfServiceUserInitiated everyRecord:^(CKRecord *record)
        {
            ZOLImage *thisImage = [[ZOLImage alloc]init];
            thisImage.caption = record[@"Caption"];
            thisImage.imageRecordID = record.recordID;
            
            [thisHoneymoon.honeymoonImages addObject:thisImage];
        } completionBlock:^(CKQueryCursor *cursor, NSError *error)
        {
            if (error)
            {
                NSLog(@"Error finding images for a honeymoon: %@", error.localizedDescription);
            }
        }];
        
        [self.mainFeed addObject:thisHoneymoon];
    } completionBlock:^(CKQueryCursor *cursor, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error initializing main feed: %@", error.localizedDescription);
            
            completionBlock(error);
        }
        else
        {
            self.mainFeedCursor = cursor;
                   
            NSLog(@"MainFeedPopulated message sent");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MainFeedPopulated" object:nil];   

            completionBlock(nil);
        }
    }];
}

-(void)displayGenericError
{
    UIAlertController *genericErrorAlert = [UIAlertController alertControllerWithTitle:@"An Error Occured" message:@"Please check your internet connection, if the problem persists contact the Getaway Team" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    
    [genericErrorAlert addAction:dismiss];
        
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:genericErrorAlert animated:YES completion:nil];
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
