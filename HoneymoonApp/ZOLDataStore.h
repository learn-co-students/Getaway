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
#import "User.h"

@interface ZOLDataStore : NSObject

//CORE DATA
//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSMutableArray *feed;
@property (nonatomic, strong) CKRecordID *userID;

@property (nonatomic) CKDatabase *database;
@property (nonatomic, strong) CKDatabase *privateDB;

@property (nonatomic, strong) NSMutableArray *fetchedRecords;
//@property(nonatomic, assign) NSUInteger cursorLimit; only implement this if the auto limit doesn't do the job. 

//CORE DATA
//- (void)saveContext;
//- (void)fetchData;
//- (NSURL *)applicationDocumentsDirectory;

+ (instancetype) dataStore;

-(void)saveRecord: (CKRecord *)record toDataBase: (CKDatabase *)database;

-(void)fetchCKAssetWithCompletion:(void(^)(void))sendToCurser;

-(CKRecord *)fetchRecordWithRecordID:(CKRecordID *)recordID;

-(NSURL *)writeImage:(UIImage *)image toTemporaryDirectoryWithQuality:(CGFloat)compressionQuality;

@end
