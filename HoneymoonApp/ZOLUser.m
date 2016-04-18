//
//  ZOLUser.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/7/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLUser.h"



@implementation ZOLUser



-(instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        
        _userHoneymoon = [[ZOLHoneymoon alloc]init];
        _client = [[ZOLCloudKitClient alloc]init];
    }
    
    return self;
}

- (void)getAllTheRecords {
    
    if (self.userID) {
        
        CKReference *referenceToUser = [[CKReference alloc]initWithRecordID:self.userID action:CKReferenceActionDeleteSelf];
        NSPredicate *userSearch = [NSPredicate predicateWithFormat:@"User == %@", referenceToUser];
        CKQuery *findHoneymoon = [[CKQuery alloc]initWithRecordType:@"Honeymoon" predicate:userSearch];
        CKQueryOperation *findHMOp = [[CKQueryOperation alloc]initWithQuery:findHoneymoon];
        findHMOp.resultsLimit = 1;
        
        dispatch_semaphore_t honeymoonSemaphore = dispatch_semaphore_create(0);
        
        __block BOOL errorOccured = NO;
        findHMOp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *operationError){
            
            if (operationError)
            {
                NSLog(@"Error searching for user honeymoon, description: %@, and code: %lu, and heck, heres the domain: %@", operationError.localizedDescription, operationError.code, operationError.domain);
                errorOccured = YES;
            }
            
            dispatch_semaphore_signal(honeymoonSemaphore);
        };
        
        __block CKRecord *userHoneyMoon;
        findHMOp.recordFetchedBlock = ^(CKRecord *record){
            userHoneyMoon = record;
            self.userHoneymoon.honeymoonID = record.recordID;
        };
        
        [[[CKContainer defaultContainer] publicCloudDatabase] addOperation:findHMOp];
        dispatch_semaphore_wait(honeymoonSemaphore, DISPATCH_TIME_FOREVER);
        
        if (!userHoneyMoon && !errorOccured)
        {
            [self createBlankHoneyMoon];
        }
        else
        {
            [self.userHoneymoon populateHoneymoonImages];
        }
        
    }
    
    
}

-(void)createBlankHoneyMoon
{
    CKRecord *newHoneyMoon = [[CKRecord alloc]initWithRecordType:@"Honeymoon"];
    CKReference *referenceToUser = [[CKReference alloc]initWithRecordID:self.userID action:CKReferenceActionDeleteSelf];
    newHoneyMoon[@"User"] = referenceToUser;
    
    [self.client saveRecord:newHoneyMoon toDataBase:self.client.database];
    self.userHoneymoon.honeymoonID = newHoneyMoon.recordID;
}

@end
