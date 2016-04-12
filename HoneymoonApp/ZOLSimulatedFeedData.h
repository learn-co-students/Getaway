//
//  ZOLSimulatedFeedData.h
//  HoneymoonApp
//
//  Created by Andreas Vestergaard on 05/04/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZOLSimulatedFeedData : NSObject

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *imageArray2;

@property (nonatomic, strong) NSMutableArray *imageArray3;

@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) NSMutableArray *textArray2;

@property (nonatomic, strong) NSMutableArray *mainImageArray;
@property (nonatomic, strong) NSMutableArray *mainTextArray;


+ (instancetype)sharedDatastore;

@end
