//
//  CKViewController.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/2/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "CKViewController.h"
#import "CloudKitDataBase.h"

@interface CKViewController ()
@property (strong, nonatomic) CKContainer *zolContainer;
@property (strong, nonatomic) CKDatabase *privateDatabase;
@property (strong, nonatomic) CKDatabase *publicDatabase;
@property (strong, nonatomic) CKRecord *userRecord;
@property (strong, nonatomic) CKRecord *ImageRecord;
@property (strong, nonatomic) CKRecord *HoneyMoonRecord;

@end

@implementation CKViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
   self.zolContainer = [CKContainer defaultContainer];    //cloudKit container
   self.publicDatabase = [self.zolContainer publicCloudDatabase]; //public database for all pub data
   self.privateDatabase = [self.zolContainer privateCloudDatabase];//private database for priv data
    

//public feed setup
    CKRecordID *publicFeedID = [[CKRecordID alloc]initWithRecordName:@"publicFeedID"];
    CKRecord *publicFeed = [[CKRecord alloc]initWithRecordType:@"publicFeed" recordID:publicFeedID];
    
    
    
//creating Private feed setup
    CKRecordID *privateID = [[CKRecordID alloc] initWithRecordName:@"privateFeed"];
    CKRecord *privateFeed = [[CKRecord alloc] initWithRecordType:@"privateFeed" recordID:privateID];
    
    [CloudKitDataBase savePrivateRecord: self.privateDatabase record:privateFeed];
    
    
    
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
    
//fetching a Public record
    [self. publicDatabase fetchRecordWithID:publicFeedID
                          completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
       
                              NSLog(@"There was an error fetching the publicFeed. Error type: %@", error);
        
        
        /*
         if we want to write:
         [publicDatabase fetchRecordWithID:publicFeedID completionHandler:^(CKRecord *publicFeed, NSError *error) {
         if (publicFeed != nil) {
         NSString *name = publicFeed[@"name"];
         publicFeed[@"name"] = [name stringByAppendingString:@"aNewFeedItem"];
         
         [publicDatabase saveRecord:publicFeed completionHandler:^(CKRecord *savedPlace, NSError *savedError) {
         NSLog(@"Could not edit public database");
         }];
         */
    }];

    
//saving a PUBLIC record
    [self.publicDatabase saveRecord:publicFeed
             completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                
                 NSLog(@"The public record data could not be saved. Error type : %@", error);
                 
                 if (CKErrorNetworkUnavailable) {
                     NSLog(@"The public data could not be saved due to a bad network connection");
                     double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
                     NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
                     
                 }
                 
                 if (CKErrorNetworkFailure) {
                     NSLog(@"The public data could not be saved because of a Network Failure");
                     double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
                     NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
                     
                 }
                 
                 
             }];
    
//saving a Private record
    [self.privateDatabase saveRecord:privateFeed
                   completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        NSLog(@"The private record data could not be saved. Error type : %@", error);
        
        if (CKErrorNetworkUnavailable) {
            NSLog(@"The private data could not be saved due to a bad network connection");
            double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
            NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
            
        }
        
        if (CKErrorNetworkFailure) {
            NSLog(@"The private data could not be saved because of a Network Failure");
            double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
            NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
            
        }
    }];

    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
