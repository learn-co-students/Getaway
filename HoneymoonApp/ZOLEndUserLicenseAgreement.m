//
//  ZOLEndUserLicenseAgreement.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 5/20/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLEndUserLicenseAgreement.h"

@interface ZOLEndUserLicenseAgreement ()
@end

@implementation ZOLEndUserLicenseAgreement


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (void)EULA
{
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^
//     {
//         NSLog(@"GO FOR SEGUEEEE");
//         
//         UIStoryboard *loginStoryboard =[UIStoryboard storyboardWithName:@"LoginScreen" bundle:nil];
//         ZOLEndUserLicenseAgreement *EULAVC = [loginStoryboard instantiateViewControllerWithIdentifier:@"EULAVC"];
//     
//        [ presentViewController: EULAVC animated: YES completion: nil];
//
//         [currentViewController presentViewController: EULAVC animated: YES completion: nil];
//     }];
    
};

- (IBAction)acceptButtonTapped:(id)sender
{
    NSLog(@"User agreed to EULA");
    [self dismissViewControllerAnimated:YES completion:^
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EULAAccepted" object:self];

    }];
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

@end
