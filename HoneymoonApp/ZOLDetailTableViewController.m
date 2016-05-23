
//
//  ZOLDetailTableViewController.m
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 05/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLDetailTableViewController.h"
#import "ZOLSimulatedFeedData.h"
#import "ZOLDetailCell.h"


@interface ZOLDetailTableViewController ()

@property (nonatomic,strong) NSLayoutConstraint *labelYConstraint;
@property (strong, nonatomic) IBOutlet UIButton *flaggedButton;

@end


@implementation ZOLDetailTableViewController

- (IBAction)back:(id)sender
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)flagged:(id)sender
{
    UIAlertController *flagAndBlockUserAlertController = [UIAlertController alertControllerWithTitle:@"Inappropriate or offensive content?" message:@"Flag content or block user" preferredStyle:UIAlertControllerStyleActionSheet
                                                                             ];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             self.flaggedButton.tintColor = [UIColor whiteColor];
                                                         
                                                         }];
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"Report content"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         //Block this user
                                                         NSLog(@"USER FLAGGED");
                                                         self.flaggedButton.tintColor = [UIColor redColor];
                                                         
                                                         [self blockedUser];
                                                         
                                                        }];
    
    
    
    
    UIAlertAction *blockAction = [UIAlertAction actionWithTitle:@"Block user"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         //Flag this content
                                                         NSLog(@"USER BLOCKED");
                                                         
                                                         [self flaggedHoneymoon];
                                                         
                                                         self.flaggedButton.tintColor = [UIColor redColor];
                                                        }];
    
    [flagAndBlockUserAlertController addAction:cancelAction];
    [flagAndBlockUserAlertController addAction:reportAction];
    [flagAndBlockUserAlertController addAction:blockAction];
                                                         
    [self presentViewController:flagAndBlockUserAlertController animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
  //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    UIImageView *headerView = [UIImageView new];
    
    //Headline label
    UILabel *labelHeadline = [[UILabel alloc]init];
    labelHeadline.text = self.titleString;
    labelHeadline.textColor = [UIColor whiteColor];
    labelHeadline.textAlignment = NSTextAlignmentCenter;
    [labelHeadline setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:35]];
    labelHeadline.adjustsFontSizeToFitWidth = YES;
    
//    DarkOverlayView
//    UIImageView *overlayView = [UIImageView new];
//    overlayView.translatesAutoresizingMaskIntoConstraints = NO;
//    [overlayView setBackgroundColor:[UIColor colorWithRed:255 green:0  blue:0 alpha:1]];
//    [headerView addSubview:overlayView];
//    //overlay constraints
//    [overlayView.widthAnchor constraintEqualToConstant:123];
//    [overlayView.heightAnchor constraintEqualToConstant:234];
//    [overlayView.centerXAnchor constraintEqualToAnchor:headerView.centerXAnchor];
//    [overlayView.centerYAnchor constraintEqualToAnchor:headerView.centerYAnchor];
    
    //Explore icon
    UIImageView *exploreIconView = [UIImageView new];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    labelHeadline.translatesAutoresizingMaskIntoConstraints = NO;
    exploreIconView.translatesAutoresizingMaskIntoConstraints = NO;
    exploreIconView.image = [UIImage imageNamed:@"explore"];
    [headerView addSubview:exploreIconView];
    [exploreIconView.centerYAnchor constraintEqualToAnchor:headerView.centerYAnchor constant:275].active = YES;
    [exploreIconView.centerXAnchor constraintEqualToAnchor:headerView.centerXAnchor].active = YES;
    [exploreIconView.widthAnchor constraintEqualToConstant:80].active = YES;
    [exploreIconView.heightAnchor constraintEqualToConstant:60].active = YES;
    
    //header
    [headerView addSubview:labelHeadline ];
    headerView.image = self.parralaxHeaderImage;
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    
    //Constraints
    [labelHeadline.centerXAnchor constraintEqualToAnchor: headerView.centerXAnchor].active = YES;
    self.labelYConstraint = [labelHeadline.centerYAnchor constraintEqualToAnchor:headerView.centerYAnchor];
    self.labelYConstraint.active = YES;
    [labelHeadline.heightAnchor constraintEqualToConstant:20];
    [labelHeadline.widthAnchor constraintEqualToAnchor: headerView.widthAnchor].active = YES;
    
    //Parralaxheader
    self.tableView.parallaxHeader.view = headerView;
    self.tableView.parallaxHeader.height = self.tableView.frame.size.height;
    self.tableView.parallaxHeader.mode =  MXParallaxHeaderModeTopFill;
    self.tableView.parallaxHeader.minimumHeight = 0;
    
    self.navigationController.navigationBar.topItem.title = @"";
    self.dataStore = [ZOLDataStore dataStore];
    [self populateImages];
}


- (void) flaggedHoneymoon
{
    CKRecord *flaggedHoneymoonRecord = [self.dataStore.client fetchRecordWithRecordID:self.selectedHoneymoonID];
    flaggedHoneymoonRecord[@"Flagged"] = @"YES";
    CKModifyRecordsOperation *flaggedRecord = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:@[flaggedHoneymoonRecord] recordIDsToDelete:nil];
    [self.dataStore.client.database addOperation:flaggedRecord];
}

