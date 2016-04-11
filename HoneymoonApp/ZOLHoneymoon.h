//
//  ZOLHoneymoon.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/8/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>


@interface ZOLHoneymoon : NSObject

@property (nonatomic, strong) CKRecordID *honeymoonID;
@property (nonatomic, strong) NSMutableArray *honeymoonImages;

@end
