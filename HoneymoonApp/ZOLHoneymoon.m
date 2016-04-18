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
//        _honeymoonID = [[CKRecordID alloc]initWithRecordName:@"Honeymoon"];
        _honeymoonImages = [[NSMutableArray alloc]init];
        _client = [[ZOLCloudKitClient alloc]init];
        _coverPicture = [[UIImage alloc]init];
        
        _published = @"NO";
    }
    
//    [self populateHoneymoonImages];
    
    return self;
}

//Fetch all the images associated with a user's honeymoon from CloudKit, make them into ZOLImage objects and add them to the ZOLHoneymoon for this user
-(void)populateHoneymoonImages
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
            NSLog(@"Error in populateHoneymoonImages - description: %@, and code: %lu, and heck, heres the domain: %@", operationError.localizedDescription, operationError.code, operationError.domain);
        }
    };
    
    findHMOp.recordFetchedBlock = ^(CKRecord *record){
        ZOLImage *imageToAdd = [[ZOLImage alloc]init];
        
//        CKAsset *image = record[@"Picture"];
//        UIImage *pictureToAdd = [self.client retrieveUIImageFromAsset:image];
        NSString *captionText = record[@"Caption"];
        
//        imageToAdd.picture = pictureToAdd;
        imageToAdd.caption = captionText;
        imageToAdd.imageRecordID = record.recordID;
        
        [self.honeymoonImages addObject:imageToAdd];
    };
    
    [[[CKContainer defaultContainer] publicCloudDatabase] addOperation:findHMOp];
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
