//
//  ZOLDetailTableViewController.h
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 05/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOLDataStore.h"
#import <MXParallaxHeader/MXParallaxHeader.h>

@interface ZOLDetailTableViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *localImageArray;
@property (nonatomic,strong) NSMutableArray *localTextArray;
@property (nonatomic, strong) ZOLDataStore *dataStore;
@property (nonatomic, strong) CKRecordID *selectedHoneymoonID;
@property (nonatomic,strong) NSString * titleString;
@property (nonatomic,strong) UIImage * parralaxHeaderImage;
@property (nonatomic,strong) UIView * parralaxView;

@end
