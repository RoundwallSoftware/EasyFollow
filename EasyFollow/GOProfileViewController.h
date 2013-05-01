//
//  GOProfileViewController.h
//  EasyFollow
//
//  Created by Samuel Goodwin on 5/1/13.
//  Copyright (c) 2013 Goodwinlabs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

@class GOTwitterUser;
@interface GOProfileViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, weak) IBOutlet UILabel *realNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *bioLabel;
@property (nonatomic, weak) IBOutlet UILabel *urlLabel;

@property (nonatomic, weak) IBOutlet UIButton *followButton;
@property (nonatomic, weak) IBOutlet UIButton *blockButton;

@property (nonatomic, strong) GOTwitterUser *user;
@property (nonatomic, strong) ACAccount *account;
@property (nonatomic, strong) NSMutableSet *followingIDs;
@property (nonatomic, strong) NSMutableSet *blockedIDs;

- (IBAction)gotoURL:(id)sender;
@end
