//
//  AppDelegate.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/29/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//Notification Tiiime!
//CKDatabase *public = [[CKContainer defaultContainer] publicCloudDatabase];

#pragma Do we want a notification for new feeds via location?
//Below are meths to CREATE notifications...

/*NSPredicate *predicate = [NSPredicate predicateWithFormat:@"description CONTAINS 'NewFeedFrom%@'", name.location.text];

 
CKSubscription *subscription = [[CKSubscription alloc] initWithRecordType:@"NewPublicFeed"
    predicate:predicate
    options:CKSubscriptionOptionsFiresOnRecordCreation];

 
CKNotificationInfo *newPublicFeedInfo = [CKNotificationInfo new];
info.alertLocalizationKey = @"NewFeedForLocation_X";
info.soundName = @"NewAlert.aiff";
info.shouldBadge = YES;

subscription.notificationInfo = info;

[publicDatabase saveSubscription:subscription
         completionHandler:^(CKSubscription *subscription, NSError *error) {
             NSLog(@"Could not save subscription Notification in AppDelegate");
         }];
 
//WE STILL NEED TO SET UP HOW TO PERCEIVE THE NOTIFICATION- aka the 'LISTENER'
     
     */






- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Core Data stack

@end
