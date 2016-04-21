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
#import <SystemConfiguration/SCNetworkReachability.h>

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
    self.networkErrorCompolation =@[@"CKErrorNetworkUnavailable", @"CKErrorNetworkFailure", @"CKErrorServiceUnavailable", @"NSURLErrorDomain", @"NSURLErrorDomain", @"NSURLErrorNotConnectedToInternet", @"Network", @"Internet", @"offline"];

    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        NSLog(@"Entered account status code block!");
        
        if (error) {
            NSLog(@"Error logging a first-time user! Error type: %@", error.localizedDescription);
            [self checkAndHandleiCloudStatus];
        }
        
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
                
                //if we have an error specific to a network connection problem...
                if ([[self networkErrorCompolation] containsObject: NSURLErrorDomain]) {
                    NSLog(@"There was an error with internet connection!");
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{

                    UIAlertController *netConnectionError = [UIAlertController alertControllerWithTitle:@"Internet Woes" message:@"Experiencing unstable internet connection" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *netConnectionAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self isNetworkReachable];
                        [netConnectionError addAction:netConnectionAction];
                        [self presentViewController: netConnectionError animated:YES completion:nil];
                        NSLog(@"hit Network reachable checker");
                  
                        
                        
                        if ([self isNetworkReachable]){
                            NSLog(@"isNetWorkReachable = YES");
                        
                            
                            [self checkAndHandleiCloudStatus];
                        }
                        
                        else{
                            
                            UIAlertController *stillNoNetwork = [UIAlertController alertControllerWithTitle:@"Reoccuring Network Issue" message:@"Unable to reach a network connection at this time. Reopen the app when you are within a network." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *stillNoNetworkAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [stillNoNetwork addAction:stillNoNetworkAction];
                            [self presentViewController:stillNoNetwork animated:YES completion:nil];
                            [self.activityIndicator stopAnimating];
                            //Can we include a logo pic here? Apple suggests we go not programatically close the app.
                        }
                    }];
                        
                    
       
                    
                      }];
                }
                // if any other error...
                if (error) {
                    NSLog(@"Error fetching User Record ID: %@, code: %lu, domain: %@", error.localizedDescription, error.code, error.domain);
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
                    
                    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentErrorAlert:) name:@"HoneymoonError" object:nil];
                    
                    [self.dataStore.user getAllTheRecords];
                    
                    [self.dataStore populateMainFeedWithCompletion:^(NSError *error) {
                    
                        if(error) {
                            NSLog(@"error in populateMainFeedWithCompletion: %@", error.localizedDescription);
                            UIAlertController *feedAlert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                                               message:@"An error occured, check your internet connection and try again. If this problem persists, please contact the Getaway team"
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
                            
                            [feedAlert addAction:retryAction];
                            
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self presentViewController:feedAlert animated:YES completion:nil];
                            }];
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
                //if we call this method here, wouldn't we enter an infinite loop?
            }];
            
            [userAlert addAction:retryAction];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:userAlert animated:YES completion:nil];
            }];
        }
        
    
    }];

}

- (BOOL)isNetworkReachable{
    
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    return canReach;
}



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
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:mainVC animated:YES completion:^{
            [self.activityIndicator stopAnimating];
            [self setUserAsLoggedIn];
        }];
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
