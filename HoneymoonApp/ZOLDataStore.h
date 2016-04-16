//
//  ZOLDataStore.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>
#import <UIKit/UIKit.h>
#import "ZOLUser.h"
#import "ZOLCloudKitClient.h"

@interface ZOLDataStore : NSObject

//CORE DATA
//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSMutableArray *mainFeed;
@property (nonatomic, strong) CKQueryCursor *mainFeedCursor;

@property (nonatomic, strong) ZOLUser *user;
@property (nonatomic, strong) ZOLCloudKitClient *client;


@property (nonatomic, strong) NSMutableArray *fetchedRecords;
//@property(nonatomic, assign) NSUInteger cursorLimit; only implement this if the auto limit doesn't do the job.
@property (readwrite) double doubleValue;




//CORE DATA
//- (void)saveContext;
//- (void)fetchData;
//- (NSURL *)applicationDocumentsDirectory;

+ (instancetype) dataStore;
-(void)populateMainFeedWithCompletion:(void (^)(NSError *error))completionBlock;


//-(void)saveRecord: (CKRecord *)record toDataBase: (CKDatabase *)database;

//-(void)fetchCKAssetWithCompletion:(void(^)(void))sendToCurser;

//-(CKRecord *)fetchRecordWithRecordID:(CKRecordID *)recordID;
//-(CKRecord *)fetchRecordWithID:(CKRecordID *)recordID completionHandler:(void(^)(void))CKRecord;


//-(NSURL *)writeImage:(UIImage *)image toTemporaryDirectoryWithQuality:(CGFloat)compressionQuality;

//error handling for updating altered asset
//-(void)retryUpdatingWebServiceSettingsAfter:(double) secondsToRetry;


@end
