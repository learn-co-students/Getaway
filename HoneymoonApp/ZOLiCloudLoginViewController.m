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

@end

@implementation ZOLiCloudLoginViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //   self.hasAnAccount = [[NSUserDefaults standardUserDefaults] boolForKey:@"LoggedIn"];
    NSLog(@"viewDidLoad.");
    NSLog(@"self.newUserHasAnaccount = %@", self.newUserHasAnAccount ? @"YES" : @"NO");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedNotificationFromAppDelegate:) name:@"USER_RETURNED_MID_LOGIN" object:nil];

}

-(void)recievedNotificationFromAppDelegate:(NSNotification*)aNotification{
    [self checkAndHandleiCloudStatus];
}

-(void)viewWillAppear:(BOOL)animated{
    self.logInButton.hidden = YES;
    [self.activityIndicator startAnimating];
    [self checkAndHandleiCloudStatus];
};

-(void)checkAndHandleiCloudStatus{
    // 1. Get account status
    // 2. If account status is NO, alert user to sign in
    // 3. If account status is YES, set up database and proceed to next VC
    // 4. If account status is not determined, alert user of error tell them thier iCloud id is weird
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        NSLog(@"Entered account status code block!");
        if (error) {
            NSLog(@"Error loging a first-time user! Error type: %@", error.localizedDescription);
            return;
        }
        NSLog(@"Account status is %ld",(long)accountStatus);
        //should login == no means if there is no active iClould account
       
        
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
          //  [self.activityIndicator stopAnimating];
           // self.activityIndicator.hidden = YES;
            NSLog(@"About to initiate the NSOperation'go grab all my files and feeds' thingy");
            
            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                NSLog(@"Initializing datastore");
//                self.dataStore = [ZOLDataStore dataStore];
//                [self.dataStore populateMainFeed];
//                NSLog(@"About to present main feed VC");
//                
//                [self.activityIndicator startAnimating];
//                [self fetchingYourData];
//            }];
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentNextVC:) name:@"MainFeedPopulated" object:nil];
            
//            NSOperationQueue * queue = [[NSOperationQueue alloc] init];
//            
//            NSBlockOperation * blockOp = [NSBlockOperation blockOperationWithBlock:^{
//                
//                NSLog(@"Initializing datastore");
//                self.dataStore = [ZOLDataStore dataStore];
//                [self.dataStore populateMainFeed];
//                NSLog(@"About to present main feed VC");
//                
////                [self.activityIndicator startAnimating];
////                [self fetchingYourData];
//                
//            }];
//            
//            [blockOp setCompletionBlock:^{
//                
//                
//                [self presentNextVC];
//                
//            }];
//            
//            [queue addOperation:blockOp];
//            
            
            
            NSLog(@"Initializing datastore");
            self.dataStore = [ZOLDataStore dataStore];
            [self.dataStore populateMainFeedWithCompletion:^(NSError *error) {
                if(error) {
                    NSLog(@"error, and now i sit :|");
                    return;
                }
                else{
                
                [self presentNextVC];
                }
            }];

            

        };
    }];
}

-(void)presentNextVC {
    
    NSLog(@"present next VC was called");

UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
    
    [self presentViewController:mainVC animated:YES completion:^{
        [self.activityIndicator stopAnimating];
        [self fetchingYourData];
    }];

    
}


//Would we want to get rid of the login screen after we've loaded the mainFeed??
//-(void)dealloc {
//    
//    NSLog(@"VC is dead dead dead");
//}



- (void)loginNewUser {
    
    //  self.logInButton.hidden = NO;
    [self.activityIndicator startAnimating];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
    ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
    
    NSLog(@"Login Tapped");
    NSLog(@"%d", [self.activityIndicator isAnimating]);
    
    [self fetchingYourData];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"Initializing datastore");
        self.dataStore = [ZOLDataStore dataStore];
        [self.dataStore populateMainFeedWithCompletion:^(NSError *error) {
            if (error)
                NSLog(@"Error initing the datastore");
            else{
                NSLog(@"Attempting to present VC");
                [self presentViewController:mainVC animated:YES completion:nil];
            }
        }];
        
 
    }];
}


-(void) zolaAppWillWaitForYou{
    
    UIAlertController *waitForUserToLogIn = [UIAlertController alertControllerWithTitle:@"Go ahead and login to iCloud" message:@"We'll wait for you to get back!" preferredStyle:UIAlertControllerStyleAlert];
    
    [waitForUserToLogIn addAction:[UIAlertAction actionWithTitle:@"Exit Zola app"
                                                         style:(UIAlertActionStyleCancel)
                                                       handler:nil]];
    
    [self presentViewController:waitForUserToLogIn animated:YES completion:nil];
    
}

- (IBAction)loginTapped:(id)sender {
    [self loginNewUser];
}

-(void)tellAppDelegateTheUserDoesntHaveiCloudAccount{
    ((AppDelegate*)[UIApplication sharedApplication].delegate).userDidntHaveiCloudAccountAtLogIn = YES;
}

-(void) fetchingYourData{
    
    UIAlertController *userOkNotification = [UIAlertController alertControllerWithTitle:@"Logging you in!" message:@"We are fixing up your profile" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:userOkNotification animated:YES completion:nil];
    
    
     NSLog(@"Hey, we are logged in, store YES in userdefaults with KEY LoggedIn");
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoggedIn"];
}



@end
