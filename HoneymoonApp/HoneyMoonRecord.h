//
//  HoneyMoonRecord.h
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/5/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import "CloudKitDataBase.h"

@interface HoneyMoonRecord : CKRecord

@property (strong, nonatomic) CloudKitDataBase *datastore;


-(void)fetchHoneyRecord:(CKDatabase *)HMDatabase;


@end
