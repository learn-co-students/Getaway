//
//  ZOLCameraViewController.m
//  HoneymoonApp
//
//  Created by Jennifer A Sipila on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLCameraViewController.h"
#import "ZOLAcceptPhotoViewController.h"

@interface ZOLCameraViewController ()

@property (strong,nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIView *cameraOverlayView;
@property (nonatomic)BOOL isCameraModeOn;
@property(nonatomic)UIImagePickerControllerCameraDevice cameraDevice;
@property(nonatomic)UIImagePickerControllerCameraFlashMode flashMode;
@property (strong, nonatomic) IBOutlet UIButton *flashButtonIcon;

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

-(void)viewDidAppear:(BOOL)animated {
    
    
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
    
}

- (IBAction)cameraButtonTapped:(UIButton *)sender
{
}

- (IBAction)photoLibraryButtonTapped:(UIButton *)sender
{
    self.isCameraModeOn = NO;
    
    [self dismissViewControllerAnimated:NO completion:^{
        UIImagePickerController *libraryController = [[UIImagePickerController alloc] init];
        libraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.tabBarController setSelectedIndex:0];
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

- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    
    [self.tabBarController setSelectedIndex:0];
    
    [self.tabBarController dismissViewControllerAnimated:NO completion:^{
        self.openCam = YES;
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    self.openCam = YES;

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

    [self dismissViewControllerAnimated:NO completion:^{
        [self cameraButtonTapped:sender];
    }];
    
    self.flashMode++;
}

- (IBAction)showCameraLibraryButtonTapped:(UIButton *)sender
{
    UIImagePickerController *libraryController = [[UIImagePickerController alloc] init];
    libraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:libraryController animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,
                               id> *)info
{
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
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
//         /Users/andreasvestergaard/Development/code/ios-0216-team-yam/HoneymoonApp/ZOLAcceptPhotoViewController.h   dispatch_semaphore_signal(semaphore);
        }];
    }
    
    [self.tabBarController setSelectedIndex:0];
    [self.tabBarController dismissViewControllerAnimated:NO completion:^{
//    [self performSegueWithIdentifier:@"acceptSegue" sender:nil];
        UIStoryboard *feedStoryboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
        ZOLAcceptPhotoViewController *acceptViewController = [feedStoryboard instantiateViewControllerWithIdentifier:@"acceptPhotoViewController"];
                acceptViewController.currentImage = image;
                acceptViewController.currentImageURL = imageURL;
        [self.tabBarController presentViewController:acceptViewController animated:YES completion:nil];
    }];
 
    
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
   
//    [self dismissViewControllerAnimated:NO completion:^{
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        ZOLAcceptPhotoViewController *acceptViewController = [[ZOLAcceptPhotoViewController alloc]init];
//        
//        acceptViewController.currentImage = image;
//        acceptViewController.currentImageURL = imageURL;
//        
//        [self presentViewController:acceptViewController animated:NO completion:nil];
//    }];
}

@end

