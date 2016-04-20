//
//  ZOLCameraViewController.h
//  HoneymoonApp
//
//  Created by Jennifer A Sipila on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ZOLMainTableViewController.h"

@interface ZOLCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property  (nonatomic) BOOL openCam;
@property (nonatomic)BOOL isComingFromProfilePage;


+ (void)openCamFunction;
-(void)comingFromProfilePage:(NSNotification *)notification;

@end
