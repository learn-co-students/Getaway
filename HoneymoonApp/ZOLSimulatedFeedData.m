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
        _textArray2 =[[NSMutableArray alloc]init];
        _imageArray2 = [[NSMutableArray alloc]init];
        
        _imageArray3 = [NSMutableArray new];

        _mainTextArray =[[NSMutableArray alloc]init];
        _mainImageArray = [[NSMutableArray alloc]init];
        
    }
    //generate simulated array 1
    UIImage *img1 = [UIImage imageNamed:@"img1.png"];
    UIImage *img2 = [UIImage imageNamed:@"img2.png"];
    UIImage *img3 = [UIImage imageNamed:@"img3.png"];
    UIImage *img4 = [UIImage imageNamed:@"img4.png"];

    [self.imageArray addObject:img1];
    [self.imageArray addObject:img2];
    [self.imageArray addObject:img3];
    [self.imageArray addObject:img4];
    
    NSString *str1 = @"HEADLINE TEXT 1";
    NSString *str2 = @"this is picture 2.this is picture 2.this is picture 2.this is picture 2.this is picture 2.";
    NSString *str3 = @"this is picture 3. this is picture 3.this is picture 3.this is picture 3.this is picture 3";
    NSString *str4 = @"this is picture 4. this is picture 4.this is picture 4.this is picture 4.this is picture 4";

    [self.textArray addObject:str1];
    [self.textArray addObject:str2];
    [self.textArray addObject:str3];
    [self.textArray addObject:str4];
    
    //generate simulated array 2

    
    UIImage *A2img1 = [UIImage imageNamed:@"A2 img1.png"];
    UIImage *A2img2 = [UIImage imageNamed:@"A2 img2.png"];
    UIImage *A2img3 = [UIImage imageNamed:@"A2 img3.png"];
    UIImage *A2img4 = [UIImage imageNamed:@"A2 img4.png"];
    
    [self.imageArray2 addObject:A2img1];
    [self.imageArray2 addObject:A2img2];
    [self.imageArray2 addObject:A2img3];
    [self.imageArray2 addObject:A2img4];
    
    NSString *A2str1 = @"HEADLINE TEXT 2";
    NSString *A2str2 = @"this is picture 2.this is picture 2.this is picture 2.this is picture 2.this is picture 2.";
    NSString *A2str3 = @"this is picture 3. this is picture 3.this is picture 3.this is picture 3.this is picture 3";
    NSString *A2str4 = @"this is picture 4. this is picture 4.this is picture 4.this is picture 4.this is picture 4";
    
    [self.textArray2 addObject:A2str1];
    [self.textArray2 addObject:A2str2];
    [self.textArray2 addObject:A2str3];
    [self.textArray2 addObject:A2str4];
    
   //generate main array
    
    
    [self.mainImageArray addObject:self.imageArray];
    [self.mainImageArray addObject:self.imageArray2];
   // [self.mainImageArray addObject:self.imageArray3];
    
    [self.mainTextArray addObject:self.textArray];
    [self.mainTextArray addObject:self.textArray2];

   
   // NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];

    
    return self;
}




@end
