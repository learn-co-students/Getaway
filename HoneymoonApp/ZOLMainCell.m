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
    self.starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
    self.starRatingView.maximumValue = 5;
    self.starRatingView.minimumValue = 0;
    self.starRatingView.allowsHalfStars = YES;
    self.starRatingView.backgroundColor = [UIColor clearColor];
    self.starRatingView.tintColor = [UIColor whiteColor];
    self.starRatingView.userInteractionEnabled = NO;
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.heightConstraint.constant = -0.5f;
    self.starRatingView.translatesAutoresizingMaskIntoConstraints = false;
    [self.starRatingView.centerXAnchor constraintEqualToAnchor: self.contentView.centerXAnchor].active = YES;
    [self.starRatingView.topAnchor constraintEqualToAnchor: self.contentView.topAnchor constant:290].active = YES;
    [self.starRatingView.heightAnchor constraintEqualToConstant:30].active = YES;
    [self.starRatingView.widthAnchor constraintEqualToConstant:100].active = YES;
    
    self.headlineLabel.adjustsFontSizeToFitWidth = YES;

    
    

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
