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

//Write an image to a temp file to facilitate creating a CKAsset
-(NSURL *)writeImage:(UIImage *)image toTemporaryDirectoryWithQuality:(CGFloat)compressionQuality
{
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"newImageUpload.tmp"];
    
    NSURL *tempFile = [NSURL fileURLWithPath:path];
    
    NSData *imageData = UIImageJPEGRepresentation(image, compressionQuality);
    
    [imageData writeToURL:tempFile atomically:YES];
    
    return tempFile;
}

//Create a UIImage object from a fetched CKAsset
-(UIImage *)retrieveUIImageFromAsset:(CKAsset *)asset
{
    NSURL *imageURL = asset.fileURL;
    NSData *imageData = [NSData dataWithContentsOfFile:imageURL.path];
    UIImage *picture = [UIImage imageWithData:imageData];
    
    return picture;
}

//Fetch and return the object with the given CKRecordID
-(CKRecord *)fetchRecordWithRecordID:(CKRecordID *)recordID
{
    __block CKRecord *recordToFetch;
    
    dispatch_semaphore_t recordSem = dispatch_semaphore_create(0);
    
    [self.database fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"There was an error fetching the HoneyMoon public record. Error type: %@", error.localizedDescription);
        }
        else
        {
            recordToFetch = record;
        }
        dispatch_semaphore_signal(recordSem);
    }];
    
    dispatch_semaphore_wait(recordSem, DISPATCH_TIME_FOREVER);
    return recordToFetch;
};

//Save a CKRecord to the CloudKit database
-(void)saveRecord:(CKRecord *)record toDataBase:(CKDatabase *)database
{
    CKModifyRecordsOperation *saveRecordOp = [[CKModifyRecordsOperation alloc]initWithRecordsToSave:@[record] recordIDsToDelete:nil];
    saveRecordOp.modifyRecordsCompletionBlock = ^(NSArray <CKRecord *> *savedRecords, NSArray <CKRecordID *> *deletedRecordIDs, NSError *operationError){
        if (operationError)
        {
            NSLog(@"Error saving a record: %@", operationError.localizedDescription);
        }
    };
    
    [database addOperation:saveRecordOp];
}

//DO NOT pass both a query and a cursor into this, one or the other must be nil
-(void)queryRecordsWithQuery: (CKQuery *)query
                    orCursor: (CKQueryCursor *)cursor
                fromDatabase: (CKDatabase *)database
                     forKeys: (NSArray *)keys
                 everyRecord: (void(^)(CKRecord *record))recordBlock
             completionBlock: (void(^)(CKQueryCursor *cursor, NSError *error))completionBlock
{
    CKQueryOperation *operation;
    
    if (query && !cursor)
    {
        operation = [[CKQueryOperation alloc] initWithQuery: query];
        
    }
    else if (cursor && !query)
    {
        operation = [[CKQueryOperation alloc] initWithCursor: cursor];
    }
    else
    {
        NSLog(@"queryRecordsWithQuery needs a query OR cursor, not both or neither");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QueryRefreshIssue" object:nil];
        
    }
    
    operation.desiredKeys = keys;
//    operation.resultsLimit = 3;
    operation.recordFetchedBlock = ^(CKRecord *record)
    {
        recordBlock(record);
    };
    
    operation.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
    {
        completionBlock(cursor, error);
    };
    
    if (operation)
    {
        [database addOperation: operation];
    }
}

@end
