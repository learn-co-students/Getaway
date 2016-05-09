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

@property (nonatomic, strong) NSMutableArray *ratingArray;
@property (nonatomic, strong) ZOLDataStore *dataStore;
//@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;

@end
