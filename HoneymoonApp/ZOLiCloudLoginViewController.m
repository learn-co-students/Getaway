//
//  ZOLiCloudLoginViewController.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/14/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//


#import "ZOLiCloudLoginViewController.h"
#import "ZOLTabBarViewController.h"
#import "AppDelegate.h"

@interface ZOLiCloudLoginViewController ()

@property (nonatomic, assign) BOOL newUserHasAnAccount;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (nonatomic, strong) CKRecordID *idForUserClassFile;

@end

@implementation ZOLiCloudLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad.");
    
    //-(BOOL)internetIsReachable{
    //
    //        Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    //        NetworkStatus internetStatus = [r currentReachabilityStatus];
    //
    //        NSLog(@"internet status------%u",ReachableViaWiFi);
    //        if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    //        {
    //            NSLog(@"There is no internet avaiable");
    //            //do something for internet connection...
    //            return NO;
    //
    //        }
    //
    //        else{
    //            NSLog(@"We have internet connection!!");
    //        }
    //        return YES;
    //}
    
    NSLog(@"self.newUserHasAnaccount = %@", self.newUserHasAnAccount ? @"YES" : @"NO");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedNotificationFromAppDelegate:) name:@"USER_RETURNED_MID_LOGIN" object:nil];
}

-(void)recievedNotificationFromAppDelegate:(NSNotification *)aNotification{
    [self checkAndHandleiCloudStatus];
}

-(void)viewWillAppear:(BOOL)animated{
    self.logInButton.hidden = YES;
    [self.activityIndicator startAnimating];
    [self checkAndHandleiCloudStatus];
};

-(void)checkAndHandleiCloudStatus {
    // 1. Get account status
    // 2. If account status is NO, alert user to sign in
    // 3. If account status is YES, set up database and proceed to next VC
    // 4. If account status is not determined, alert user of error tell them thier iCloud id is weird
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        NSLog(@"Entered account status code block!");
        
        if (error) {
            NSLog(@"Error logging a first-time user! Error type: %@", error.localizedDescription);
            return;
        }
        NSLog(@"Account status is %ld",(long)accountStatus);
        //'account status = 1' means the user has an active iClould account
        
        if (accountStatus == CKAccountStatusNoAccount) {
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            NSLog(@"No iCloud account active, give 'sign in to icloud' alert");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"iCloud Log In Required"
                                                                           message:@"Go to Settings, tap iCloud, and enter your Apple ID. Switch iCloud Drive on. \n\nIf you don't have an iCloud account, tap 'Create a new Apple ID'."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self zolaAppWillWaitForYou];
            }]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:alert animated:YES completion:nil];
                [self tellAppDelegateTheUserDoesntHaveiCloudAccount];
            }];
        }
        else if (accountStatus == CKAccountStatusCouldNotDetermine) {
            UIAlertController *accountNotDetermined = [UIAlertController alertControllerWithTitle:@"Your iCloud account could not be determined" message:@"Please resolve iCloud account issue" preferredStyle:UIAlertControllerStyleAlert];
            [accountNotDetermined addAction:[UIAlertAction actionWithTitle:@"Okay"style:UIAlertActionStyleCancel handler:nil]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self zolaAppWillWaitForYou];
                [self tellAppDelegateTheUserDoesntHaveiCloudAccount];
            }];
        }
        else if (accountStatus == CKAccountStatusAvailable) {
            
            NSLog(@"The user who has logged into our app previously has been reverified upon launch");
            
            CKContainer *defaultContainer = [CKContainer defaultContainer];
            
            [defaultContainer fetchUserRecordIDWithCompletionHandler:^void(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error fetching User Record ID: %@", error.localizedDescription);
                    UIAlertController *userAlert = [UIAlertController alertControllerWithTitle:@"No User Record Found"
                                                                                       message:@"An error occured while attempting to get your user record, please try again"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self checkAndHandleiCloudStatus];
                    }];
                    
                    [userAlert addAction:retryAction];
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self presentViewController:userAlert animated:YES completion:nil];
                    }];

                }
                else {
                    self.idForUser = recordID;
                    NSLog(@"Initializing datastore");
                    self.dataStore = [ZOLDataStore dataStore];
                    
                    self.dataStore.user.userID = recordID;
                    
                    [[CKContainer defaultContainer] requestApplicationPermission:CKApplicationPermissionUserDiscoverability completionHandler:^(CKApplicationPermissionStatus applicationPermissionStatus, NSError * _Nullable error) {
                        if (applicationPermissionStatus == CKApplicationPermissionStatusGranted)
                        {
                            [[CKContainer defaultContainer] discoverUserInfoWithUserRecordID:self.dataStore.user.userID completionHandler:^(CKDiscoveredUserInfo * _Nullable userInfo, NSError * _Nullable error) {
                                self.dataStore.user.firstName = userInfo.displayContact.givenName;
                                self.dataStore.user.lastName = userInfo.displayContact.familyName;
                                self.dataStore.user.userHoneymoon.userName = [NSString stringWithFormat:@"%@ %@", self.dataStore.user.firstName, self.dataStore.user.lastName];
                            }];
                        }
                    }];
                    
                    [self.dataStore.user getAllTheRecords];
                    
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentErrorAlert:) name:@"HoneymoonError" object:nil];
                    
                    [self.dataStore populateMainFeedWithCompletion:^(NSError *error) {
                    
                        if(error) {
                            NSLog(@"error in populateMainFeedWithCompletion: %@", error.localizedDescription);
                            [self checkAndHandleiCloudStatus];
                        }
                        else {
                            [self presentNextVC];
                            
                        }
                    }];
                };
            }];
        }
        else if (accountStatus == CKAccountStatusRestricted)
        {
            UIAlertController *userAlert = [UIAlertController alertControllerWithTitle:@"Application Blocked!"
                                                                               message:@"This application is blocked in Parental Settings"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self checkAndHandleiCloudStatus];
            }];
            
            [userAlert addAction:retryAction];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:userAlert animated:YES completion:nil];
            }];
        }
    }];
};

