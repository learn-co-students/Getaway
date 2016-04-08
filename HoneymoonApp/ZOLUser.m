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
    }
    
    return self;
}

@end
