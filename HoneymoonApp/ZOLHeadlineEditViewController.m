//
//  ZOLHeadlineEditViewController.m
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 06/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLHeadlineEditViewController.h"
#import "ZOLTabBarViewController.h"

@interface ZOLHeadlineEditViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ZOLHeadlineEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    
    self.dataStore = [ZOLDataStore dataStore];
    // Do any additional setup after loading the view.
}

- (IBAction)backgroundTapped:(id)sender {
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

- (IBAction)mainFeedButtonTapped:(UIBarButtonItem *)sender
{
    [self saveHoneymoon];
}

-(void)saveHoneymoon
{
    if (self.dataStore.user.userHoneymoon.honeymoonID)
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
        honeymoonToSave[@"Name"] = self.dataStore.user.username;
        userHoneymoon.userName = self.dataStore.user.username;
        
        [self.dataStore.client.database saveRecord:honeymoonToSave completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"Something went wrong saving a honeymoon: %@", error.localizedDescription);
            }
        }];
        
        BOOL honeymoonFound = NO;
        NSUInteger foundIndex = 0;
        
        for (ZOLHoneymoon *honeymoon in self.dataStore.mainFeed)
        {
            CKRecordID *thisHMID = honeymoon.honeymoonID;
            
            if ([thisHMID isEqual:userHoneymoon.honeymoonID])
            {
                honeymoonFound = YES;
                foundIndex = [self.dataStore.mainFeed indexOfObject:honeymoon];
                break;
            }
        }
        
        if (honeymoonFound)
        {
            [self.dataStore.mainFeed removeObjectAtIndex:foundIndex];
            [self.dataStore.mainFeed insertObject:userHoneymoon atIndex:0];
        }
        else
        {
            [self.dataStore.mainFeed insertObject:userHoneymoon atIndex:0];
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
        ZOLTabBarViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
        [self presentViewController:newVC animated:YES completion:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveHoneymoon) name:@"UserHoneymoonFound" object:nil];
    }
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
