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


+(void)savePublicFeed:(NSString *)feedName;

+(void)savePrivateRecord:(CKDatabase *)database record:(CKRecord *)record;

+(void)fetchRecordID:(CKRecordID *)recordID getTheRecord: (CKRecord *)record;

@end
