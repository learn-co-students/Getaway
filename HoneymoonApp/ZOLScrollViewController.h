//
//  ScrollViewController.h
//  ScrollViewTester
//
//  Created by Jennifer A Sipila on 4/6/16.
//  Copyright © 2016 Jennifer A Sipila. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZOLDataStore;

@interface ZOLScrollViewController : UIViewController
@property (nonatomic, strong) ZOLDataStore *dataStore;

@end
