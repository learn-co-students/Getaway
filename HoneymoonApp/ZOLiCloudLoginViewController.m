//
//  ZOLiCloudLoginViewController.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/14/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLiCloudLoginViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
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

    NSLog(@"self.newUserHasAnaccount = %@", self.newUserHasAnAccount ? @"YES" : @"NO");

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedNotificationFromAppDelegate:) name:@"USER_RETURNED_MID_LOGIN" object:nil];
}

- (void)recievedNotificationFromAppDelegate:(NSNotification *)aNotification
{
    [self networkHandler];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.logInButton.hidden = YES;
    [self.activityIndicator startAnimating];
    [self networkHandler];
};


- (void)checkAndHandleiCloudStatus
{
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error)
    {
        NSLog(@"Entered account status code block!");

        if (accountStatus == CKAccountStatusNoAccount)
        {
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            NSLog(@"No iCloud account active, give 'sign in to icloud' alert");
            
               [[NSOperationQueue mainQueue] addOperationWithBlock:^
            {
                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"iCloud Log In Required"
                                                                                  message:@"Go to Settings, tap iCloud, and enter your Apple ID. Switch iCloud Drive on. \n\nIf you don't have an iCloud account, tap 'Create a new Apple ID'."
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                   [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                     {
                                         [self zolaAppWillWaitForYou];
                                     }]];
                   

                [self presentViewController:alert animated:YES completion:nil];
                [self tellAppDelegateTheUserDoesntHaveiCloudAccount];
            }];
        }
        
        else if (accountStatus == CKAccountStatusCouldNotDetermine)
        {
            UIAlertController *accountNotDetermined = [UIAlertController alertControllerWithTitle:@"Your iCloud account could not be determined."
                                                                                          message:@"Please resolve iCloud account issue."
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
            [accountNotDetermined addAction:[UIAlertAction
                                             actionWithTitle:@"Okay"
                                             style:UIAlertActionStyleCancel
                                             handler:nil]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
            {
                [self zolaAppWillWaitForYou];
                [self tellAppDelegateTheUserDoesntHaveiCloudAccount];
            }];
        }
        
        else if (accountStatus == CKAccountStatusAvailable)
        {
            NSLog(@"The user who has logged into our app previously has been reverified upon launch");
            
            CKContainer *defaultContainer = [CKContainer defaultContainer];
            
            [defaultContainer fetchUserRecordIDWithCompletionHandler:^void(CKRecordID * _Nullable recordID, NSError * _Nullable error)
            {
                if (error)
                {
                    NSLog(@"Error fetching User Record ID: %@, code: %lu, domain: %@", error.localizedDescription, error.code, error.domain);
                    [self networkHandler];
                }
                
                else if (error == nil)
                {
                    self.idForUser = recordID;
                    self.dataStore = [ZOLDataStore dataStore];
                    
                    self.dataStore.user.userID = recordID;
                    
                    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
                    
                    if (!username)
                    {
                        NSMutableString *uniqueNum = [[NSMutableString alloc]init];
                        for (NSUInteger i = 0; i < 10; i++)
                        {
                            NSUInteger randomNum = arc4random_uniform(10);
                            [uniqueNum appendString:[NSString stringWithFormat:@"%lu", randomNum]];
                        }
                        NSString *defaultUsername = [NSString stringWithFormat:@"User%@", uniqueNum];
                        self.dataStore.user.username = defaultUsername;
                        self.dataStore.user.userHoneymoon.userName = defaultUsername;
                        [[NSUserDefaults standardUserDefaults] setObject:defaultUsername forKey:@"username"];
                    }

                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentRecordFetchErrorAlert:) name:@"HoneymoonError" object:nil];
                    
                    NSLog(@"'presentRecordFetchErrorAlert'. objects involved in FIRST of two calls: dataStore: %@\n USER:%@\n userName:%@", self.dataStore, self.dataStore.user, self.dataStore.user.username);
                    NSLog(@"presentRecordFetchErrorAlert'. objects involved in SECOND call--> userHoneymoon:%@ \n userName.honeymoon:%@", self.dataStore.user.userHoneymoon, self.dataStore.user.userHoneymoon.userName);
                    
                    [self.dataStore.user getAllTheRecords];
                    [self populateMainFeed];
                };     
            }];
        }
        else if (accountStatus == CKAccountStatusRestricted)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
            {
                UIAlertController *userRestrictionAlert = [UIAlertController alertControllerWithTitle:@"Application Blocked!"
                                                                                              message:@"This application is blocked in Parental Settings."
                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                {
                    [self checkAndHandleiCloudStatus];
                }];
                
                [userRestrictionAlert addAction:retryAction];
                [self presentViewController:userRestrictionAlert animated:YES completion:nil];
            }];
        }
    }];
}

