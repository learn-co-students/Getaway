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
@property (strong, nonatomic) IBOutlet UILabel *myFeedButton;
@property(nonatomic) BOOL isComingFromProfilePage;


@end

@implementation ZOLProfileViewController

-(void)viewDidAppear:(BOOL)animated {

    if (self.isComingFromCamera) {
        [self performSegueWithIdentifier:@"profileToFeed" sender:nil];
        self.isComingFromCamera = NO;
    }
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
   // self.myFeedButton.frame = self.myFeedButton.bounds;
    self.myFeedButton.layer.borderColor = [UIColor colorWithRed:239 green:239 blue:244 alpha:1].CGColor;
    self.myFeedButton.layer.borderWidth = 1.0;
   // self.myFeedButton.backgroundColor = [UIColor clearColor];
    self.myFeedButton.layer.cornerRadius = 5;
    self.myFeedButton.layer.masksToBounds = YES;
    
    //Retrieve document from directory
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    UIImage * retrievedProfileImage = [self loadImageWithFileName:@"ProfilePic" ofType:@"jpg" inDirectory:documentsDirectory];
    
    //Make imageview round
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    self.imageView.layer.masksToBounds = YES;
    
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

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    

}


@end
