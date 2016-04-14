//
//  ZOLCloudKitClient.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/11/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//
//This client should handle most traffic between the CloudKit database and the application

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import <UIKit/UIKit.h>

@interface ZOLCloudKitClient : NSObject

@property (nonatomic) CKDatabase *database;
@property (nonatomic, strong) CKDatabase *privateDB;

-(NSURL *)writeImage:(UIImage *)image toTemporaryDirectoryWithQuality:(CGFloat)compressionQuality;
-(CKRecord *)fetchRecordWithRecordID:(CKRecordID *)recordID;
-(void)saveRecord:(CKRecord *)record toDataBase:(CKDatabase *)database;
-(UIImage *)retrieveUIImageFromAsset: (CKAsset *)asset;
-(void)queryRecordsWithQuery: (CKQuery *)query
                    orCursor: (CKQueryCursor *)cursor
                fromDatabase: (CKDatabase *)database
                 everyRecord: (void(^)(CKRecord *record))recordBlock
             completionBlock: (void(^)(CKQueryCursor *cursor, NSError *error))completionBlock;

@end
