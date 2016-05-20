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
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation ZOLRatingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStore = [ZOLDataStore dataStore];
    
    //Set height, width, and x/y positions for the star rating view
    CGFloat starRatingXPostion = (self.view.frame.size.width/10);
    CGFloat starRatingYPostion = (self.view.frame.size.height/3);
    CGFloat starRatingWidth = (self.view.frame.size.width * 0.8);
    CGFloat starRatingHeight = (self.view.frame.size.width/8);
    
    //initialize star-rating view
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(starRatingXPostion, starRatingYPostion, starRatingWidth, starRatingHeight)];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.allowsHalfStars = YES;
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.tintColor = [UIColor whiteColor];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    //Set the rating stars to the front
    [self.view bringSubviewToFront:self.subview];
    [self.subview addSubview:starRatingView];
    
    //Set the background image to the chosen cover image.
    self.backgroundImage.image = self.coverImage;
    
    self.dataStore.user.userHoneymoon.coverPicture = self.coverImage;
}

- (IBAction)didChangeValue:(HCSStarRatingView *)sender
{
    self.rating = sender.value;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.dataStore.user.userHoneymoon.rating = self.rating;
}


@end
