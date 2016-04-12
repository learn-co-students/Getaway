//
//  ZOLPrivateImageFeedTableViewController.h
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/12/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOLDetailCell.h"
#import "ZOLDataStore.h"

@interface ZOLPrivateImageFeedTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *localImageArray;
@property (nonatomic, strong) NSMutableArray *localTextArray;
@property (nonatomic, strong) ZOLDataStore *dataStore;

@end
