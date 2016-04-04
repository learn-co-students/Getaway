//
//  ZOLCameraViewController.m
//  HoneymoonApp
//
//  Created by Jennifer A Sipila on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLCameraViewController.h"

@interface ZOLCameraViewController ()

@property (strong,nonatomic) UIImagePickerController *imagePickerController;

@property (strong, nonatomic) IBOutlet UIView *cameraOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *openCameraButton;


@property (nonatomic)BOOL isCameraModeOn;
@property(nonatomic, strong)NSMutableArray *photosArray;

@property(nonatomic)UIImagePickerControllerCameraDevice cameraDevice;
@property(nonatomic)UIImagePickerControllerCameraFlashMode flashMode;

@property (strong, nonatomic) IBOutlet UIButton *flashButtonIcon;

@end

@implementation ZOLCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photosArray = [[NSMutableArray alloc] init];
    
    [self.flashButtonIcon setImage:[UIImage imageNamed:@"FlashInactive"] forState:UIControlStateNormal];
    
    self.flashMode = -1;
    
    //self.openCameraButton sendActionsForControlEvents: UIControlEventTouchUpInside];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (IBAction)cameraButtonTapped:(UIButton *)sender
{
    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
    cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraController.delegate = self;
    
    cameraController.cameraDevice = self.cameraDevice;
    
    cameraController.showsCameraControls = NO;
    cameraController.toolbarHidden = YES;
    
    cameraController.cameraViewTransform = CGAffineTransformMakeScale(1.7, 1.7);
    cameraController.cameraFlashMode = self.flashMode;
    self.cameraOverlayView.frame = cameraController.cameraOverlayView.frame;
    
    cameraController.cameraOverlayView = self.cameraOverlayView;
    
    self.imagePickerController = cameraController;
    
    [self presentViewController:cameraController animated:NO completion:nil];
    
    self.isCameraModeOn = YES;

}


- (IBAction)photoLibraryButtonTapped:(UIButton *)sender
{
    self.isCameraModeOn = NO;
    
    [self dismissViewControllerAnimated:NO completion:^{
        UIImagePickerController *libraryController = [[UIImagePickerController alloc] init];
        libraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:libraryController animated:NO completion:nil];
    }];
}

- (IBAction)captureButtonTapped:(UIButton *)sender
{
    [self.imagePickerController takePicture];
}

- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)switchCameraButtonTapped:(UIButton *)sender
{
    if (self.cameraDevice == UIImagePickerControllerCameraDeviceRear)
    {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
    }else if (self.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self cameraButtonTapped:sender];
    }];
}

- (IBAction)flashButtonTapped:(UIButton *)sender
{
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
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    
    [self.photosArray addObject:image];
    
    if (self.isCameraModeOn)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    }
    //    [self dismissViewControllerAnimated:NO completion:nil];

}










//This is for adding the image to the array or to the library_______________

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
//    
//    [self.capturedImages addObject:image];
//    
////    if ([self.cameraTimer isValid])
////    {
////        return;
////    }
//    
//    [self finishAndUpdate];
//}





@end

