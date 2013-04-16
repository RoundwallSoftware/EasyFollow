//
//  GOUserCell.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 6/12/11.
//  Copyright 2011 Goodwinlabs. All rights reserved.
//

#import "GOUserCell.h"
#import "GOTwitterUser.h"

@implementation GOUserCell
@synthesize nameLabel = _nameLabel, screennameLabel = _screennameLabel, profileImageView = _profileImageView;

- (void)updateForUser:(GOTwitterUser*)user{
    self.nameLabel.text = [user realName];
    self.screennameLabel.text = [user username];
    
    self.statusLabel.attributedText = [user followingStatus];
    
    [self setProfileImage:[user image]];
}

- (void)setProfileImage:(UIImage*)image{
    self.profileImageView.image = image;
}

@end
