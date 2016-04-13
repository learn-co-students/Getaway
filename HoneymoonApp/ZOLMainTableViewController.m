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
    
//    ZOLSimulatedFeedData *sharedDatastore = [ZOLSimulatedFeedData sharedDatastore];
//    self.localImageArray = sharedDatastore.mainImageArray;
//    self.localTextArray = sharedDatastore.mainTextArray;
    self.localImageArray = [[NSMutableArray alloc]init];
    self.localTextArray = [[NSMutableArray alloc]init];
    
    self.dataStore = [ZOLDataStore dataStore];

//    for (ZOLHoneymoon *honeymoon in self.dataStore.mainFeed)
//    {
//        [self.localImageArray insertObject:honeymoon.coverPicture atIndex:0];
//        [self.localTextArray insertObject:honeymoon.honeymoonDescription atIndex:0];
//    }
//    CKReference *honeymoonImages = [[CKReference alloc]initWithRecordID:dataStore.user.userHoneymoon.honeymoonID action:CKReferenceActionDeleteSelf];
//    NSPredicate *findImages = [NSPredicate predicateWithFormat:@"Honeymoon == %@", honeymoonImages];
//    CKQuery *imageQuery = [[CKQuery alloc]initWithRecordType:@"Image" predicate:findImages];
//    
//    dispatch_semaphore_t imageSem = dispatch_semaphore_create(0);
//    CKQueryOperation *imageFindOp = [[CKQueryOperation alloc]initWithQuery:imageQuery];
//    imageFindOp.recordFetchedBlock = ^(CKRecord *record){
//        CKAsset *image = record[@"Picture"];
//        UIImage *picture = [dataStore.client retrieveUIImageFromAsset:image];
//        
//        NSString *captionText = record[@"Caption"];
//        
//        [capturedImageArray addObject:picture];
//        [capturedTextArray addObject:captionText];
//    };
//    imageFindOp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error){
//        
//        if (error)
//        {
//            NSLog(@"%@", error.localizedDescription);
//        }
////        [self.localImageArray addObject:capturedImageArray];
////        [self.localTextArray addObject:capturedTextArray];
//        dispatch_semaphore_signal(imageSem);
//    };
//    
//    [dataStore.client.database addOperation:imageFindOp];
//    dispatch_semaphore_wait(imageSem, DISPATCH_TIME_FOREVER);
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
    [self.tableView reloadData];
    [sender endRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
