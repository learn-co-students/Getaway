//
//  ZOLDataStore.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLDataStore.h"

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
        _database = [[CKContainer defaultContainer] publicCloudDatabase];
        _privateDB = [[CKContainer defaultContainer] privateCloudDatabase];
        _user = [[ZOLUser alloc]init];
//        _honeymoonID
    }
    
    return self;
}

-(NSURL *)writeImage:(UIImage *)image toTemporaryDirectoryWithQuality:(CGFloat)compressionQuality
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"newImageUpload.tmp"];
    
    NSURL *tempFile = [NSURL fileURLWithPath:path];
    
    NSData *imageData = UIImageJPEGRepresentation(image, compressionQuality);
    
    [imageData writeToURL:tempFile atomically:YES];
    
    return tempFile;
}

-(CKRecord *)fetchRecordWithRecordID:(CKRecordID *)recordID
{
    __block CKRecord *recordToFetch;
    
    [self.database fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"There was an error fetching the HoneyMoon public record. Error type: %@", error.localizedDescription);
        }
        else
        {
            recordToFetch = record;
        }
    }];
    
    return recordToFetch;
};

// if we want to write a file:
-(void)writeARecord:(CKDatabase *)publicDatabase
{
    
    CKRecordID *publicRecordID = [[CKRecordID alloc]initWithRecordName:@""];
    [self.database fetchRecordWithID:publicRecordID completionHandler:^(CKRecord *publicRecord, NSError *error) {
        if (publicRecord != nil) {
            NSString *name = publicRecord[@"ARecord"];
            publicRecord[@"name"] = [name stringByAppendingString:@"aNewRecordItem"];
            
            [publicDatabase saveRecord:publicRecord completionHandler:^(CKRecord *savedPlace, NSError *savedError) {
                NSLog(@"Could not edit public database");
            }];
        }
    }];
}

-(void)saveRecord:(CKRecord *)record toDataBase:(CKDatabase *)database
{
//    dispatch_semaphore_t saveSem = dispatch_semaphore_create(0);
    CKModifyRecordsOperation *saveRecordOp = [[CKModifyRecordsOperation alloc]initWithRecordsToSave:@[record] recordIDsToDelete:nil];
    saveRecordOp.modifyRecordsCompletionBlock = ^(NSArray <CKRecord *> *savedRecords, NSArray <CKRecordID *> *deletedRecordIDs, NSError *operationError){
        if (operationError)
        {
            NSLog(@"%@", operationError.localizedDescription);
        }
//        dispatch_semaphore_signal(saveSem);
    };
    
    [database addOperation:saveRecordOp];
//    dispatch_semaphore_wait(saveSem, DISPATCH_TIME_FOREVER);
    
//    [database saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
//        
//        if (error)
//        {
//            NSLog(@"The public record data could not be saved. Error type: %@", error.localizedDescription);
//            
//            if (CKErrorNetworkUnavailable) {
//                NSLog(@"The public data could not be saved due to a bad network connection");
//                double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
//                NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
//            }
//            if (CKErrorNetworkFailure) {
//                NSLog(@"The public data could not be saved because of a Network Failure");
//                double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
//                NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
//            }
//            if (error == nil) {
//                NSLog(@"We saved some data! What did we save you ask? This thing:%@", record.description);
//            }
//        }
//    }];
}

//we may not want to implement private data (maybe save userName for next login?? and email?)
//saving private feed-->after iCloud signin is verified :p


//grab an image from CloudKit
-(void)fetchCKAsset{
    
    CKQuery *imageQuery = [[CKQuery alloc]initWithRecordType:@"Image" predicate: [NSPredicate predicateWithFormat:@"Caption = %@", @"fakeImage"]];
    
    [self.database performQuery:imageQuery inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        
        if (error){
            NSLog(@"ERROR for querying the public DB. Error type: %@", error.localizedDescription);
        }
        
        NSArray *newImageArray = [[NSArray alloc]init];
        [newImageArray arrayByAddingObject:results];
        
        
        CKRecord *firstImage = newImageArray[0];
        CKAsset *imageOne = firstImage[@"Picture"];
        
        NSData *data = [NSData dataWithContentsOfURL:imageOne.fileURL];
//        UIImage *anActulPicture =[UIImage imageWithData:data];
        //self.testImage.image = anActulPicture;
        
    }];
    
}

//CORE DATA
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
