//
//  ZOLCameraViewController.m
//  HoneymoonApp
//
//  Created by Jennifer A Sipila on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLCameraViewController.h"
#import "ZOLAcceptPhotoViewController.h"
#import "ZOLProfileViewController.h"
#import "ZOLTabBarViewController.h"



@interface ZOLCameraViewController ()

@property (strong,nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIView *cameraOverlayView;
@property (nonatomic)BOOL isCameraModeOn;
@property(nonatomic)UIImagePickerControllerCameraDevice cameraDevice;
@property(nonatomic)UIImagePickerControllerCameraFlashMode flashMode;
@property (strong, nonatomic) IBOutlet UIButton *flashButtonIcon;
@property (strong, nonatomic) IBOutlet UIButton *switchCameraDirectionButtonTapped;




@end

@implementation ZOLCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.flashButtonIcon setImage:[UIImage imageNamed:@"FlashInactive"] forState:UIControlStateNormal];
    self.flashMode = -1;
    self.openCam = YES;
    

}

+(void)openCamFunction {
    
   ZOLCameraViewController *ZOLVC = [ZOLCameraViewController new];
    ZOLVC.openCam = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.openCam) {
        animated = NO;
        UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.delegate = self;
        cameraController.cameraDevice = self.cameraDevice;
        cameraController.showsCameraControls = NO;
        cameraController.toolbarHidden = YES;
        cameraController.cameraViewTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.38, 1.38), CGAffineTransformMakeTranslation(0, 80));
        cameraController.cameraFlashMode = self.flashMode;
        self.cameraOverlayView.frame = cameraController.cameraOverlayView.frame;
        cameraController.cameraOverlayView = self.cameraOverlayView;
        self.imagePickerController = cameraController;
        [self presentViewController:cameraController animated:NO completion:nil];
        self.isCameraModeOn = YES;
        
        self.openCam = NO;
    }
    
    //    TODO: if user coming from profile page automatically switch camera to selfie mode.
    //[self.switchCameraDirectionButtonTapped sendActionsForControlEvents: UIControlEventTouchUpInside];
    
}

- (IBAction)photoLibraryButtonTapped:(UIButton *)sender
{
    self.isCameraModeOn = NO;
    
    [self dismissViewControllerAnimated:NO completion:^{
       
        UIImagePickerController *libraryController = [[UIImagePickerController alloc] init];
        libraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //Setting the library controller to the delegate allows the image picked in the library to call the didFinishPickingMediaWithInfo method and select the photo.
        libraryController.delegate = self;
        
        [self presentViewController:libraryController animated:NO completion:^{
            self.openCam =YES;
        }];
    }];
}

- (IBAction)captureButtonTapped:(UIButton *)sender
{
    [self.imagePickerController takePicture];
    self.openCam = YES;
}
//Hitting cancel from camera
- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    //If user is accessing the camera from the profile page
    if (self.isComingFromProfilePage == YES)
    {
        self.openCam = NO;
        [self dismissViewControllerAnimated:NO completion:^{
            
            UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
            ZOLTabBarViewController *tabBarViewController = [feedStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
            
            self.openCam = YES;
            self.isComingFromProfilePage = NO;
            
            [tabBarViewController setSelectedIndex:2];
            
            [self presentViewController: tabBarViewController animated:YES completion:nil];
        }];
        
    } else {
        [self.tabBarController setSelectedIndex:0];
        
        [self.tabBarController dismissViewControllerAnimated:NO completion:^{
            self.openCam = YES;
        }];
    }
}

//Hitting cancel from the photo library
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //If user is canceling from the camera from the profile page
    if (self.isComingFromProfilePage == YES)
    {
        self.openCam = NO;
        [self dismissViewControllerAnimated:NO completion:^{
        
            UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
            ZOLTabBarViewController *tabBarViewController = [feedStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
            
            self.openCam = YES;
            self.isComingFromProfilePage = NO;
            
            [tabBarViewController setSelectedIndex:2];
            
            [self presentViewController: tabBarViewController animated:YES completion:nil];
        }];
        
    } else {
            self.openCam = NO;
            [self.tabBarController dismissViewControllerAnimated:NO completion:^{
                
                UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
                ZOLTabBarViewController *tabBarViewController = [feedStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
                
                self.openCam = YES;
                
                [tabBarViewController setSelectedIndex:1];
                
                [self presentViewController: tabBarViewController animated:YES completion:nil];
            
            
        }];
    }
}

- (IBAction)switchCameraButtonTapped:(UIButton *)sender
{
    self.openCam = YES;
    if (self.cameraDevice == UIImagePickerControllerCameraDeviceRear)
    {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
    }else if (self.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)flashButtonTapped:(UIButton *)sender {
    self.openCam = YES;
    if (self.flashMode == -1)
    {
        NSLog(@"flash is auto!");
        [self.flashButtonIcon setImage:[UIImage imageNamed:@"FlashAuto"] forState:UIControlStateNormal];
        
    }
    else if (self.flashMode == 0)
    {
        NSLog(@"flash is on!");
        [self.flashButtonIcon setImage:[UIImage imageNamed:@"FlashActive"] forState:UIControlStateNormal];
        
    }
    else if(self.flashMode == 1)
    {
        NSLog(@"flash is off!");
        [self.flashButtonIcon setImage:[UIImage imageNamed:@"FlashInactive"] forState:UIControlStateNormal];
        self.flashMode = -2;
    }

    [self dismissViewControllerAnimated:NO completion:nil];
    
    self.flashMode++;
}

//Saving image to documents directory
-(void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,
                               id> *)info
{
    //If user is accessing the camera from the profile page
    if (self.isComingFromProfilePage == YES)
    {
        NSLog(@"Is coming to camera from profile page");
        
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        NSLog(@"Image: %@", image);
        
        //Save the profile picture in documents file on phone
        NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [self saveImage:image withFileName:@"ProfilePic" ofType:@"jpg" inDirectory:documentsDirectory];

        //Transition back to the profile page
        self.openCam = NO;

        [self dismissViewControllerAnimated:NO completion:^{
            
            UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
            ZOLTabBarViewController *tabBarViewController = [feedStoryboard instantiateViewControllerWithIdentifier:@"TabBarVC"];
            
            self.openCam = YES;
            self.isComingFromProfilePage = NO;
            
            [tabBarViewController setSelectedIndex:2];
    
            [self presentViewController: tabBarViewController animated:YES completion:nil];
        }];

    } else {
 
        ZOLDataStore *dataStore = [ZOLDataStore dataStore];
        
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSURL *imageURL = [dataStore.client writeImage:image toTemporaryDirectoryWithQuality:0];

        if (self.isCameraModeOn)
        {
            PHPhotoLibrary *photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
            
            [photoLibrary performChanges:^
            {
                [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            }
                       completionHandler:^(BOOL success, NSError * _Nullable error)
            {
                NSLog(@"Error?: %@, Success?: %d", error, success);
            }];
        }
        self.openCam = NO;
        [self.tabBarController dismissViewControllerAnimated:NO completion:^{
   
            UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
            ZOLAcceptPhotoViewController *acceptViewController = [feedStoryboard instantiateViewControllerWithIdentifier:@"acceptPhotoViewController"];
                    acceptViewController.currentImage = image;
                    acceptViewController.currentImageURL = imageURL;
            self.openCam = YES;
            [self.tabBarController presentViewController:acceptViewController animated:YES completion:nil];
        }];
    }
    
}

@end

