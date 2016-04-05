//
//  ZOLRegisterViewController.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLRegisterViewController.h"

@interface ZOLRegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation ZOLRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStore = [ZOLDataStore dataStore];
    [self.dataStore fetchData];
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerTapped:(id)sender
{
    if ([self usernameValid] && [self passwordValid] && [self confirmPasswordValid])
    {
        User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.dataStore.managedObjectContext];
        newUser.username = self.usernameTextField.text;
        newUser.password = self.passwordTextField.text;
        
        [self.dataStore saveContext];
        
        CKRecordID *userID = [[CKRecordID alloc] initWithRecordName:self.usernameTextField.text];
        CKRecord *newUserRecord = [[CKRecord alloc] initWithRecordType:@"User" recordID:userID];
        
        [newUserRecord setObject:self.passwordTextField.text forKey:@"Password"];
        
        [self.dataStore.database saveRecord:newUserRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            NSLog(@"%@, and also: %ld", error, error.code);
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        NSMutableString *errorString = [NSMutableString new];
        
        BOOL usernameValid = [self usernameValid];
        if (!usernameValid)
        {
            [errorString appendString:@"Usernames must be at least 1 character and cannot begin with a space\n"];
        }
        
        BOOL passwordValid = [self passwordValid];
        if (!passwordValid)
        {
            [errorString appendString:@"\nPasswords must be at least 8 characters in length\n"];
        }
        
        BOOL confirmPasswordValid = [self confirmPasswordValid];
        if(!confirmPasswordValid)
        {
            [errorString appendString:@"\nPasswords do not match"];
        }
        
        [self createAlertWithTitle:@"Please Resolve Issues:" andMessage:errorString];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            [view resignFirstResponder];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Validate text fields

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.usernameTextField isEqual:textField])
    {
        for (User *user in self.dataStore.users)
        {
            NSString *name = user.username;
            if ([name isEqualToString:self.usernameTextField.text])
            {
                [self createAlertWithTitle:@"Username Taken!" andMessage:@"The Username you selected is already taken, please select another one"];
                
                self.usernameTextField.text = @"";
            }
        }
    }
}

-(BOOL)usernameValid
{
    NSString *selectedName = self.usernameTextField.text;
    
    if(selectedName.length == 0 || [selectedName hasPrefix:@" "])
    {
        [self animateBackgroundForTextField:self.usernameTextField WithValidation:NO];
        return NO;
    }
    else
    {
        [self animateBackgroundForTextField:self.usernameTextField WithValidation:YES];
        return YES;
    }
}

-(BOOL)passwordValid
{
    NSString *selectedPassword = self.passwordTextField.text;
    
    if (selectedPassword.length < 8)
    {
        [self animateBackgroundForTextField:self.passwordTextField WithValidation:NO];
        return NO;
    }
    else
    {
        [self animateBackgroundForTextField:self.passwordTextField WithValidation:YES];
        return YES;
    }
}

-(BOOL)confirmPasswordValid
{
    NSString *selectedPassword = self.confirmPasswordTextField.text;
    
    if (![selectedPassword isEqualToString:self.passwordTextField.text])
    {
        [self animateBackgroundForTextField:self.confirmPasswordTextField WithValidation:NO];
        return NO;
    }
    else
    {
        [self animateBackgroundForTextField:self.confirmPasswordTextField WithValidation:YES];
        return YES;
    }
}

-(void)animateBackgroundForTextField: (UITextField *) textField WithValidation: (BOOL)isValid
{
    if (!isValid)
    {
        [UIView animateWithDuration:1 animations:^{
            textField.backgroundColor = [UIColor redColor];
        }];
    }
    else
    {
        [UIView animateWithDuration:1 animations:^{
            textField.backgroundColor = [UIColor whiteColor];
        }];
    }
}

-(void)createAlertWithTitle: (NSString *)title andMessage: (NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okButton];

    [self presentViewController:alertController animated:YES completion:nil];
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
