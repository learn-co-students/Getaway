//
//  ZOLCloudKitClient.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/11/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLCloudKitClient.h"

@implementation ZOLCloudKitClient

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _database = [[CKContainer defaultContainer] publicCloudDatabase];
        _privateDB = [[CKContainer defaultContainer] privateCloudDatabase];
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

-(void)saveRecord:(CKRecord *)record toDataBase:(CKDatabase *)database
{
    CKModifyRecordsOperation *saveRecordOp = [[CKModifyRecordsOperation alloc]initWithRecordsToSave:@[record] recordIDsToDelete:nil];
    saveRecordOp.modifyRecordsCompletionBlock = ^(NSArray <CKRecord *> *savedRecords, NSArray <CKRecordID *> *deletedRecordIDs, NSError *operationError){
        if (operationError)
        {
            NSLog(@"%@", operationError.localizedDescription);
        }
    };
    
    [database addOperation:saveRecordOp];
}


@end
