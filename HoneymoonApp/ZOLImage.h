//
//  ZOLImage.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/11/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface ZOLImage : NSObject

@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, strong) CKRecordID *imageRecordID;

@end
