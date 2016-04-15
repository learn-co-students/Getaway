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

@end

@implementation ZOLDetailTableViewController

- (IBAction)back:(id)sender {
    
    [self.navigationController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [ZOLDataStore dataStore];
    
    //TODO: Grab the cover image and display that on top
    //TODO: kick off heavy query to populate images (give a limit)
    
//    ZOLSimulatedFeedData *sharedDatastore = [ZOLSimulatedFeedData sharedDatastore];
//    self.localImageArray = sharedDatastore.imageArray;
//    self.localTextArray = sharedDatastore.textArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.localImageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ZOLDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    
    ZOLImage *thisImage = self.localImageArray[indexPath.row];
    
    cell.image.image = thisImage.picture;
    cell.text.text = thisImage.caption;
    
    return cell;
    
    //TODO: put default image if image isn't loaded yet
    //TODO: replace default image once image has loaded and reload cell data
}


- (IBAction)detailPullToRefresh:(UIRefreshControl *)sender {
    //TODO: kicks off heavy query with cursor and starts to get more images
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
