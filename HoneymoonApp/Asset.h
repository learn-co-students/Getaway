//
//  Asset.h
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/5/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import "CloudKitDataBase.h"
#import <UIKit/UIKit.h>


@interface Asset : CKAsset

@property (strong, nonatomic) CloudKitDataBase *datastore;
@property (strong, nonatomic) UIImage *testImage;


@end
