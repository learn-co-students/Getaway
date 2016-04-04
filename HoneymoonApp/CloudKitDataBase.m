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


/*+(void)savePrivateRecord:(CKDatabase *)database record:(CKRecord *)record {
    
    
    
}
*/

/*+(void)savePublicFeed:(NSString *)feedName{
    
//    [publicDatabase saveRecord:publicFeed
//             completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
//                 NSLog(@"The public record data could not be saved. Error type : %@", error);
//                 
//                 if (CKErrorNetworkUnavailable) {
//                     NSLog(@"The public data could not be saved due to a bad network connection");
//                     double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
//                     NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
//                     
//                 }
//                 
//                 if (CKErrorNetworkFailure) {
//                     NSLog(@"The public data could not be saved because of a Network Failure");
//                     double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
//                     NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
//                     
//                 }
//                 
//                 
//             }];
//   
    
    //    publicFeed = [@"User Name"] = @"SillyManilly";
    //    publicFeed = [@"InputOne"] = @"I like the VigiGames";
    
    
}
 */

//saving private feed-->after iCloud signin is verified :p
/*+(void)saveAPrivateFeed: (CKRecord *)newPrivateFeed{
    
    [privateDatabase saveRecord:privateFeed completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        NSLog(@"The private record data could not be saved. Error type : %@", error);
        
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
*/



/*+(void)fetchRecord:(CKDatabase *)database{
    
    [publicDatabase fetchRecordWithID:publicFeedID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        NSLog(@"There was an error fetching the publicFeed. Error type: %@", error);
        
        
        
         if we want to write:
         [publicDatabase fetchRecordWithID:publicFeedID completionHandler:^(CKRecord *publicFeed, NSError *error) {
         if (publicFeed != nil) {
         NSString *name = publicFeed[@"name"];
         publicFeed[@"name"] = [name stringByAppendingString:@"aNewFeedItem"];
         
         [publicDatabase saveRecord:publicFeed completionHandler:^(CKRecord *savedPlace, NSError *savedError) {
         NSLog(@"Could not edit public database");
         }];
 
    }];
}
*/

//IF MORE THAN ONE FETCH BEGINS TO OCCUR OUT OF ORDER, YOU CAN IMPLEMENT THE FOLLOWING CODE TO KEEP THINGS IN LINE ^_^
/*    CKFetchRecordsOperation *firstFetch = ...;
 CKFetchRecordsOperation *secondFetch = ...;
 
 [secondFetch addDependency:firstFetch];
 
 NSOperationQueue *queue = [[NSOperationQueue alloc] init];
 [queue addOperations:[firstFetch, secondFetch] waitUntilFinished: NO];
 */

    

#pragma searchTextFieldGoesHere!!
#pragma is the recordType @"" ok here?
////Let's make query capabilities!
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS '%@'", searchField.text];
//    CKQuery *query = [CKQuery alloc] initWithRecordType:@"publicFeed" predicate:predicate;
//
//    [publicDatabase performQuery:query
//                    inZoneWithID:nil
//               completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
//                   NSLog(@"Problem obtaining your query :( ");
//                   NSLog(@"Error type: %@", error);
//               }];
//


    



@end
