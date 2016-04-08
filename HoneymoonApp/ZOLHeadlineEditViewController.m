//
//  ZOLHeadlineEditViewController.m
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 06/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLHeadlineEditViewController.h"

@interface ZOLHeadlineEditViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ZOLHeadlineEditViewController

- (IBAction)backgroundTapped:(id)sender {
    [self.textField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
        [self.textField resignFirstResponder];
    return YES;
}

- (IBAction)mainFeedButtonTapped:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
