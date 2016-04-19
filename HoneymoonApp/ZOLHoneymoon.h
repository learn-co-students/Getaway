//
//  ZOLHoneymoon.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/8/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "ZOLCloudKitClient.h"
#import "ZOLImage.h"

@interface ZOLHoneymoon : NSObject

@property (nonatomic, strong) CKRecordID *honeymoonID;
@property (nonatomic, strong) NSMutableArray *honeymoonImages;
@property (nonatomic, strong) ZOLCloudKitClient *client;
@property (nonatomic, strong) UIImage *coverPicture;
@property (nonatomic, assign) CGFloat rating;
@property (nonatomic, strong) NSString *honeymoonDescription;
@property (nonatomic, strong) NSString *published;
@property (nonatomic, strong) NSString *userName;

-(void)populateHoneymoonImages;

@end