- (void) blockedUser
{
    CKRecord *blockedUserRecord = [self.dataStore.client fetchRecordWithRecordID:self.selectedHoneymoonID];
    blockedUserRecord[@"ReportAbusiveUser"] = @"YES";
    CKModifyRecordsOperation *blockedRecord = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:@[blockedUserRecord] recordIDsToDelete:nil];
    [self.dataStore.client.database addOperation:blockedRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.localImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZOLDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    ZOLImage *thisImage = self.localImageArray[indexPath.row];
    cell.image.image = thisImage.picture;
    cell.text.text = thisImage.caption;
    return cell;
}

-(void)populateImages
{
    CKReference *selectedHoneymoonReference = [[CKReference alloc]initWithRecordID:self.selectedHoneymoonID action:CKReferenceActionDeleteSelf];
    NSPredicate *imagePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"Honeymoon", selectedHoneymoonReference];
    CKQuery *honeymoonImagesQuery = [[CKQuery alloc] initWithRecordType:@"Image" predicate:imagePredicate];
    NSArray *relevantKeys = @[@"Picture", @"Honeymoon"];
    
    __weak typeof(self) tmpself = self;
    [self.dataStore.client queryRecordsWithQuery:honeymoonImagesQuery orCursor:nil fromDatabase:self.dataStore.client.database forKeys:relevantKeys withQoS:NSQualityOfServiceUserInitiated everyRecord:^(CKRecord *record)
    {
        for (ZOLImage *image in tmpself.localImageArray)
        {
            if ([image.imageRecordID isEqual:record.recordID])
            {
                UIImage *retrievedImage = [tmpself.dataStore.client retrieveUIImageFromAsset:record[@"Picture"]];
                image.picture = retrievedImage;
                NSUInteger rowOfImage = [tmpself.localImageArray indexOfObject:image];
                NSIndexPath *indexPathForImage = [NSIndexPath indexPathForRow:rowOfImage inSection:0];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [tmpself.tableView reloadRowsAtIndexPaths:@[indexPathForImage] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
        }
    }
        completionBlock:^(CKQueryCursor *cursor, NSError *error)
     {
         NSLog(@"Detail image query done");
         if (error)
         {
             NSLog(@"Error getting images for a honeymoon: %@", error.localizedDescription);
//             NSDate *waitTime = [NSDate dateWithTimeIntervalSinceNow: 2];
//             NSTimer *retryTimer = [[NSTimer alloc]initWithFireDate:waitTime interval:2 target:self selector:@selector(populateImages) userInfo:nil repeats:NO];
             NSTimer *retryTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(populateImages) userInfo:nil repeats:NO];
             NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];
             [currentLoop addTimer:retryTimer forMode:NSDefaultRunLoopMode];
             [currentLoop run];
//             [retryTimer fire];
         }
     }];
}

-(void)retryQueryRecordsWithQueryMethod
{
    CKReference *selectedHoneymoonReference = [[CKReference alloc]initWithRecordID:self.selectedHoneymoonID action:CKReferenceActionDeleteSelf];
    NSPredicate *imagePredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"Honeymoon", selectedHoneymoonReference];
    CKQuery *honeymoonImagesQuery = [[CKQuery alloc] initWithRecordType:@"Image" predicate:imagePredicate];
    NSArray *relevantKeys = @[@"Picture", @"Honeymoon"];
    __weak typeof(self) tmpself = self;
    
    [self.dataStore.client queryRecordsWithQuery:honeymoonImagesQuery
                                        orCursor:nil
                                    fromDatabase:self.dataStore.client.database
                                         forKeys:relevantKeys
                                         withQoS:NSQualityOfServiceUserInitiated
                                     everyRecord:^(CKRecord *record)
     {
         for (ZOLImage *image in tmpself.localImageArray)
         {
             if ([image.imageRecordID isEqual:record.recordID])
             {
                 UIImage *retrievedImage = [tmpself.dataStore.client retrieveUIImageFromAsset:record[@"Picture"]];
                 image.picture = retrievedImage;
                 NSUInteger rowOfImage = [tmpself.localImageArray indexOfObject:image];
                 NSIndexPath *indexPathForImage = [NSIndexPath indexPathForRow:rowOfImage inSection:0];
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^
	                 {
                         [tmpself.tableView reloadRowsAtIndexPaths:@[indexPathForImage] withRowAnimation:UITableViewRowAnimationNone];
                     }];
             }
         }
     } completionBlock:^(CKQueryCursor *cursor, NSError *error)
	    {
            if (error)
            {
                NSLog(@"Experienced error in 'retryQueryRecordsWithQueryMethod' method error code: %lu", error.code);
                
                UIAlertController *secondTryError = [UIAlertController alertControllerWithTitle:@"Refresh Needed"
                                                                                        message:@"In order to retrieve this content the app needs to be refreshed. Please go back to the main feed and reselect this honeymoon." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *secondTryErrorAction = [UIAlertAction actionWithTitle:@"OK"
                                                                               style:UIAlertActionStyleDefault
                                                                             handler:nil];
                [secondTryError addAction: secondTryErrorAction];
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [self presentViewController:secondTryError animated:YES completion:nil];
                }];
            }
        }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
