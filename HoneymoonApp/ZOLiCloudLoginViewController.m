//
//  ZOLiCloudLoginViewController.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/14/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//


#import "ZOLLoginViewController.h"
#import "ZOLTabBarViewController.h"

@interface ZOLLoginViewController ()

@property (nonatomic, assign) BOOL hasAnAccount;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation ZOLLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hasAnAccount = [[NSUserDefaults standardUserDefaults] boolForKey:@"LoggedIn"];
    NSLog(@"viewDidLoad.");
    NSLog(@"self.HasAnaccount = %@", self.hasAnAccount ? @"YES" : @"NO");
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    self.logInButton.hidden = YES;
    [self.activityIndicator startAnimating];
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        
        NSLog(@"Entered account status code block!");
        
        if (error) {
            NSLog(@"Error loging a first-time user! Error type: %@", error.localizedDescription);
        }
        
        NSLog(@"Account status is %ld", (long)accountStatus);
        
        //should login == no means if there is no active iClould account
        if (accountStatus == CKAccountStatusNoAccount) {
            
            NSLog(@"No iCloud account active, give 'sign in to icloud' alert");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                                                           message:@"Sign in to your iCloud account to use this app. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap 'Create a new Apple ID'."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:alert animated:YES completion:nil];
                
            }];
            
            //createa label here that will say somthing like 'we'll wait here until you get back with your awesome iCloud account!' OR 'make an iClould account with apple, and we'll take it from there!'
            
            [self zolaAppWillWaitForYou];
        }
        
        
        if (accountStatus == CKAccountStatusRestricted) {
            self.logInButton.hidden = NO;
            [self loginNewUser];
            
        }
        
        if (error) {
            NSLog(@"There is an error verifying iCloud account as a first-time user...");
        }
        //Here add a label saying 'we'll wait for you to get back!' hahahaaa...
        
        
        //if there is an active iCloud account where we can retrieve iClould user to init a CKuser
        
        
        if (accountStatus == CKAccountStatusAvailable) {
            
            NSLog(@"Hey, we are logged in, store YES in userdefaults with KEY LoggedIn");
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoggedIn"];
            
            NSLog(@"The user who has logged into our app previously has been reverified upon launch");
            // [self.logInButton setTitle:@"yay!" forState:UIControlStateNormal];
            
            //get the button and change the text!
            
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
            ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
            
            
            NSLog(@"About to initiate the NSOperation'go grab all my files and feeds' thingy");
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.dataStore = [ZOLDataStore dataStore];
                NSLog(@" grabbing the datastore");
                [self presentViewController:mainVC animated:YES completion:nil];
                NSLog(@"Presenting the MainFeed VC");
            }];
            NSLog(@"NSOperation completed in the view will appear");
            
            
        }
    }];
    
};


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loginNewUser {
    
    self.logInButton.hidden = NO;
    [self.activityIndicator startAnimating];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
    ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
    
    NSLog(@"Login Tapped");
    NSLog(@"%d", [self.activityIndicator isAnimating]);
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"Initializing datastore");
        self.dataStore = [ZOLDataStore dataStore];
        NSLog(@"Attempting to present VC");
        [self presentViewController:mainVC animated:YES completion:nil];
        NSLog(@"VC Presented?");
    }];
    
}


-(void) zolaAppWillWaitForYou{
    
    UIAlertController *goLogInSweetUser = [UIAlertController alertControllerWithTitle:@"Go ahead and login to iCloud" message:@"We'll wait for you to get back!" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [goLogInSweetUser addAction:[UIAlertAction actionWithTitle:@"Exit Zola app"
                                                         style:(UIAlertActionStyleDefault)
                                                       handler:nil]];
    //can we make a button that will close the app??
}

- (IBAction)loginTapped:(id)sender
{
    
    [self loginNewUser];
    
}

@end