-(void)presentErrorAlert: (NSNotification *)notification {
    UIAlertController *userAlert = [UIAlertController alertControllerWithTitle:@"ERROR!"
                                                                       message:@"An error occured, please try again"
                                                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.dataStore.user getAllTheRecords];
    }];
    
    [userAlert addAction:retryAction];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:userAlert animated:YES completion:nil];
    }];
    
}

-(void)presentNextVC {
    
    NSLog(@"present next VC was called");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
    ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
    
    [self presentViewController:mainVC animated:YES completion:^{
        [self.activityIndicator stopAnimating];
        [self setUserAsLoggedIn];
    }];
}


//Would we want to get rid of the login screen after we've loaded the mainFeed??
//-(void)dealloc {
//
//    NSLog(@"VC is dead dead dead");
//}


//
//- (void)loginNewUser {
//
////  self.logInButton.hidden = NO;
//[self.activityIndicator startAnimating];
//
//
//UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
//ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
//
//NSLog(@"Login Tapped");
//NSLog(@"%d", [self.activityIndicator isAnimating]);
//
//[self fetchingYourData];
//
//[[NSOperationQueue mainQueue] addOperationWithBlock:^{
//    NSLog(@"Initializing datastore");
//    self.dataStore = [ZOLDataStore dataStore];
//    [self.dataStore populateMainFeedWithCompletion:^(NSError *error) {
//        if (error)
//            NSLog(@"Error initing the datastore");
//        else{
//            NSLog(@"Attempting to present VC");
//            [self presentViewController:mainVC animated:YES completion:nil];
//        }
//    }];
//
//
//}];
//}


-(void)zolaAppWillWaitForYou {
    
    UIAlertController *waitForUserToLogIn = [UIAlertController alertControllerWithTitle:@"Go ahead and login to iCloud" message:@"We'll wait for you to get back!" preferredStyle:UIAlertControllerStyleAlert];
    
    [waitForUserToLogIn addAction:[UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil]];
    
    [self presentViewController:waitForUserToLogIn animated:YES completion:nil];
}

//- (IBAction)loginTapped:(id)sender {
//[self loginNewUser];
//}

-(void)tellAppDelegateTheUserDoesntHaveiCloudAccount {
    ((AppDelegate *)[UIApplication sharedApplication].delegate).userDidntHaveiCloudAccountAtLogIn = YES;
}

-(void)setUserAsLoggedIn {
    NSLog(@"Hey, we are logged in, store YES in userdefaults with KEY LoggedIn");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoggedIn"];
}




@end
