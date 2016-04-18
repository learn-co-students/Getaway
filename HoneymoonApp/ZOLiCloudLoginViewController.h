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


//#import "ZOLMainTableViewController.h"

@interface ZOLiCloudLoginViewController : UIViewController

@property (strong, nonatomic) ZOLDataStore *dataStore;
@property (nonatomic, strong) CKRecordID *idForUser;
//@property (nonatomic, strong) ZOLUser *idForUserClass;


-(BOOL)doWeHaveInternetAccess;
- (void)presentNextVC;
//- (void)loginNewUser;
- (void)zolaAppWillWaitForYou;
- (void)tellAppDelegateTheUserDoesntHaveiCloudAccount;



@end
