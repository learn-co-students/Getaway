//
//  HoneyMoonRecord.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/5/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "HoneyMoonRecord.h"

@implementation HoneyMoonRecord


///////////////////do we want to contain fetch in ck dataBase?
//-(void)fetchHoneyRecord:(CKDatabase *)HMDatabase{
//    
//    CKRecordID *publicRecordID = [[CKRecordID alloc]initWithRecordName:@"HoneyMoonRecord"];
//    [self.publicDatabase fetchRecordWithID: publicRecordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
//        NSLog(@"There was an error fetching the HoneyMoon public record. Error type: %@", error.localizedDescription);
//        
//        
//        
//        //         if we want to write:
//        //         [publicDatabase fetchRecordWithID:publicFeedID completionHandler:^(CKRecord *publicFeed, NSError *error) {
//        //         if (publicFeed != nil) {
//        //         NSString *name = publicFeed[@"name"];
//        //         publicFeed[@"name"] = [name stringByAppendingString:@"aNewFeedItem"];
//        //
//        //         [publicDatabase saveRecord:publicFeed completionHandler:^(CKRecord *savedPlace, NSError *savedError) {
//        //         NSLog(@"Could not edit public database");
//        //         }];
//        // 
//    }];
//};
//

@end
