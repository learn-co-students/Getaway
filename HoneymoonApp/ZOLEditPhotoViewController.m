//
//  ZOLEditPhotoViewController.m
//  HoneymoonApp
//
//  Created by Jennifer A Sipila on 4/4/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLEditPhotoViewController.h"
#import "ViewController.h"
#import "ZOLMainTableViewController.h"
#import "ZOLSimulatedFeedData.h"
#import "ZOLScrollViewController.h"
#import "ZOLProfileViewController.h"


@interface ZOLEditPhotoViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UIImageView *acceptedImageView;

@property(nonatomic, strong)NSMutableArray *photosArray;

@end

@implementation ZOLEditPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photosArray = [[NSMutableArray alloc] init];
    
    self.acceptedImageView.image = self.acceptedImage;
    
    NSAttributedString *locationPlaceholder = [[NSAttributedString alloc] initWithString:@"Add location..." attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    NSAttributedString *descriptionPlaceholder = [[NSAttributedString alloc] initWithString:@"Add photo description..." attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    self.descriptionTextField.attributedPlaceholder = descriptionPlaceholder;
    
    self.descriptionTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)descriptionEditingBegan:(UITextField *)sender
{
    [self.descriptionTextField setBackgroundColor:[UIColor darkGrayColor]];
}

- (IBAction)descriptionEditingEnded:(UITextField *)sender
{
    [self.descriptionTextField setBackgroundColor:[UIColor clearColor]];
    [self.descriptionTextField resignFirstResponder];
}

- (IBAction)backgroundTapped:(UITapGestureRecognizer *)sender
{
    [self.descriptionTextField resignFirstResponder];
}

- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)saveButtonTapped:(UIButton *)sender
{
    [self.photosArray addObject:self.acceptedImage];
    NSString *photoDescription = self.descriptionTextField.text;
    
    NSLog(@"Photo in Array: %@", self.photosArray[0]);
    NSLog(@"Photo description: %@",photoDescription);
    
    ZOLDataStore *sharedDatastore = [ZOLDataStore dataStore];
    NSURL *imageURL = [sharedDatastore.client writeImage:self.acceptedImage toTemporaryDirectoryWithQuality:0];
   
    ZOLImage *newImage = [[ZOLImage alloc]init];
    newImage.picture = self.acceptedImage;
    newImage.caption = photoDescription;
    
    [sharedDatastore.user.userHoneymoon.honeymoonImages insertObject:newImage atIndex:0];
    
    CKRecord *newImageRecord = [[CKRecord alloc] initWithRecordType:@"Image"];
    CKAsset *newImageAsset = [[CKAsset alloc] initWithFileURL:imageURL];
    CKReference *honeymoonReference = [[CKReference alloc]initWithRecordID:sharedDatastore.user.userHoneymoon.honeymoonID action:CKReferenceActionDeleteSelf];
    
    [newImageRecord setObject:newImageAsset forKey:@"Picture"];
    [newImageRecord setObject:photoDescription forKey:@"Caption"];
    [newImageRecord setObject:honeymoonReference forKey:@"Honeymoon"];
    
    [sharedDatastore.client saveRecord:newImageRecord toDataBase:sharedDatastore.client.database];
    
    [self performSegueWithIdentifier:@"unwindToPersonalFeed" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString: @"unwindToPersonalFeed"]) {
    
        ZOLProfileViewController *destinationVC = segue.destinationViewController;
        
        destinationVC.isComingFromCamera = YES;
    
    }
    
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
