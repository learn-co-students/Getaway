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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = 35;
    tabFrame.origin.y = self.view.frame.size.height - 35;
    self.tabBar.frame = tabFrame;
    
    [[self.tabBarController.tabBar.items objectAtIndex:0 ] setTitle:NSLocalizedString(@"BotonMapas", @"comment")];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
