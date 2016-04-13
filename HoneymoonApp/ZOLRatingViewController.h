//
//  ZOLRatingViewController.h
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 06/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HCSStarRatingView/HCSStarRatingView.h>
#import "ZOLDataStore.h"

@interface ZOLRatingViewController : UIViewController

@property (nonatomic, strong) ZOLDataStore *dataStore;
@property (nonatomic, strong) UIImage *coverImage;


@end
