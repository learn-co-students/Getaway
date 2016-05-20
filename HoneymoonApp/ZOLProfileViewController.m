//
//  ZOLProfileViewController.m
//  HoneymoonApp
//
//  Created by Jennifer A Sipila on 4/18/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLProfileViewController.h"
#import "ZOLCameraViewController.h"

@interface ZOLProfileViewController ()

@property (strong, nonatomic)IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIButton *myFeedButton;

@property(nonatomic) BOOL isComingFromProfilePage;

@end

@implementation ZOLProfileViewController

-(void)viewDidAppear:(BOOL)animated
{
    
    self.dataStore = [ZOLDataStore dataStore];
    
    if(self.dataStore.user.userHoneymoon.honeymoonImages.count)
    {
        self.myFeedButton.hidden = NO;
    }
    else
    {
//        [self.dataStore.user getAllTheRecords];
    }
    
    if (self.isComingFromCamera)
    {
        [self performSegueWithIdentifier:@"profileToFeed" sender:nil];
        self.isComingFromCamera = NO;
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.myFeedButton.hidden = YES;
    
    self.myFeedButton.layer.borderColor = [UIColor colorWithRed:239 green:239 blue:244 alpha:1].CGColor;
    self.myFeedButton.layer.borderWidth = 1.0;
    self.myFeedButton.layer.cornerRadius = 5;
    self.myFeedButton.layer.masksToBounds = YES;
    
    //Retrieve document from directory
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    UIImage * retrievedProfileImage = [self loadImageWithFileName:@"ProfilePic" ofType:@"jpg" inDirectory:documentsDirectory];
    
    //Make imageview round
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    self.imageView.layer.masksToBounds = YES;
    
    if (retrievedProfileImage) {
        self.imageView.image = retrievedProfileImage;
    }
    NSString *username = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    self.username.text = username;
}

//Allows you to reload an image from the documents directory.
-(UIImage *)loadImageWithFileName:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, [extension lowercaseString]]];
    
    return result;
}

- (IBAction)addProfilePicButtonTapped:(UIButton *)sender
{
    NSString *messageToCamera = @"Profile Photo";
    
    NSDictionary* userInfo = @{@"key": messageToCamera};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Coming From Profile Page" object:self userInfo:userInfo];
}

- (IBAction)changeUsernameTapped:(id)sender
{
    UIAlertController *changeUsername = [UIAlertController alertControllerWithTitle:@"Change User Name" message:@"Select a new User Name" preferredStyle:UIAlertControllerStyleAlert];
    
    [changeUsername addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        textField.placeholder = @"New User Name";
    }];
    
    UIAlertAction *changeName = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [[NSUserDefaults standardUserDefaults] setObject:changeUsername.textFields.lastObject.text forKey:@"username"];
        self.dataStore.user.username = changeUsername.textFields.lastObject.text;
        self.username.text = changeUsername.textFields.lastObject.text;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [changeUsername addAction:changeName];
    [changeUsername addAction:cancel];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self presentViewController:changeUsername animated:YES completion:nil];
    }];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"profileToCamera"])
    {
        ZOLCameraViewController *cameraVC = segue.destinationViewController;
        cameraVC.isComingFromProfilePage = YES;
    }
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
{
    

}


@end
