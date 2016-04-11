//
//  ZOLHoneymoon.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/8/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLHoneymoon.h"

@implementation ZOLHoneymoon

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _honeymoonID = [[CKRecordID alloc]initWithRecordName:@"Honeymoon"];
        _honeymoonImages = [[NSMutableArray alloc]init];
    }
    
    return self;
}

@end
