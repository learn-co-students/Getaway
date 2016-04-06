//
//  CKViewController.h
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/2/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
#import "CloudKitDataBase.h"
#import "CKViewController.h"

@interface CKViewController : UIViewController

@property (strong, nonatomic) CloudKitDataBase *datastore;

//+(void)setup;


@end
