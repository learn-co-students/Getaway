//
//  ZOLUser.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/7/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "ZOLHoneymoon.h"
#import "ZOLCloudKitClient.h"
#import "ZOLiCloudLoginViewController.h"

@interface ZOLUser : NSObject

@property (nonatomic, strong) CKRecordID *userID;
@property (nonatomic, strong) ZOLHoneymoon *userHoneymoon;
@property (nonatomic, strong) ZOLCloudKitClient *client;
@property (nonatomic, strong) ZOLUser *idForUser;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

- (void)getAllTheRecords;
- (void)createBlankHoneymoon;


@end
