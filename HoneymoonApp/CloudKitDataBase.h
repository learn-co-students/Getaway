//
//  CloudKitDataBase.h
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/4/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@interface CloudKitDataBase : NSObject

@property (strong, nonatomic) CKContainer *zolContainer;
@property (strong, nonatomic) CKDatabase *privateDatabase;
@property (strong, nonatomic) CKDatabase *publicDatabase;
@property (strong, nonatomic) CKRecord *userRecord;
@property (strong, nonatomic) CKRecord *ImageRecord;
@property (strong, nonatomic) CKRecord *HoneyMoonRecord;


+ (instancetype)sharedData;

-(void)savePublicRecord:(CKDatabase *)publicDatabase record:(CKRecord *)record;

-(void)savePrivateRecord:(CKDatabase *)privateDatabase record:(CKRecord *)record;

-(void)fetchRecordID:(CKRecordID *)recordID getTheRecord: (CKRecord *)record;

@end
