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

@end

@implementation ZOLMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.localImageArray = [[NSMutableArray alloc]init];
    self.localTextArray = [[NSMutableArray alloc]init];
    
    self.dataStore = [ZOLDataStore dataStore];
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"feedSegue"]) {
    UINavigationController *destinationVC = [segue destinationViewController];
    ZOLDetailTableViewController *tableVC = (ZOLDetailTableViewController*)destinationVC.topViewController;
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    tableVC.localImageArray = self.localImageArray[selectedIndexPath.row];
        tableVC.localTextArray = self.localTextArray[selectedIndexPath.row];
    }
}


- (IBAction)mainFeedPullToRefresh:(UIRefreshControl *)sender {
    
    [self.dataStore.client queryRecordsWithQuery:nil orCursor:self.dataStore.mainFeedCursor fromDatabase:self.dataStore.client.database everyRecord:^(CKRecord *record) {
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
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopRefreshSpin:) name:@"QueryRefreshIssue" object:nil];
}

//-(void)stopRefreshSpin: (NSNotification *)notification
//{
//    [self.refreshControl endRefreshing];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
