//
//  ZOLUserAgreement.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 5/20/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLUserAgreement.h"

@implementation ZOLUserAgreement

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)EULA
{
    self.EULAScrollView.hidden = NO;
  
    // self.EULAScrollView.scrollEnabled = YES;
    
    
    //        if (self.acceptButton)
    //        {
    //            dispatch_async(dispatch_get_main_queue(), ^
    //            {
    //
    //
    //            }
    //                          );
    //        }
    //
    //
    //
    //
    //            });
    
    
    // UIView *EULAView = [[UIView alloc]init];
    //    UIScrollView *EScrollV = [[UIScrollView alloc] init];
    //    UITextView *EContract = [[UITextView alloc]init];
    //    UIImage *EULAContract = [UIImage imageNamed:@"Getaway EULA Agreement  copy"];
    
    // EScrollV.contentSize = CGSizeEqualToSize(EULAContract.frame.size.width, EULAContract.frame.size.height);
}


- (void) agreeButtonTapped
{
    NSLog(@"User agreed to EULA");
    
};

@end
