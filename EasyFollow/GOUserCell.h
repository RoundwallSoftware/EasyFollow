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
@property(nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property(nonatomic, strong) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) IBOutlet UILabel *screennameLabel;

- (void)updateForUser:(GOTwitterUser*)user following:(BOOL)following blocked:(BOOL)blocked;
- (void)setProfileImage:(UIImage*)image;
@end
