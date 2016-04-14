//
//  ZOLMainCell.h
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 05/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface ZOLMainCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *headlineLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, assign) CGFloat cellRating;
@property (nonatomic, strong) HCSStarRatingView *starRatingView;

-(void)drawStarRating;

@end
