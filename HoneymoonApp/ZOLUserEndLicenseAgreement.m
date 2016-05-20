//
//  ZOLUserEndLicenseAgreement.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 5/20/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLUserEndLicenseAgreement.h"

@interface ZOLEndUserLicenseAgreement ()

@end

@implementation ZOLEndUserLicenseAgreement

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+(void)EULA
{
    //self.EULAScrollView.hidden = NO;
    // self.EULAScrollView.scrollEnabled = YES;
    
}

- (IBAction)acceptButtonTapped:(id)sender
{
    NSLog(@"User agreed to EULA");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EULAAccepted" object:self];
}

- (IBAction)declineButtonTapped:(id)sender
{
    //UIController telling user they must agree to the Policy to use the GetawayApp
    
    UIAlertController *complianceAlert = [UIAlertController alertControllerWithTitle:@"User Compliance" message:@"All individuals using this app must agree to the Getaway Policy.\n Accept the policy to continue (basically just be a good person)" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *complianceAlertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                            {
                                                [ZOLEndUserLicenseAgreement EULA];
                                                
                                            }];
    
    [complianceAlert addAction: complianceAlertAction];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
         
         [self presentViewController:complianceAlert animated:YES completion:nil];
         
     }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
