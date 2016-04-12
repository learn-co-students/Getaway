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

//Set up arrows to show additional content

@property (strong, nonatomic) UIImageView *rightArrow;
@property (strong, nonatomic) UIImageView *leftArrow;

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
    
    
    // Set up arrows to indicate more content
    self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow.png"]];
    self.leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeftArrow.png"]];
    
    //Set color to arrows
    self.leftArrow.image = [self.leftArrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.rightArrow.image = [self.rightArrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.leftArrow setTintColor:[UIColor whiteColor]];
    [self.rightArrow setTintColor:[UIColor whiteColor]];
    
    // Upon startup, we are furthest to the left
    self.rightArrow.hidden = NO;
    self.leftArrow.hidden = YES;

    // Add to the view controller
    [self.view addSubview:self.rightArrow];
    [self.view addSubview:self.leftArrow];

    // constrain right arrow
    self.rightArrow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightArrow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20.0].active = YES;
    [self.rightArrow.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.rightArrow.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.1].active = YES;
    self.rightArrow.contentMode = UIViewContentModeScaleAspectFit;
    self.rightArrow.clipsToBounds = YES;
    
    // constrain left arrow
    self.leftArrow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftArrow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20.0].active = YES;
    [self.leftArrow.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.leftArrow.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.1].active = YES;
    self.leftArrow.contentMode = UIViewContentModeScaleAspectFit;
    self.leftArrow.clipsToBounds = YES;
    
    // constrain aspect ratio
    UIImage *arrowImage = [UIImage imageNamed:@"LeftArrow.png"];
    CGFloat arrowAspectRatio = (arrowImage.size.width / arrowImage.size.height);
    NSLog(@"aspect ratio: %f",arrowAspectRatio);
    
    [self.rightArrow.widthAnchor constraintEqualToAnchor:self.rightArrow.heightAnchor multiplier:arrowAspectRatio].active = YES;
    
    [self.leftArrow.widthAnchor constraintEqualToAnchor:self.leftArrow.heightAnchor multiplier:arrowAspectRatio].active = YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger pagenumber = self.scrollView.contentOffset.x /
    self.scrollView.bounds.size.width;
    self.selectedImage = [self.imagesArray objectAtIndex:pagenumber];
    NSLog(@"Page number: %lu", pagenumber);
    NSLog(@"Image: %@", self.selectedImage);
    
    //Set up arrows to indicate more content
    // Are we at the far left of the scrollview?
    if (scrollView.contentOffset.x <
        scrollView.contentSize.width - scrollView.frame.size.width) {
        self.rightArrow.hidden = NO;
    } else {
        self.rightArrow.hidden = YES;
    }
    // Are we at the far right of the scrollview?
    if (scrollView.contentOffset.x > 0) {
        self.leftArrow.hidden = NO;
    }else {
        self.leftArrow.hidden = YES;
    }
    
}

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose cover photo"
                                                                             message:@"Make this the cover photo?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             [self dismissViewControllerAnimated:NO completion:nil];
                                                         }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         //Set the selected image to outside/data property here.
                                                         NSLog(@"Image: %@", self.selectedImage);
                                                         //Go to next publish option.
    [self performSegueWithIdentifier:@"ratingSegue" sender:self];
                                                     }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end




