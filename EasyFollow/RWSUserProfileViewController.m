//
//  UserProfile.m
//  UserProfile
//
//  Created by Martin Nguyen on 09/06/2013.
//  Copyright (c) 2013 Martin Nguyen. All rights reserved.
//

#import "RWSUserProfileViewController.h"
#import "GOTwitterUser.h"
#import "UIImageView+AFNetworking.h"

@interface RWSUserProfileViewController()
@property (nonatomic, strong) GOTwitterUser *profile;
@end

@implementation RWSUserProfileViewController

- (id)initWithProfile:(GOTwitterUser *)profile
{
    if(self = [super init]){
        self.profile = profile;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *bioString = [[self.profile tagline] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    NSString *locationString = self.profile.location;
    NSString *URLString = self.profile.urlString;
    self.bioLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", bioString, locationString, URLString];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.profile.profileImageURLString] placeholderImage:nil];
    self.usernameLabel.text = self.profile.username;
    self.nameLabel.text = self.profile.realName;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Background.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    // Workaround for rounded corners (problems with already rounded PNGs)
    self.view.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.1f].CGColor;
    self.view.layer.borderWidth = 1.0f;
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 4.0f;
    self.view.layer.masksToBounds = YES;
    
    BOOL userHasHeaderPhoto = !!self.profile.backgroundImageURLString;
    if (userHasHeaderPhoto){
        self.headerPhotoView.layer.masksToBounds = YES;
        
        [self.headerPhotoView setImageWithURL:[NSURL URLWithString:self.profile.backgroundImageURLString] placeholderImage:[UIImage imageNamed:@"ExampleHeaderPhoto.jpg"]];
        [self setupHeaderPhoto];
    }
}

- (void)setupHeaderPhoto
{    
    // Header photo inner shadow
    CAShapeLayer* shadowLayer = [CAShapeLayer layer];
    shadowLayer.frame = self.headerPhotoView.bounds;
    
    // Standard shadow stuff
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(0.0f,1.0f);
    shadowLayer.shadowOpacity = 0.8f;
    shadowLayer.shadowRadius = 5.0f;
    
    // Causes the inner region in this example to NOT be filled.
    shadowLayer.fillRule = kCAFillRuleEvenOdd;
    
    // Create the larger rectangle path.
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectInset(self.headerPhotoView.bounds, -40.0f, -40.0f));
    
    // Add the inner path so it's subtracted from the outer path.
    // innerPath could be a simple bounds rect, or maybe
    // a rounded one for some extra fanciness.
    
    // Make rect for innerPath wider than the UIImageView to avoid shaddows on the left & right
    CGRect shadowLayerRect = shadowLayer.bounds;
    shadowLayerRect.origin.x -= 10.0f;
    shadowLayerRect.size.width += 10.0f*2.0f;
    CGPathRef innerPath = [UIBezierPath bezierPathWithRect:shadowLayerRect].CGPath;
    
    CGPathAddPath(path, NULL, innerPath);
    CGPathCloseSubpath(path);
    
    shadowLayer.path = path;
    CGPathRelease(path);
    
    [self.headerPhotoView.layer addSublayer:shadowLayer];
    
    // Drop "shadow" (bottom highlight)
    CALayer *highlightLayer = [CALayer layer];
    highlightLayer.frame = CGRectMake(self.headerPhotoView.frame.origin.x,
                                       self.headerPhotoView.frame.origin.y + self.headerPhotoView.frame.size.height,
                                       self.headerPhotoView.frame.size.width, 1.0f);
    highlightLayer.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f].CGColor;
    
    [self.view.layer addSublayer:highlightLayer];
}

@end
