//
//  ZOLProfileViewController.h
//  HoneymoonApp
//
//  Created by Jennifer A Sipila on 4/18/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOLDataStore.h"

@interface ZOLProfileViewController : UIViewController
@property(nonatomic) BOOL isComingFromCamera;
@property (nonatomic, strong) ZOLDataStore *dataStore;

@end
