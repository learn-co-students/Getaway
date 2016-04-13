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



//{
//    // instantiation of beta background (mainCell) processor with needed processing class types.
//    NSOperationQueue *_queue;
//    NSString *_group;
//    ZOLDetailCell *localImageArray;
//    ZOLDetailCell *localTextArray;
//    
//}


////instantiation of dequeue control objects
//-(id)initWithGroup: (NSString *) group{
//    
//    self = [super init];
//    if (self) {
//        _group = group;
//        [self setTitle:group];  //not sure what this quite does...
//        // [[self tableView] setRowHeight:245]   // here we can set a specific height for all cells
//        
//        _queue = [[NSOperationQueue alloc]init];
//        
//    }
//    return self;
//    
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    cell.image.image = self.localImageArray[indexPath.row];
    cell.text.text = self.localTextArray[indexPath.row];
    
    return cell;
}


- (IBAction)detailPullToRefresh:(UIRefreshControl *)sender {
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
