//
//  ZOLTabBarViewController.m
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 08/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLTabBarViewController.h"

@interface ZOLTabBarViewController ()

@end

@implementation ZOLTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 30;
    tabFrame.origin.y = self.view.frame.size.height - 30;
    self.tabBar.frame = tabFrame;
    self.tabBar.translucent = YES;
    self.tabBar.backgroundColor = [UIColor clearColor];
    self.tabBar.barTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    //self.tabBar set
}

@end
