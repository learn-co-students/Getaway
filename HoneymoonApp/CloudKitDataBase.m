//
//  CloudKitDataBase.m
//  HoneymoonApp
//
//  Created by Alicia Marisal on 4/4/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "CloudKitDataBase.h"
#import "CKViewController.h"

@interface CloudKitDataBase()


@end

@implementation CloudKitDataBase


+ (instancetype)sharedData {
    static CloudKitDataBase *_sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedData = [[CloudKitDataBase alloc]init];
    });
    return _sharedData;
}


-(instancetype)init{

    self = [super init];
    if (self) {
        _zolContainer = [CKContainer defaultContainer];
        _privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
        _publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    }
    return self;
}


-(void)fetchRecordID:(CKRecordID *)recordID getTheRecord: (CKRecord *)record{
    CKRecordID *publicRecordID = [[CKRecordID alloc]initWithRecordName:@""];
    
    [self.publicDatabase fetchRecordWithID: publicRecordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        NSLog(@"There was an error fetching the HoneyMoon public record. Error type: %@", error.localizedDescription);
        
        if (error == nil) {
            NSMutableArray *fetchResults = [[NSMutableArray alloc]init];
            [fetchResults addObject: record];
        }
          }];
  
};

//OR
/*      NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
 CKQuery *query =[[CKQuery alloc]initWithRecordType: publicRecord predicate:predicate];
 [self.publicDatabase preformQuery: query inZoneWithID: self.publicZone.inZoneWithID
 completionHandler: ^(NSArray *results, NSError *error){
 
 LOG_ERROR(@"fetching records");
 
 if (results) {
 NSMutableArray *queryArray = [[NSMutableArray alloc]init];
 
 for(CKRecord *ARecord in results){
 //blah blah
 }
 }
 }
 
 ]
 
 */


// if we want to write a file:
-(void)writeARecord:(CKDatabase *)publicDatabase{

    CKRecordID *publicRecordID = [[CKRecordID alloc]initWithRecordName:@""];
    [self.publicDatabase fetchRecordWithID:publicRecordID completionHandler:^(CKRecord *publicRecord, NSError *error) {
         if (publicRecord != nil) {
         NSString *name = publicRecord[@"ARecord"];
         publicRecord[@"name"] = [name stringByAppendingString:@"aNewRecordItem"];

         [publicDatabase saveRecord:publicRecord completionHandler:^(CKRecord *savedPlace, NSError *savedError) {
         NSLog(@"Could not edit public database");
         }];


}
    }];
}



-(void)savePublicRecord:(CKDatabase *)publicDatabase record:(CKRecord *)record{
    
    
   [self.publicDatabase saveRecord: record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                      
        NSLog(@"The public record data could not be saved. Error type: %@", error.localizedDescription);
                      
            if (CKErrorNetworkUnavailable) {
            NSLog(@"The public data could not be saved due to a bad network connection");
            double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
            NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
                          
            }
                      
            if (CKErrorNetworkFailure) {
            NSLog(@"The public data could not be saved because of a Network Failure");
            double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
            NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
                          
            }
       if (error == nil) {
           NSLog(@"We saved some data! What did we save you ask? This thing:%@", record.description);
       }
       
    }];


    }

//we may not want to implement private data (maybe save userName for next login?? and email?)
//saving private feed-->after iCloud signin is verified :p
-(void)savePrivateRecord:(CKDatabase *)privateDatabase record:(CKRecord *)record{

    CKRecord *privateRecord = [[CKRecord alloc]initWithRecordType:@"privateRecord"];
    [self.privateDatabase saveRecord:privateRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        NSLog(@"The private record data could not be saved. Error type : %@", error.localizedDescription);
        
        if (CKErrorNetworkUnavailable) {
            NSLog(@"The private data could not be saved due to a bad network connection");
            double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
            NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
            
        }
        
        if (CKErrorNetworkFailure) {
            NSLog(@"The private data could not be saved because of a Network Failure");
            double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
            NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
            
        }

    }];

}


//grab an image from CloudKit
-(void)fetchCKAsset{
    
    CKQuery *imageQuery = [[CKQuery alloc]initWithRecordType:@"Image" predicate: [NSPredicate predicateWithFormat:@"Caption = %@", @"fakeImage"]];
    
    [self.publicDatabase performQuery:imageQuery inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        
        if (error){
            NSLog(@"ERROR for querying the public DB. Error type: %@", error.localizedDescription);
        }
        
        NSArray *newImageArray = [[NSArray alloc]init];
        [newImageArray arrayByAddingObject:results];
        
        
        CKRecord *firstImage = newImageArray[0];
        CKAsset *imageOne = firstImage[@"Picture"];
        
        NSData *data = [NSData dataWithContentsOfURL:imageOne.fileURL];
        UIImage *anActulPicture =[UIImage imageWithData:data];
        //self.testImage.image = anActulPicture;
        
    }];
    
}

          
     
@end
