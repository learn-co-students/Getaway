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
@property(nonatomic) BOOL isComingFromProfilePage;

@end

@implementation ZOLProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Retrieve document from directory
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    UIImage * retrievedProfileImage = [self loadImageWithFileName:@"ProfilePic" ofType:@"jpg" inDirectory:documentsDirectory];
    
    self.imageView.image = retrievedProfileImage;
}

//Allows you to reload an image from the documents directory.
-(UIImage *)loadImageWithFileName:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, [extension lowercaseString]]];
    
    return result;
}

- (IBAction)addProfilePicButtonTapped:(UIButton *)sender
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Coming From Profile Page" object:nil];
 
    NSString *messageToCamera = @"Profile Photo";
    
    NSDictionary* userInfo = @{@"key": messageToCamera};
    
 [[NSNotificationCenter defaultCenter]postNotificationName:@"Coming From Profile Page" object:self userInfo:userInfo];
    
    
    
}

//#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"profileToCamera"]) {
        ZOLCameraViewController *cameraVC = segue.destinationViewController;
        cameraVC.isComingFromProfilePage = YES;
    }
}

@end
