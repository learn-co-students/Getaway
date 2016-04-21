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
        NSLog(@"Initializing User properties");
        _userHoneymoon = [[ZOLHoneymoon alloc]init];
        _client = [[ZOLCloudKitClient alloc]init];
        _username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    }
    
    return self;
}

- (void)getAllTheRecords {
    
    NSLog(@"get all the records");
    if (self.userID) {
        
        CKReference *referenceToUser = [[CKReference alloc]initWithRecordID:self.userID action:CKReferenceActionDeleteSelf];
        NSPredicate *userSearch = [NSPredicate predicateWithFormat:@"%K == %@", @"User", referenceToUser];
        CKQuery *findHoneymoon = [[CKQuery alloc]initWithRecordType:@"Honeymoon" predicate:userSearch];
        CKQueryOperation *findHMOp = [[CKQueryOperation alloc]initWithQuery:findHoneymoon];
        findHMOp.resultsLimit = 1;
        
        __block CKRecord *userHoneyMoon;
        findHMOp.recordFetchedBlock = ^(CKRecord *record){
            userHoneyMoon = record;
            self.userHoneymoon.honeymoonID = record.recordID;
        };
        
        __block BOOL errorOccured = NO;
        findHMOp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *operationError){
            
            if (operationError)
            {
                NSLog(@"Error searching for user honeymoon, description: %@, and code: %lu, and heck, heres the domain: %@", operationError.localizedDescription, operationError.code, operationError.domain);
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"HoneymoonError" object:nil];

                errorOccured = YES;
            }
            
            if (!userHoneyMoon && !errorOccured)
            {
                [self createBlankHoneymoon];
            }
            else
            {
                [self.userHoneymoon populateHoneymoonImages];
            }
        };
        
        [[[CKContainer defaultContainer] publicCloudDatabase] addOperation:findHMOp];
    }
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
