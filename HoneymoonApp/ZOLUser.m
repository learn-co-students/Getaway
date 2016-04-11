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
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    
    __block CKRecordID *idForUser;
    [defaultContainer fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        idForUser = recordID;
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (self)
    {
        _userID = idForUser;
        _userHoneymoon = [[ZOLHoneymoon alloc]init];
        _client = [[ZOLCloudKitClient alloc]init];
    }
    
    CKReference *referenceToUser = [[CKReference alloc]initWithRecordID:self.userID action:CKReferenceActionDeleteSelf];
    NSPredicate *userSearch = [NSPredicate predicateWithFormat:@"User == %@", referenceToUser];
    CKQuery *findHoneymoon = [[CKQuery alloc]initWithRecordType:@"Honeymoon" predicate:userSearch];
    CKQueryOperation *findHMOp = [[CKQueryOperation alloc]initWithQuery:findHoneymoon];
    findHMOp.resultsLimit = 1;
    
    dispatch_semaphore_t loginSemaphore = dispatch_semaphore_create(0);
    findHMOp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *operationError){
        
        if (operationError)
        {
            NSLog(@"Obviously this is an error, but heres the description: %@, and code: %lu, and heck, heres the domain: %@", operationError.localizedDescription, operationError.code, operationError.domain);
        }
        
        dispatch_semaphore_signal(loginSemaphore);
    };
    
    __block CKRecord *userHoneyMoon;
    findHMOp.recordFetchedBlock = ^(CKRecord *record){
        userHoneyMoon = record;
        self.userHoneymoon.honeymoonID = record.recordID;
    };
    
    [[[CKContainer defaultContainer] publicCloudDatabase] addOperation:findHMOp];
    dispatch_semaphore_wait(loginSemaphore, DISPATCH_TIME_FOREVER);
    
    if (!userHoneyMoon)
    {
        [self createBlankHoneyMoon];
    }

    return self;
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
