//
//  ZOLMainTableViewController.h
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 05/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOLDataStore.h"

@interface ZOLMainTableViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *localImageArray;
@property (nonatomic,strong) NSMutableArray *localTextArray;

@end
