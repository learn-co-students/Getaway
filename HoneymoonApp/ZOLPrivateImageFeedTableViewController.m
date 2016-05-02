//
//  ZOLPrivateImageFeedTableViewController.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/12/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLPrivateImageFeedTableViewController.h"
#import "ZOLImage.h"
#import "ZOLPrivateTableViewCell.h"

@interface ZOLPrivateImageFeedTableViewController ()

@end

@implementation ZOLPrivateImageFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [ZOLDataStore dataStore];
    self.localImageArray = self.dataStore.user.userHoneymoon.honeymoonImages;
    
    CKReference *referenceToHoneymoon = [[CKReference alloc]initWithRecordID:self.dataStore.user.userHoneymoon.honeymoonID action:CKReferenceActionDeleteSelf];
    NSPredicate *userHoneymoonPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"Honeymoon", referenceToHoneymoon];
    CKQuery *honeymoonImageQuery = [[CKQuery alloc] initWithRecordType:@"Image" predicate:userHoneymoonPredicate];
    NSArray *relevantKeys = @[@"Picture", @"Honeymoon"];
    
    __weak typeof(self) tmpself = self;
    [self.dataStore.client queryRecordsWithQuery:honeymoonImageQuery orCursor:nil fromDatabase:self.dataStore.client.database forKeys:relevantKeys withQoS:NSQualityOfServiceUserInitiated everyRecord:^(CKRecord *record) {
        //Put the image we get into the relevant cell
        for (ZOLImage *image in tmpself.localImageArray)
        {
            if ([image.imageRecordID.recordName isEqualToString:record.recordID.recordName])
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
    } completionBlock:^(CKQueryCursor *cursor, NSError *error) {
        //do something when we're done?
        NSLog(@"Image query done");
    }];
}
- (IBAction)backButtonTapped:(UIBarButtonItem *)sender
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.localImageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZOLPrivateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privateDetailCell" forIndexPath:indexPath];
    
    ZOLImage *thisImage = self.localImageArray[indexPath.row];
    
    cell.privateCellImage.image = thisImage.picture;
    cell.privateCellLabel.text = thisImage.caption;
    
    return cell;
}

- (IBAction)privatePullToRefresh:(UIRefreshControl *)sender {
    [self.tableView reloadData];
    [sender endRefreshing];
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
