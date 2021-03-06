//
//  ZOLAcceptPhotoViewController.m
//  HoneymoonApp
//
//  Created by Jennifer A Sipila on 4/4/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLAcceptPhotoViewController.h"

@interface ZOLAcceptPhotoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *currentImageView;

@end


@implementation ZOLAcceptPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissVC) name:@"Dismiss AcceptVC" object:nil];
    
    self.currentImageView.image = self.currentImage;
}

- (void)dismissVC
{
    NSLog(@"dismiss VC");
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)acceptButtonTapped:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
    
    ZOLEditPhotoViewController *editViewController = [storyboard instantiateViewControllerWithIdentifier:@"editPhotoViewController"];
    
    editViewController.acceptedImage = self.currentImage;
//  editViewController.acceptedImageURL = self.currentImageURL;    
    
    [self presentViewController:editViewController animated:NO completion:^
    {
     //does anything else need to happen here?
    }];
}

@end
