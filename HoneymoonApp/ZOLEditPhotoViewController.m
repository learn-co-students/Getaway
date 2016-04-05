//
//  ZOLEditPhotoViewController.m
//  HoneymoonApp
//
//  Created by Jennifer A Sipila on 4/4/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLEditPhotoViewController.h"
#import "ViewController.h"

@interface ZOLEditPhotoViewController ()

@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UIImageView *acceptedImageView;

@property(nonatomic, strong)NSMutableArray *photosArray;

@end

@implementation ZOLEditPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photosArray = [[NSMutableArray alloc] init];
    
    self.acceptedImageView.image = self.acceptedImage;
}

- (IBAction)descriptionEditingBegan:(UITextField *)sender
{
    [self.descriptionTextField setBackgroundColor:[UIColor darkGrayColor]];
}
- (IBAction)locationEditingBegan:(UITextField *)sender
{
    [self.locationTextField setBackgroundColor:[UIColor darkGrayColor]];
}

- (IBAction)descriptionEditingEnded:(UITextField *)sender
{
    [self.descriptionTextField setBackgroundColor:[UIColor clearColor]];
    [self.descriptionTextField resignFirstResponder];
}

- (IBAction)locationEditingEnded:(UITextField *)sender
{
    [self.locationTextField setBackgroundColor:[UIColor clearColor]];
    [self.locationTextField resignFirstResponder];
}

- (IBAction)backgroundTapped:(UITapGestureRecognizer *)sender
{
    [self.descriptionTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
}

- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)saveButtonTapped:(UIButton *)sender
{
    [self.photosArray addObject:self.acceptedImage];
    NSString *photoDescription = self.descriptionTextField.text;
    NSString *photoLocation = self.locationTextField.text;
    
    NSLog(@"Photo in Array: %@", self.photosArray[0]);
    NSLog(@"Photo description: %@",photoDescription);
    NSLog(@"Photo location: %@", photoLocation);
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss AcceptVC" object:nil];
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
