//
//  ZOLRegisterViewController.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOLDataStore.h"
#import "User.h"
#import "User+CoreDataProperties.h"

@interface ZOLRegisterViewController : UIViewController

@property (nonatomic, strong) ZOLDataStore *dataStore;

@end
