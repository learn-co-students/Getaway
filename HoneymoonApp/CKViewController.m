//
//  CKViewController.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/2/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "CKViewController.h"


@interface CKViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *testImage;

@end

@implementation CKViewController



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewDidLoad {
    [super viewDidLoad];

   // self.datastore = [CloudKitDataBase sharedData];
  
    
    
    //[self setup];
        
//    
//   self.zolContainer = [CKContainer defaultContainer];    //cloudKit container
//   self.publicDatabase = [self.zolContainer publicCloudDatabase]; //public database for all pub data
//   self.privateDatabase = [self.zolContainer privateCloudDatabase];//private database for priv data
//  
//    
    //before the user can open the app, they need to be signed into CloudKit
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            UIAlertController *noAccountAlert = [UIAlertController alertControllerWithTitle:@"Sign into iCloud"
                                                                                    message:@"Sign in to your iCloud account to access your profile! On the Home screen, launch Settings, tap iCloud, and enter your Apple ID and Password. Then switch the 'iCloud Drive' to the 'on' position. If you don't have an iCloud account, tap Create a new Apple ID to get you set up."
                                                                             preferredStyle:UIAlertControllerStyleAlert];
            [noAccountAlert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil]];
            [self presentViewController:noAccountAlert animated:YES completion:nil];
        }
        
    }];
}





@end
