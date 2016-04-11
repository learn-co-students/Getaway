//
//  AppDelegate.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/29/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CloudKit/CloudKit.h>
#import "ZOLDataStore.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ZOLDataStore *database;


@end

