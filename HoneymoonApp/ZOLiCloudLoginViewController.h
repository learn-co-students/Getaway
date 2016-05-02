//
//  ZOLiCloudLoginViewController.h
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/14/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@class ZOLDataStore;

@interface ZOLiCloudLoginViewController : UIViewController

@property (strong, nonatomic) ZOLDataStore *dataStore;
@property (nonatomic, strong) CKRecordID *idForUser;

- (void)presentNextVC;
- (void)zolaAppWillWaitForYou;
- (void)tellAppDelegateTheUserDoesntHaveiCloudAccount;



@end
