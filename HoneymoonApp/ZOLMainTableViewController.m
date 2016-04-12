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
    
    ZOLSimulatedFeedData *sharedDatastore = [ZOLSimulatedFeedData sharedDatastore];
    self.localImageArray = sharedDatastore.mainImageArray;
    self.localTextArray = sharedDatastore.mainTextArray;

    __block NSMutableArray *capturedImageArray = [[NSMutableArray alloc]init];
    __block NSMutableArray *capturedTextArray = [[NSMutableArray alloc]init];
    
    ZOLDataStore *dataStore = [ZOLDataStore dataStore];
    
    CKReference *honeymoonImages = [[CKReference alloc]initWithRecordID:dataStore.user.honeymoonID action:CKReferenceActionDeleteSelf];
    NSPredicate *findImages = [NSPredicate predicateWithFormat:@"Honeymoon == %@", honeymoonImages];
    CKQuery *imageQuery = [[CKQuery alloc]initWithRecordType:@"Image" predicate:findImages];
    
    dispatch_semaphore_t imageSem = dispatch_semaphore_create(0);
    CKQueryOperation *imageFindOp = [[CKQueryOperation alloc]initWithQuery:imageQuery];
    imageFindOp.recordFetchedBlock = ^(CKRecord *record){
        CKAsset *image = record[@"Picture"];
        NSURL *imageURL = image.fileURL;
        NSData *imageData = [NSData dataWithContentsOfFile:imageURL.path];
        UIImage *picture = [UIImage imageWithData:imageData];
        
        NSString *captionText = record[@"Caption"];
        
        [capturedImageArray addObject:picture];
        [capturedTextArray addObject:captionText];
    };
    imageFindOp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error){
        
        if (error)
        {
            NSLog(@"%@", error.localizedDescription);
        }
//        [self.localImageArray addObject:capturedImageArray];
//        [self.localTextArray addObject:capturedTextArray];
        dispatch_semaphore_signal(imageSem);
    };
    
    [dataStore.database addOperation:imageFindOp];
    dispatch_semaphore_wait(imageSem, DISPATCH_TIME_FOREVER);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.localImageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZOLMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMain" forIndexPath:indexPath];
    
    cell.image.image = self.localImageArray[indexPath.row][0];
    
//IF WE WANT TO DEAL WITH WHAT TO DO WHEN ASSETS ARE NOT LOADED IN THE CELLS:
   // cell.headlineLabel.text = self.localTextArray[indexPath.row][0];
    
    // kick off the CKQuery for the first image asset for the corresponding honeymoon record
    // in the completion block for that query, set the image view to the image in the CKAsset
    //  * but... you need to make sure that the cell hasn't been reused in the meantime
    
    /*
     
     HoneymoonRecord *theHoneymoon = [... whatever ...: indexPath.row];
     cell.honeymoon = theHoneymoon;
     cell.image.image = [some placehold image];
     
     [CKQuery querySomeStuffWithCompletion:^(CKRecord *imageRecord) {
        if(cell.honeymoon != theHoneymoon) {
            // the cell got reused, and we should *not* set the image we just got on it,
            // since the cell not represents another honeymoon.
            return;
        }
     
        cell.image = [imageRecord];
     }];
     
     
     */
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end