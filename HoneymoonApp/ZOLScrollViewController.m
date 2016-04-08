//
//  ScrollViewController.m
//  ScrollViewTester
//
//  Created by Jennifer A Sipila on 4/6/16.
//  Copyright © 2016 Jennifer A Sipila. All rights reserved.
//

#import "ZOLScrollViewController.h"

@interface ZOLScrollViewController () <UIScrollViewDelegate>

@property(strong, nonatomic) NSMutableArray *imagesArray;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIStackView *stackViewOutlet;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation ZOLScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.imagesArray = [[NSMutableArray alloc]initWithArray:@[[UIImage imageNamed:@"image1.jpg"],[UIImage imageNamed:@"image2.jpg"], [UIImage imageNamed:@"image3.jpg"]]];
    
    for (UIImage *image in self.imagesArray)
    {
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(handleTap:)];

        [view addGestureRecognizer:viewTap];
       
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        
        [self.stackViewOutlet addArrangedSubview:view];
        
    }
    
    self.stackViewOutlet.axis = UILayoutConstraintAxisHorizontal;
    self.stackViewOutlet.distribution = UIStackViewDistributionFillEqually;
    self.stackViewOutlet.alignment = UIStackViewAlignmentFill;
    self.stackViewOutlet.spacing = 0;
    
    self.widthConstraint.constant = self.view.frame.size.width * 3;
    self.scrollView.contentSize = CGSizeMake(self.widthConstraint.constant, self.view.frame.size.height);
    NSLog(@"%lf", self.widthConstraint.constant);

   self.scrollView.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger pagenumber = self.scrollView.contentOffset.x /
    self.scrollView.bounds.size.width;
    
    self.selectedImage = [self.imagesArray objectAtIndex:pagenumber];
    
    NSLog(@"Page number: %lu", pagenumber);
    NSLog(@"Image: %@", self.selectedImage);
    
}

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose cover photo"
                                                                             message:@"Make this the cover photo?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         //Set the selected image to outside/data property here.
                                                         NSLog(@"Image: %@", self.selectedImage);
                                                         
                                                         //Go to next publish option.
                                                         
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FeedStoryboard" bundle:nil];
                                                         
    UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"navController"];
                                                         
    [self presentViewController:navController animated:NO completion:nil];
                                                     }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [self dismissViewControllerAnimated:NO completion:nil];
                                                     }];
    
    [alertController addAction:okAction];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end




