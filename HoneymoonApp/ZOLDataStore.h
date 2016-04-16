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

//CORE DATA
//- (void)saveContext;
//- (void)fetchData;
//- (NSURL *)applicationDocumentsDirectory;

+ (instancetype) dataStore;
-(void)populateMainFeed;

@end
