//
//  ZOLCloudKitClient.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/11/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import <UIKit/UIKit.h>

@interface ZOLCloudKitClient : NSObject

@property (nonatomic) CKDatabase *database;
@property (nonatomic, strong) CKDatabase *privateDB;

-(NSURL *)writeImage:(UIImage *)image toTemporaryDirectoryWithQuality:(CGFloat)compressionQuality;
-(CKRecord *)fetchRecordWithRecordID:(CKRecordID *)recordID;
-(void)saveRecord:(CKRecord *)record toDataBase:(CKDatabase *)database;

@end
