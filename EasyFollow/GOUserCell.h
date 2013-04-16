//
//  GOUserCell.h
//  EasyFollow
//
//  Created by Samuel Goodwin on 6/12/11.
//  Copyright 2011 Goodwinlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GOTwitterUser;

@interface GOUserCell : UITableViewCell
@property(nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property(nonatomic, retain) IBOutlet UILabel *nameLabel;
@property(nonatomic, retain) IBOutlet UILabel *screennameLabel;
@property(nonatomic, retain) IBOutlet UILabel *statusLabel;

- (void)updateForUser:(GOTwitterUser*)user;
- (void)setProfileImage:(UIImage*)image;
@end
