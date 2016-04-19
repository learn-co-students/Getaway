//
//  ZOLHeadlineEditViewController.m
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 06/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLHeadlineEditViewController.h"

@interface ZOLHeadlineEditViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ZOLHeadlineEditViewController

- (IBAction)backgroundTapped:(id)sender {
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
        [self.textField resignFirstResponder];
    return YES;
}

- (IBAction)mainFeedButtonTapped:(UIBarButtonItem *)sender
{
    self.dataStore.user.userHoneymoon.honeymoonDescription = self.textField.text;
    
    ZOLHoneymoon *userHoneymoon = self.dataStore.user.userHoneymoon;
    
    CKRecord *honeymoonToSave = [self.dataStore.client fetchRecordWithRecordID:userHoneymoon.honeymoonID];
    
    NSURL *coverImageURL = [self.dataStore.client writeImage:userHoneymoon.coverPicture toTemporaryDirectoryWithQuality:0];
    CKAsset *coverImageAsset = [[CKAsset alloc]initWithFileURL:coverImageURL];
    
    honeymoonToSave[@"CoverPicture"] = coverImageAsset;
    honeymoonToSave[@"Description"] = userHoneymoon.honeymoonDescription;
    honeymoonToSave[@"Published"] = @"YES";
    honeymoonToSave[@"RatingStars"] = @(userHoneymoon.rating);
    honeymoonToSave[@"Name"] = userHoneymoon.userName;
    
    [self.dataStore.client.database saveRecord:honeymoonToSave completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Something went wrong with this one too!: %@", error.localizedDescription);
        }
    }];
//    [self.dataStore.client saveRecord:honeymoonToSave toDataBase:self.dataStore.client.database];
    [self.navigationController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    
    self.dataStore = [ZOLDataStore dataStore];
    // Do any additional setup after loading the view.
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
