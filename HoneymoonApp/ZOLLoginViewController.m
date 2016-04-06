//
//  ZOLLoginViewController.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 3/31/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLLoginViewController.h"

@interface ZOLLoginViewController ()

@property (nonatomic, assign) __block BOOL shouldLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ZOLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStore = [ZOLDataStore dataStore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSURL *)writeImage:(UIImage *)image toTemporaryDirectoryWithQuality:(CGFloat)compressionQuality
{
    //TODO: check out AssetLibrary framework - saves images to phone and give URLs
    
    NSURL *tempDirectory = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    
    // we need some garbage (but unique!) name for the file
    NSString *filename = [[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"];
    
    NSURL *tempFile = [tempDirectory URLByAppendingPathComponent:filename];
    
    NSData *imageData = UIImageJPEGRepresentation(image, compressionQuality);
    
    [imageData writeToURL:tempFile atomically:YES];
    
    return tempFile;
}

- (IBAction)loginTapped:(id)sender
{
//    CKRecordID *userID = [[CKRecordID alloc] init];
    
    //If asset is baked into app:
//    NSURL *alaskaURL = [[NSBundle mainBundle] URLForResource:@"alaska" withExtension:@"jpg"];
//    UIImage *alaska = [[UIImage imageNamed:@"alaska"]];
//    
//    NSURL *alaskaURL = [self writeImage:alaska toTemporaryDirectoryWithQuality:100];
//    
//    CKRecord *newImageRecord = [[CKRecord alloc] initWithRecordType:@"Image"];
//    
//    CKAsset *imageAsset = [[CKAsset alloc] initWithFileURL:alaskaURL];
//    
//    [newImageRecord setObject:imageAsset forKey:@"Picture"];
//    [newImageRecord setObject:@"It's Alaska I guess" forKey:@"Caption"];
//    
//    [self.dataStore.database saveRecord:newImageRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
//        NSLog(@"%@, and also: %ld", error.localizedDescription, error.code);
//    }];
//
//    CKRecord *newHoneymoon = [[CKRecord alloc] initWithRecordType:@"Honeymoon"];
//    [newHoneymoon setObject:@(5) forKey:@"Cost"];
//    [newHoneymoon setObject:@"World Hopper" forKey:@"Description"];
//    [newHoneymoon setObject:@"Phileas and Jean's Honeymoon" forKey:@"Name"];
//    
//    CKReference *honeymoonReference = [[CKReference alloc] initWithRecord:newHoneymoon action:CKReferenceActionDeleteSelf];
//    
//    
//    CKRecordID *recordToFetch1 = [[CKRecordID alloc] initWithRecordName:@"China"];
//    CKRecordID *recordToFetch2 = [[CKRecordID alloc] initWithRecordName:@"Ireland"];
//    CKRecordID *recordToFetch3 = [[CKRecordID alloc] initWithRecordName:@"Israel"];
//    CKRecordID *recordToFetch4 = [[CKRecordID alloc] initWithRecordName:@"murica"];
//    
//    NSArray *recordsToFetch = @[recordToFetch1, recordToFetch2, recordToFetch3, recordToFetch4];
//    
//    CKFetchRecordsOperation *fetchRecords = [[CKFetchRecordsOperation alloc] initWithRecordIDs:recordsToFetch];
//
//    fetchRecords.perRecordCompletionBlock = ^(CKRecord *record, CKRecordID *recordID, NSError *error){
//        if (error)
//        {
//            <#statements#>
//        }
//    };
    
//    [self.dataStore.database fetchRecordWithID:recordToFetch completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
//        if (error)
//        {
//            NSLog(@"There was a problem: %@, code: %ld", error.localizedDescription, error.code);
//        }
//        
//        
//    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.activityIndicator startAnimating];
    
    if ([identifier isEqualToString:@"LoggedIn"])
    {
        [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusNoAccount)
        {
            self.shouldLogin = NO;
        }
        else
        {
            self.shouldLogin = YES;
            NSLog(@"Account Access!");
        }
        dispatch_semaphore_signal(semaphore);
        }];
    }

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self.activityIndicator stopAnimating];
    
    if (!self.shouldLogin)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                                                       message:@"Sign in to your iCloud account to use this app. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap 'Create a new Apple ID'."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
 
        return self.shouldLogin;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
