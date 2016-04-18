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
        
        NSLog(@"User record fetched");
        if (error)
        {
            NSLog(@"Error fetching User Record ID: %@", error.localizedDescription);
        }
        
        idForUser = recordID;
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    if (self)
    {
        NSLog(@"Initializing User properties");
        _userID = idForUser;
        _userHoneymoon = [[ZOLHoneymoon alloc]init];
        _client = [[ZOLCloudKitClient alloc]init];
    }
    
    CKReference *referenceToUser = [[CKReference alloc]initWithRecordID:self.userID action:CKReferenceActionDeleteSelf];
    NSPredicate *userSearch = [NSPredicate predicateWithFormat:@"User == %@", referenceToUser];
    CKQuery *findHoneymoon = [[CKQuery alloc]initWithRecordType:@"Honeymoon" predicate:userSearch];
    CKQueryOperation *findHMOp = [[CKQueryOperation alloc]initWithQuery:findHoneymoon];
    findHMOp.resultsLimit = 1;
    
    dispatch_semaphore_t honeymoonSemaphore = dispatch_semaphore_create(0);
    
    __block BOOL errorOccured = NO;
    findHMOp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *operationError){
        
        NSLog(@"Queried for user honeymoon");
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
        NSLog(@"No honeymoon found, creating blank");
        [self createBlankHoneymoon];
    }
    else
    {
        NSLog(@"Honeymoon found, populating images");
        [self.userHoneymoon populateHoneymoonImages];
    }

    return self;
}

-(void)createBlankHoneymoon
{
    CKRecord *newHoneymoon = [[CKRecord alloc]initWithRecordType:@"Honeymoon"];
    CKReference *referenceToUser = [[CKReference alloc]initWithRecordID:self.userID action:CKReferenceActionDeleteSelf];
    newHoneymoon[@"User"] = referenceToUser;
    newHoneymoon[@"Published"] = @"NO";
    
    [self.client saveRecord:newHoneymoon toDataBase:self.client.database];
    self.userHoneymoon.honeymoonID = newHoneymoon.recordID;
}

@end
