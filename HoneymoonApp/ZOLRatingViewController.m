//
//  ZOLRatingViewController.m
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 06/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLRatingViewController.h"

@interface ZOLRatingViewController ()
@property (nonatomic) CGFloat rating;
@property (strong, nonatomic) IBOutlet UIView *subview;

@end

@implementation ZOLRatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [ZOLDataStore dataStore];
    
    //initialize star-rating view
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(45, 300, 300, 60)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.allowsHalfStars = YES;
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.tintColor = [UIColor whiteColor];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.subview addSubview:starRatingView];
    
}

- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    self.rating = sender.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.dataStore.user.userHoneymoon.rating = self.rating;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
