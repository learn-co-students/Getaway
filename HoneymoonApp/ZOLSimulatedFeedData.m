//
//  ZOLSimulatedFeedData.m
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 05/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLSimulatedFeedData.h"
#import <UIKit/UIKit.h>


@implementation ZOLSimulatedFeedData

+ (instancetype)sharedDatastore {
    static ZOLSimulatedFeedData *_sharedDatastore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDatastore = [[ZOLSimulatedFeedData alloc] init];
    });
    return _sharedDatastore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageArray = [[NSMutableArray alloc] init];
        _textArray = [[NSMutableArray alloc]init];
        
    }
    //generate simulated feed
    UIImage *img1 = [UIImage imageNamed:@"img1.png"];
    UIImage *img2 = [UIImage imageNamed:@"img2.png"];
    UIImage *img3 = [UIImage imageNamed:@"img3.png"];
    UIImage *img4 = [UIImage imageNamed:@"img4.png"];

    [self.imageArray addObject:img1];
    [self.imageArray addObject:img2];
    [self.imageArray addObject:img3];
    [self.imageArray addObject:img4];
    
    NSString *str1 = @"this is picture 1.this is picture 1.this is picture 1.this is picture 1.this is picture 1";
    NSString *str2 = @"this is picture 2.this is picture 2.this is picture 2.this is picture 2.this is picture 2.";
    NSString *str3 = @"this is picture 3. this is picture 3.this is picture 3.this is picture 3.this is picture 3";
    NSString *str4 = @"this is picture 4. this is picture 4.this is picture 4.this is picture 4.this is picture 4";

    [self.textArray addObject:str1];
    [self.textArray addObject:str2];
    [self.textArray addObject:str3];
    [self.textArray addObject:str4];
    
    return self;
}




@end
