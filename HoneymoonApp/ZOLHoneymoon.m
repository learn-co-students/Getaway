//
//  ZOLHoneymoon.m
//  HoneymoonApp
//
//  Created by Samuel Boyce on 4/8/16.
//  Copyright © 2016 Team Yam. All rights reserved.
//

#import "ZOLHoneymoon.h"
#import "ZOLDataStore.h"

@implementation ZOLHoneymoon

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _honeymoonImages = [[NSMutableArray alloc]init];
        _client = [[ZOLCloudKitClient alloc]init];
        _coverPicture = [[UIImage alloc]init];
        _userName = [[NSString alloc]init];
        _published = @"NO";
    }
    
    return self;
}

//Fetch all the images associated with a honeymoon from CloudKit, make them into ZOLImage objects and add them to this ZOLHoneymoon
-(void)populateHoneymoonImages
{
    if (self.honeymoonID)
    {
        CKReference *referenceToHoneymoon = [[CKReference alloc]initWithRecordID:self.honeymoonID action:CKReferenceActionDeleteSelf];
        NSPredicate *honeymoonSearch = [NSPredicate predicateWithFormat:@"%K == %@", @"Honeymoon", referenceToHoneymoon];
        CKQuery *findImages = [[CKQuery alloc]initWithRecordType:@"Image" predicate:honeymoonSearch];
        CKQueryOperation *findHMOp = [[CKQueryOperation alloc]initWithQuery:findImages];
        NSArray *captionKey = @[@"Caption", @"Honeymoon"];
        findHMOp.desiredKeys = captionKey;
        
        findHMOp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *operationError) {
            NSLog(@"honeymoon images populated");
            if (operationError)
            {
                NSLog(@"Error in populateHoneymoonImages - description: %@, code: %lu, domain: %@", operationError.localizedDescription, operationError.code, operationError.domain);
                NSTimer *retryTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(populateHoneymoonImages) userInfo:nil repeats:NO];
                NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];
                [currentLoop addTimer:retryTimer forMode:NSDefaultRunLoopMode];
                [currentLoop run];
//                [retryTimer fire];
            }
        };
        
        findHMOp.recordFetchedBlock = ^(CKRecord *record){
            ZOLImage *imageToAdd = [[ZOLImage alloc]init];
            NSString *captionText = record[@"Caption"];

            imageToAdd.caption = captionText;
            imageToAdd.imageRecordID = record.recordID;
            
            [self.honeymoonImages addObject:imageToAdd];
        };
        
        [[[CKContainer defaultContainer] publicCloudDatabase] addOperation:findHMOp];
    }
}

//Take the data gathered from the user and save their updated honeymoon to CloudKit
-(void)publishHoneymoon
{
    CKRecord *honeymoonRecord = [self.client fetchRecordWithRecordID:self.honeymoonID];
    
    UIImage *coverPhoto;
    NSURL *coverPhotoURL = [self.client writeImage:coverPhoto toTemporaryDirectoryWithQuality:0];
    CKAsset *coverPicture = [[CKAsset alloc]initWithFileURL:coverPhotoURL];
    
    honeymoonRecord[@"CoverPicture"] = coverPicture;
    honeymoonRecord[@"Rating"] = @(self.rating);
    honeymoonRecord[@"Description"] = self.honeymoonDescription;
    
    [self.client saveRecord:honeymoonRecord toDataBase:self.client.database];
}

@end
