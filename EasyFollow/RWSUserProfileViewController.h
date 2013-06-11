//
//  UserProfile.h
//  UserProfile
//
//  Created by Martin Nguyen on 09/06/2013.
//  Copyright (c) 2013 Martin Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class GOTwitterUser;
@interface RWSUserProfileViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *headerPhotoView;
@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet UILabel *bioLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;

- (id)initWithProfile:(GOTwitterUser *)profile;
@end
