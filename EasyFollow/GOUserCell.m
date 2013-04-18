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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.backgroundView = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"UITableViewCellBackground"]];
    }
    return self;
}

- (void)updateForUser:(GOTwitterUser*)user following:(BOOL)following blocked:(BOOL)blocked{    
    self.nameLabel.text = [user realName];
    self.screennameLabel.text = [user username];
    
    [self setProfileImage:[user image]];
    
    if(blocked){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlockedIndicator"]];
        self.accessoryView = imageView;
    }else{
        if(following){
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FollowingIndicator"]];
            self.accessoryView = imageView;
        }else{
            self.accessoryView = nil;
        }
    }
}

- (void)setProfileImage:(UIImage*)image{
    self.profileImageView.image = image;
}

@end
