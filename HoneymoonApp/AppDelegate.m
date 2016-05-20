
//
//  AppDelegate.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/29/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "AppDelegate.h"
#import "ZOLiCloudLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
                                             forState:UIControlStateSelected];
    
     [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"HelveticaNeue" size:12], NSFontAttributeName, nil]
                                  forState:UIControlStateNormal];
    
    return YES;
}

// Called as part of the transition from the background to the active state;
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (self.userDidntHaveiCloudAccountAtLogIn)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_RETURNED_MID_LOGIN" object:nil];
        NSLog(@"in app delegate, i was told the user left during log in, but they're back!");
        self.userDidntHaveiCloudAccountAtLogIn = NO;
    }
    
}
@end
