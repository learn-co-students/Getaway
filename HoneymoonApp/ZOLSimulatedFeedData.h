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
@property (nonatomic, strong) NSMutableArray *textArray;


+ (instancetype)sharedDatastore;

@end
