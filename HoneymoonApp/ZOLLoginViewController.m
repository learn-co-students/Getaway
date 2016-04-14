//
//  ZOLLoginViewController.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLLoginViewController.h"
#import "ZOLTabBarViewController.h"

@interface ZOLLoginViewController ()

@property (nonatomic, assign) __block BOOL shouldLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ZOLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Handle the Login With iCloud button being tapped
- (IBAction)loginTapped:(id)sender
{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
//    ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
    
    [self.activityIndicator startAnimating];
    
    //Verify that the user is logged in to their iCloud account
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        
        NSLog(@"back from block of code, accountSTatuswithCompletion");
        NSLog(@"%ld", (long)accountStatus);
        NSLog(@"Error: %@", error.localizedDescription);
        
        if (accountStatus == CKAccountStatusAvailable)
        {
            self.shouldLogin = YES;
        }
        else
        {
            self.shouldLogin = NO;
        }
        
        if (self.shouldLogin == NO)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                                                           message:@"Sign in to your iCloud account to use this app. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap 'Create a new Apple ID'."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:alert animated:YES completion:nil];
            }];
        }
        else
        {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.activityIndicator stopAnimating];
                NSLog(@"about to stop animating!!!");
                //TODO: Polish up this transition
                
                NSLog(@"datastore about to be made.");
                
                self.dataStore = [ZOLDataStore dataStore];
                
                
                NSLog(@"You wont be called for a long time.");
                [self.dataStore populateMainFeed];
                
                NSLog(@"Hello populate is done.");
                
            }];
            
        
            
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                NSLog(@"Initializing data store");
//                self.dataStore = [ZOLDataStore dataStore];
//                [self.dataStore populateMainFeed];
////                [self presentViewController:mainVC animated:YES completion:nil];
//            }];
        }
    }];
    
    NSLog(@"MainFeed populated add observer is happening.");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentNextVC:) name:@"MainFeedPopulated" object:nil];
}

-(void)presentNextVC: (NSNotification *)notification
{
    

//    NSLog(@"Attempting to present tabbar VC");
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
//    ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
////    ZOLTabBarViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainFeed"];
//
//    [self presentViewController:mainVC animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
