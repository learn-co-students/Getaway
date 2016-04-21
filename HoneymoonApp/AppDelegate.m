
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

//----------------------------------------
//below are the two methods that allow the app to notice when a record has been motified. The commented numbers show the order each method is hit.These methods can olny pay attention to a single CKfile....


//(3) trigger the subscribe to record method
//- (void)subscribeImageAssetChanges {
//    
//    BOOL isSubscribed = [[NSUserDefaults standardUserDefaults] boolForKey:@"subscribedToUpdates"];
//    NSLog(@"hit 'isSusbcribed BOOL'");
//    if (isSubscribed == NO) {
//        NSLog(@"BOOL == NO");
//        // First, we update the record
//        CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
//        CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"542F88BA-E72F-400A-887A-C12EE75DA7C4"];
//        
//        NSLog(@"about to look in the public db");
//        [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error){
//            
//            if (error) {
//                NSLog(@"There was an error obtaining the recordID. Error type:%@", error.localizedDescription);
//                
//            } else {
//                NSLog(@"hit the else statement-- meaning isSuscribed == YES");
//                // Update the local copy of the setting
//
//                NSLog(@"We are subscribed to the associated recordname in the 'image' recordtype!!");
//                
//                // Then, we check if there is an iCloud account available so we can have write permission
//                [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
//                    
//                    if (error) {
//                        NSLog(@"There was an error accessing write permissions for the user iCloud account. Error type: %@", error.localizedDescription);
//                    }
//                    
//                    if (accountStatus == CKAccountStatusAvailable) {
//                        NSLog(@"Recieved permssions to write to the user iCloud! About to subscribe to be notified of future updates!");
//                        // Then, subscribe to future updates
//                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
//                        CKSubscription *subscription = [[CKSubscription alloc] initWithRecordType:@"Image" predicate:predicate options:CKSubscriptionOptionsFiresOnRecordUpdate];
//                        NSLog(@"We've succssfully subscribed for future updates! About to save the subscription...");
//                        
//                        [publicDatabase saveSubscription:subscription completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
//                            
//                            if (error) {
//                                NSLog(@"There was an error SAVING a subscription. Error type: %@", error.localizedDescription);
//                              
//                            }else{
//                                // Save that we have subscribed successfully
//                                NSLog(@"we've saved the subscription for the BOOL 'subscribedToUpdates!!!");
//                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"subscribedToUpdates"];
//                                [[NSUserDefaults standardUserDefaults] synchronize];
//                              
//
//                            }
//                            
//                        }];
//                    }
//                }];
//            }
//        }];
//    }
//};
//(1)
- (void)updateImageChange {
//    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
//    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"542F88BA-E72F-400A-887A-C12EE75DA7C4"];  //RecZoneRecName
//    [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
//        if (error) {
//            
//            NSLog(@"Error retrieving recordID. Error type:%@", error.description);
//
//            
//        } else {
//            // Update the local copy of the setting (grab the keys in the 'record Zone' in the 'Images' record type)
//            // [self updateSettingsWithServiceURL:record[@"serviceURL"] andServiceAPIKey:record[@"serviceAPIKey"]];
//            
//           NSLog(@"the fetched record dictionary values are:{'caption: %@ \n 'Honeymoon:%@'}", record[@"Caption"], record[@"Honeymoon"]);
//            
//            [self subscribeImageAssetChanges];
//            
//        }
//    }];
}

//this notifications works is tied with CKSubscriptions(letting us know when changes were applied to the picture 'meepbeep'--- this is code for a subscription test.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }
                                             forState:UIControlStateSelected];
    
     [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont fontWithName:@"HelveticaNeue" size:12], NSFontAttributeName, nil]
                                  forState:UIControlStateNormal];
    
//    // Push notification setup
//    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
//    [application registerUserNotificationSettings:notificationSettings];
//    [application registerForRemoteNotifications];
//    
//    // Subscribe to alterations to the asset here:
//    [self subscribeImageAssetChanges];
//    
//    return YES;
//  
    
    return YES;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
//    CKNotification *cloudKitNotification = [CKNotification notificationFromRemoteNotificationDictionary:userInfo];
//    
//    if (cloudKitNotification.notificationType == CKNotificationTypeQuery) {
//        CKRecordID *recordId = [(CKQueryNotification *)cloudKitNotification recordID];
//        
//        // if the notification corresponds to a change in the CKRecord, then we fetch the new values
//        if ([recordId.recordName isEqualToString:@"542F88BA-E72F-400A-887A-C12EE75DA7C4"]) {
//            [self updateImageChange];
//
//        }
//    }
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (self.userDidntHaveiCloudAccountAtLogIn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"USER_RETURNED_MID_LOGIN" object:nil];
        NSLog(@"in app delegate, i was told the user left during log in, but they're back!");
        self.userDidntHaveiCloudAccountAtLogIn = NO;
    }
    
}
@end
