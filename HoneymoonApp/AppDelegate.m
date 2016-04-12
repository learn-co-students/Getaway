
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

//----------------------------------------
//below are the two methods that allow the app to notice when a record has been motified. The commented numbers show the order each method is hit.These methods can olny pay attention to a single CKfile....


//(3) trigger the subscribe to record method
- (void)subscribeToWebServiceSettingsChanges {
    
    BOOL isSubscribed = [[NSUserDefaults standardUserDefaults] boolForKey:@"subscribedToUpdates"];
    NSLog(@"hit 'isSusbcribed BOOL'");
    if (isSubscribed == NO) {
        NSLog(@"BOOL == NO");
        // First, we update the record
        CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
        CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"542F88BA-E72F-400A-887A-C12EE75DA7C4"];
        
        NSLog(@"about to look in the public db");
        [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error){
            
            if (error) {
                NSLog(@"There was an error obtaining the recordID. Error type:%@", error.localizedDescription);
                
            } else {
                NSLog(@"hit the else statement-- meaning isSuscribed == YES");
                // Update the local copy of the setting
                //[self updateSettingsWithServiceURL:record[@"serviceURL"] andServiceAPIKey:record[@"serviceAPIKey"]];
                NSLog(@"We are subscribed to the 'APIKey' record in the 'image' recordtype!!");
                
                // Then, we check if there is an iCloud account available so we can have write permission
                [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
                    
                    if (error) {
                        NSLog(@"There was an error accessing write permissions for the user iCloud account. Error type: %@", error.localizedDescription);
                    }
                    
                    if (accountStatus == CKAccountStatusAvailable) {
                        NSLog(@"Recieved permssions to write to the user iCloud! About to subscribe to be notified of future updates!");
                        // Then, subscribe to future updates
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
                        CKSubscription *subscription = [[CKSubscription alloc] initWithRecordType:@"Image" predicate:predicate options:CKSubscriptionOptionsFiresOnRecordUpdate];
                        NSLog(@"We've succssfully subscribed for future updates! About to save the subscription...");
                        
                        [publicDatabase saveSubscription:subscription completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
                            
                            if (error) {
                                NSLog(@"There was an error SAVING a subscription. Error type: %@", error.localizedDescription);
                              
                            }else{
                                // Save that we have subscribed successfully
                                NSLog(@"we've saved the subscription for the BOOL 'subscribedToUpdates!!!");
                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"subscribedToUpdates"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                              

                            }
                            
                        }];
                    }
                }];
            }
        }];
    }
};
//(1)
- (void)updateWebServiceSettings {
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"542F88BA-E72F-400A-887A-C12EE75DA7C4"];  //RecZoneRecName
    [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            
            NSLog(@"Error retrieving recordID. Error type:%@", error.description);

            
        } else {
            // Update the local copy of the setting (grab the keys in the 'record Zone' in the 'exeptionalWebService' record type)
            // [self updateSettingsWithServiceURL:record[@"serviceURL"] andServiceAPIKey:record[@"serviceAPIKey"]];
            
           NSLog(@"the fetched record dictionary values are:{'caption: %@ \n 'Honeymoon:%@'}", record[@"Caption"], record[@"Honeymoon"]);
            
            [self subscribeToWebServiceSettingsChanges];
            
        }
    }];
}


//(2) display login VC with 'log onto iCloud' button prompt
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
//    // Push notification setup
//    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
//    [application registerUserNotificationSettings:notificationSettings];
//    [application registerForRemoteNotifications];
//    
//    // Subscribe to web service settings changes
//    [self subscribeToWebServiceSettingsChanges];
//    
//    return YES;
  
    
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
//            [self updateWebServiceSettings];
//
//        }
//    }
}


//Below are othr methods we can use to manipulate when methods are called
//----------------------------------------------------
//
//- (void)applicationWillResignActive:(UIApplication *)application {
//    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    // Saves changes in the application's managed object context before the application terminates.
//}
@end
