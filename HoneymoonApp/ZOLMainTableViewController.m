//
//  ZOLMainTableViewController.m
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 05/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLMainTableViewController.h"
#import "ZOLMainCell.h"
#import "ZOLSimulatedFeedData.h"
#import "ZOLDetailTableViewController.h"
#import "ZOLCameraViewController.h"

@interface ZOLMainTableViewController ()

@property (nonatomic, strong) NSMutableArray *imagesToPush;

@end

@implementation ZOLMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagesToPush = [[NSMutableArray alloc]init];
    
    self.dataStore = [ZOLDataStore dataStore];
    
    NSPredicate *imagePredicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH %@", @"Published", @"YES"];
    CKQuery *honeymoonImageQuery = [[CKQuery alloc] initWithRecordType:@"Honeymoon" predicate:imagePredicate];
    NSArray *relevantKeys = @[@"CoverPicture", @"Published"];
    
    [self.dataStore.client queryRecordsWithQuery:honeymoonImageQuery orCursor:nil fromDatabase:self.dataStore.client.database forKeys:relevantKeys everyRecord:^(CKRecord *record) {
        //Put the image we get into the relevant cell
        NSLog(@"Found a record: %@", record.recordID);

        for (ZOLHoneymoon *honeymoon in self.dataStore.mainFeed)
        {
            NSLog(@"Record name is: %@, and honeymoon record is: %@",record.recordID.recordName, honeymoon.honeymoonID.recordName);
            if ([honeymoon.honeymoonID.recordName isEqualToString:record.recordID.recordName])
            {
                NSLog(@"Found the right record!: %@", record.recordID);
                UIImage *retrievedImage = [self.dataStore.client retrieveUIImageFromAsset:record[@"CoverPicture"]];
                honeymoon.coverPicture = retrievedImage;
                NSUInteger rowOfHoneymoon = [self.dataStore.mainFeed indexOfObject:honeymoon];
                NSIndexPath *indexPathForHoneymoon = [NSIndexPath indexPathForRow:rowOfHoneymoon inSection:0];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.tableView reloadRowsAtIndexPaths:@[indexPathForHoneymoon] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
        }
    } completionBlock:^(CKQueryCursor *cursor, NSError *error) {
        //do something when we're done?
        NSLog(@"Image query done");
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataStore.mainFeed.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZOLMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMain" forIndexPath:indexPath];
    
    ZOLHoneymoon *thisHoneymoon = self.dataStore.mainFeed[indexPath.row];
    
    cell.image.image = thisHoneymoon.coverPicture;
    cell.cellRating = thisHoneymoon.rating;
    [cell drawStarRating];
    
    cell.headlineLabel.text = thisHoneymoon.honeymoonDescription;
    
    //TODO: Give a placeholder image if image unavailable
    //TODO: Load the image when it comes through on the query operation (use recordFetchedBlock?) and reload cell
    
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"row selected: %lu", indexPath.row);
//    ZOLHoneymoon *honeymoonSelected = self.dataStore.mainFeed[indexPath.row];
//    
//    self.imagesToPush = honeymoonSelected.honeymoonImages;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"feedSegue"]) {
        UINavigationController *destinationVC = [segue destinationViewController];
        ZOLDetailTableViewController *tableVC = (ZOLDetailTableViewController*)destinationVC.topViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
            
        ZOLHoneymoon *honeymoonSelected = self.dataStore.mainFeed[selectedIndexPath.row];
            
        tableVC.localImageArray = honeymoonSelected.honeymoonImages;
        tableVC.selectedHoneymoonID = honeymoonSelected.honeymoonID;
    }
}


- (IBAction)mainFeedPullToRefresh:(UIRefreshControl *)sender {
    
    [self.dataStore.client queryRecordsWithQuery:nil orCursor:self.dataStore.mainFeedCursor fromDatabase:self.dataStore.client.database forKeys:nil everyRecord:^(CKRecord *record) {
        ZOLHoneymoon *thisHoneymoon = [[ZOLHoneymoon alloc]init];
        
        CKAsset *coverPictureAsset = record[@"CoverPicture"];
        UIImage *coverPic = [self.dataStore.client retrieveUIImageFromAsset:coverPictureAsset];
        thisHoneymoon.coverPicture = coverPic;
        
        NSNumber *ratingVal = record[@"RatingStars"];
        thisHoneymoon.rating = [ratingVal floatValue];
        
        thisHoneymoon.honeymoonDescription = record[@"Description"];
        
        [self.dataStore.mainFeed insertObject:thisHoneymoon atIndex:0];

    } completionBlock:^(CKQueryCursor *cursor, NSError *error) {
        if (error)
        {
            NSLog(@"Error reloading main feed data: %@", error.localizedDescription);
        }
        else
        {
            self.dataStore.mainFeedCursor = cursor;
        }
        
        [self.tableView reloadData];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [sender endRefreshing];
        }];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopRefreshSpin:) name:@"QueryRefreshIssue" object:nil];
}

-(void)stopRefreshSpin: (NSNotification *)notification
{
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
