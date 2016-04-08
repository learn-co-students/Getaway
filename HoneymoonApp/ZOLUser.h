//
//  ZOLUser.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/7/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@interface ZOLUser : NSObject

@property (nonatomic, strong) CKRecordID *userID;
@property (nonatomic, strong) CKRecordID *honeymoonID;

@end
