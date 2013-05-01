//
//  GOProfileViewController.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 5/1/13.
//  Copyright (c) 2013 Goodwinlabs LLC. All rights reserved.
//

#import "GOProfileViewController.h"
#import "UIImage+TreatedImage.h"
#import "GOTwitterUser.h"
#import "UIImageView+AFNetworking.h"

@interface GOProfileViewController ()

@end

@implementation GOProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(CGRectGetHeight([[UIScreen mainScreen] bounds]) > 480.0f){
        self.backgroundImageView.image = [UIImage imageNamed:@"MainBackground-568h"];
        NSParameterAssert(self.backgroundImageView.image);
    }
    
    self.profileImageView.image = [[self.user image] treatedImage];
    
    self.usernameLabel.text = [self.user username];
    self.realNameLabel.text = [self.user realName];
    self.locationLabel.text = [self.user location];
    self.bioLabel.text = [self.user tagline];
    
    self.urlLabel.text = [self.user urlString];
    
    if([self isBlocked:self.user]){
        self.blockButton.titleLabel.text = NSLocalizedString(@"Unblock", @"Unblock button title");
    }else{
        self.blockButton.titleLabel.text = NSLocalizedString(@"Block", @"Block button title");
    }
    
    if([self isFollowing:self.user]){
        self.followButton.titleLabel.text = NSLocalizedString(@"Unfollow", @"Unfollow button title");
    }else{
        self.followButton.titleLabel.text = NSLocalizedString(@"Follow", @"Follow button title");
    }
}

- (IBAction)gotoURL:(id)sender
{
    if(self.user.urlString){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.user urlString]]];
    }
}

- (BOOL)isBlocked:(GOTwitterUser *)user
{
    return [self.blockedIDs containsObject:[user userID]];
}

- (BOOL)isFollowing:(GOTwitterUser *)user
{
    return [self.followingIDs containsObject:[user userID]];
}

@end