-(void)populateMainFeed
{
    [self.dataStore populateMainFeedWithCompletion:^(NSError *error){
        if (error)
        {
           if (error.code == 3)
           {
               [self networkHandler];
           }
            NSLog(@"error in populateMainFeedWithCompletion: %@", error.localizedDescription);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                UIAlertController *feedAlert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                                   message:@"An error occured while loading user data. Retry to refresh."
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self populateMainFeed];
                }];
                
                [feedAlert addAction:retryAction];
                [self presentViewController:feedAlert animated:YES completion:nil];
            }];
        }
        else
        {
            [self presentNextVC];
        }
    }];
}

- (void)presentRecordFetchErrorAlert: (NSNotification *)notification
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
    {
        UIAlertController *recordErrorAlert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                  message:@"An error occurred grabbing your feed.\nRetry to refresh."
                                                                           preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *recordErrorAction = [UIAlertAction actionWithTitle:@"Retry"  style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action)
        {
            //[self checkAndHandleiCloudStatus];
            [self.dataStore.user getAllTheRecords];
        }];
        [recordErrorAlert addAction:recordErrorAction];
        [self presentViewController:recordErrorAlert animated:YES completion:nil];
    }];
}

- (void)presentNextVC
{
    NSLog(@"present next VC was called");

    [[NSOperationQueue mainQueue] addOperationWithBlock:^
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
        ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
        [self presentViewController:mainVC animated:YES completion:^
        {
            [self.activityIndicator stopAnimating];
            [self setUserAsLoggedIn];
        }];
    }];
}

- (void)zolaAppWillWaitForYou
{
    UIAlertController *waitForUserToLogIn = [UIAlertController alertControllerWithTitle:@"Go ahead and login to iCloud" message:@"We'll wait for you to get back!" preferredStyle:UIAlertControllerStyleAlert];

    [waitForUserToLogIn addAction:[UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil]];

    [self presentViewController:waitForUserToLogIn animated:YES completion:nil];
}

- (void)tellAppDelegateTheUserDoesntHaveiCloudAccount
{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).userDidntHaveiCloudAccountAtLogIn = YES;
}

- (void)setUserAsLoggedIn
{
    NSLog(@"Hey, we are logged in, store YES in userdefaults with KEY LoggedIn");
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoggedIn"];
}

- (BOOL)isNetworkReachable
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com");
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);

    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);

    return canReach;
}

- (void)networkHandler
{
    if ([self isNetworkReachable])
    {
        [self checkAndHandleiCloudStatus];
    }
    else
    {
        NSLog(@"No network connection!");
        UIAlertController *networkIssueAlert = [UIAlertController alertControllerWithTitle:@"Experiencing Network Issue"
                                                                           message:@"Network connection is necessary to use this app. Retry when you are in range."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *networRetryAction = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            [self checkAndHandleiCloudStatus];
        }];

        [networkIssueAlert addAction:networRetryAction];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^
        {
            [self presentViewController:networkIssueAlert animated:YES completion:nil];
        }];
    }
}

@end
