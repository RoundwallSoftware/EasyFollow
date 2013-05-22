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
#import "MBProgressHUD.h"

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
    
    [self updateBlockButtonTitle];
    
    [self updateFollowButtonTitle];
}

#pragma mark - Helpers

- (void)updateFollowButtonTitle
{
    if([self isFollowing:self.user]){
        [self.followButton setTitle:NSLocalizedString(@"Unfollow", @"Unfollow button title") forState:UIControlStateNormal];
    }else{
        [self.followButton setTitle:NSLocalizedString(@"Follow", @"Follow button title") forState:UIControlStateNormal];
    }
}

- (void)updateBlockButtonTitle
{
    if([self isBlocked:self.user]){
        [self.blockButton setTitle:NSLocalizedString(@"Unblock", @"Unblock button title") forState:UIControlStateNormal];
    }else{
        [self.blockButton setTitle:NSLocalizedString(@"Block", @"Block button title") forState:UIControlStateNormal];
    }
}

#pragma mark - Actions

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

- (IBAction)blockToggle:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self.view superview] animated:YES];
    
    GOCompletionBlock block = ^(void){
        [self updateBlockButtonTitle];
        [hud hide:YES];
    };

    
    GOTwitterUser *user = self.user;
    
    if([self isBlocked:user]){
        [self.blockedIDs removeObject:[user userID]];
        [user unblockFromAccount:self.account completion:block];
    }else{
        [self.blockedIDs addObject:[user userID]];
        [self.followingIDs removeObject:[user userID]];
        [user blockFromAccount:self.account completion:block];
    }
}

- (IBAction)followToggle:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self.view superview] animated:YES];
    
    GOCompletionBlock block = ^(void){
        [self updateFollowButtonTitle];
        [hud hide:YES];
    };
    
    GOTwitterUser *user = self.user;
    
    if([self isFollowing:user]){
        [self.followingIDs removeObject:[user userID]];
        [user unfollowFromAccount:self.account completion:block];
    }else{
        [self.followingIDs addObject:[user userID]];
        [user followFromAccount:self.account completion:block];
    }
}

@end
