//
//  ScrollViewController.m
//  ScrollViewTester
//
//  Created by Jennifer A Sipila on 4/6/16.
//  Copyright © 2016 Jennifer A Sipila. All rights reserved.
//

#import "ZOLScrollViewController.h"
#import "ZOLRatingViewController.h"

@interface ZOLScrollViewController () <UIScrollViewDelegate>

@property(strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewOutlet;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (strong, nonatomic) UIImage *selectedImage;

//Set up arrows to show additional content
@property (strong, nonatomic) UIButton *rightArrow;
@property (strong, nonatomic) UIButton *leftArrow;

@property (nonatomic)BOOL scrollButtonTapped;

@end

@implementation ZOLScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imagesArray = [[NSMutableArray alloc]init];
    self.dataStore = [ZOLDataStore dataStore];
    
    for (ZOLImage *zolImage in self.dataStore.user.userHoneymoon.honeymoonImages)
    {
        UIImage *imageToAdd = zolImage.picture;
        [self.imagesArray addObject:imageToAdd];
    }
    
    self.selectedImage = self.imagesArray[0];
    
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
    
    self.widthConstraint.constant = self.view.frame.size.width * self.imagesArray.count;
    self.scrollView.contentSize = CGSizeMake(self.widthConstraint.constant, self.view.frame.size.height);
    NSLog(@"%lf", self.widthConstraint.constant);

   self.scrollView.delegate = self;
    
    // Set up arrows to indicate more content
    self.rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //Set images to buttons & rendering mode to template.
    UIImage *rightArrowButtonImage = [[UIImage imageNamed:@"RightArrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *leftArrowButtonImage = [[UIImage imageNamed:@"LeftArrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.rightArrow setImage:rightArrowButtonImage forState:UIControlStateNormal];
    [self.leftArrow setImage:leftArrowButtonImage forState:UIControlStateNormal];
    
    //Set color to arrows
    [self.leftArrow setTintColor:[UIColor whiteColor]];
    [self.rightArrow setTintColor:[UIColor whiteColor]];
    
    // Upon startup, we are furthest to the left
    self.rightArrow.hidden = NO;
    self.leftArrow.hidden = YES;

    // Add to the view controller
    [self.view addSubview:self.rightArrow];
    [self.view addSubview:self.leftArrow];

    // Constrain right arrow
    self.rightArrow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightArrow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10.0].active = YES;
    [self.rightArrow.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.rightArrow.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.2].active = YES;
    self.rightArrow.contentMode = UIViewContentModeScaleAspectFit;
    self.rightArrow.clipsToBounds = YES;
    
    // Constrain left arrow
    self.leftArrow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftArrow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10.0].active = YES;
    [self.leftArrow.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.leftArrow.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.2].active = YES;
    self.leftArrow.contentMode = UIViewContentModeScaleAspectFit;
    self.leftArrow.clipsToBounds = YES;
    
    // Constrain aspect ratio
    UIImage *arrowImage = [UIImage imageNamed:@"LeftArrow.png"];
    CGFloat arrowAspectRatio = (arrowImage.size.width / arrowImage.size.height);
    NSLog(@"aspect ratio: %f",arrowAspectRatio);
    
    [self.rightArrow.widthAnchor constraintEqualToAnchor:self.rightArrow.heightAnchor multiplier:arrowAspectRatio].active = YES;
    
    [self.leftArrow.widthAnchor constraintEqualToAnchor:self.leftArrow.heightAnchor multiplier:arrowAspectRatio].active = YES;
    
    CGFloat verticalInset = self.view.frame.size.height / 14;
    CGFloat horizontalInset = verticalInset * arrowAspectRatio;
    UIEdgeInsets arrowInsets = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
    
    self.rightArrow.imageEdgeInsets = arrowInsets;
    self.leftArrow.imageEdgeInsets = arrowInsets;
    
    //Add IBActions programmatically for the buttons
    [self.rightArrow addTarget:self action:@selector(rightArrowButtonTappedWithselector:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.leftArrow addTarget:self action:@selector(leftArrowButtonTappedWithselector:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)rightArrowButtonTappedWithselector:(id)sender
{
    if(self.scrollView.contentOffset.x < (self.scrollView.contentSize.width - self.scrollView.frame.size.width))
    {
        self.scrollButtonTapped = YES;
        
        //Calculate the offset distance for the right button to scroll when tapped
        NSUInteger pageNumber = (self.scrollView.contentOffset.x /
                                 self.scrollView.bounds.size.width) + 1;

        CGPoint scrollDistance = CGPointMake(self.scrollView.bounds.size.width * pageNumber, 0);
        
        [self.scrollView setContentOffset:scrollDistance animated:YES];
    }
}

-(IBAction)leftArrowButtonTappedWithselector:(id)sender
{
    //As long as the offset is greater than the screen size allow for scrolling.
    if(self.scrollView.contentOffset.x >= self.scrollView.frame.size.width)
    {
            self.scrollButtonTapped = YES;
        
        NSUInteger pageNumber = (self.scrollView.contentOffset.x /
        self.scrollView.bounds.size.width) + 1;

        CGPoint scrollDistance = CGPointMake(self.scrollView.bounds.size.width * (pageNumber - 2), 0);
     
        [self.scrollView setContentOffset:scrollDistance animated:YES];
    }
    
    CGFloat totalWidth = self.scrollView.contentSize.width;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat screenWidth = self.scrollView.frame.size.width;

    NSLog(@"totalWidth:%f",totalWidth);
    NSLog(@"offSetX:%f",offsetX);
    NSLog(@"screenWidth:%f",screenWidth);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        NSUInteger pageNumber = self.scrollView.contentOffset.x /
        self.scrollView.bounds.size.width;
        self.selectedImage = [self.imagesArray objectAtIndex:pageNumber];
        NSLog(@"Page number: %lu", pageNumber);
        NSLog(@"Image: %@", self.selectedImage);
        
        //Set up arrows to indicate more content
        CGFloat totalWidth = self.scrollView.contentSize.width;
        CGFloat offsetX = self.scrollView.contentOffset.x;
        CGFloat screenWidth = self.scrollView.frame.size.width;
        //Is scroll at far right? Hide the right arrow.
        if (offsetX >= (totalWidth - screenWidth))
        {
            self.rightArrow.hidden = YES;
            self.leftArrow.hidden = NO;
        } else if (offsetX < screenWidth)
        {
            self.rightArrow.hidden = NO;
            self.leftArrow.hidden = YES;
        } else {
            
            self.rightArrow.hidden = NO;
            self.leftArrow.hidden = NO;
        }

        NSLog(@"totalWidth:%f",totalWidth);
        NSLog(@"offSetX:%f",offsetX);
        NSLog(@"screenWidth:%f",screenWidth);
}

- (void)handleTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose cover photo"
                                                                             message:@"Make this the cover photo?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         //Set the selected image to outside/data property here.
                                                         NSLog(@"Image: %@", self.selectedImage);
                                                         //Go to next publish option.
                                                         self.dataStore.user.userHoneymoon.coverPicture = self.selectedImage;
                                                         
    [self performSegueWithIdentifier:@"ratingSegue" sender:self];
                                                     }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ratingSegue"]) {
        ZOLRatingViewController *ratingViewController = segue.destinationViewController;
        ratingViewController.coverImage = self.selectedImage;
    }
}

@end




