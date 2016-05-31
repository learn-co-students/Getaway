//
//  ZOLEndUserLicenseAgreement.h
//  HoneymoonApp
//
//  Created by Alicia Marisal on 5/20/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZOLEndUserLicenseAgreement : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *EULAScrollView;
//@property (nonatomic, weak) ZOLEndUserLicenseAgreement *EULAViewController;

//+(void)EULAwithCompletion:(void(^)(BOOL))didGrabEULA;
+(void) EULA;
@end

