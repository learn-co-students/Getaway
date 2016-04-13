//
//  ZOLMainCell.m
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 05/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLMainCell.h"

@implementation ZOLMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(45, 300, 300, 60)];
    self.starRatingView.maximumValue = 5;
    self.starRatingView.minimumValue = 0;
//    self.starRatingView.value = 0;
    self.starRatingView.allowsHalfStars = YES;
    self.starRatingView.backgroundColor = [UIColor clearColor];
    self.starRatingView.tintColor = [UIColor whiteColor];
    self.starRatingView.userInteractionEnabled = NO;
}

-(void)drawStarRating
{
    self.starRatingView.value = self.cellRating;
    [self.contentView addSubview:self.starRatingView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
