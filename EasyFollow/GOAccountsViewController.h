//
//  GOAccountsControllerViewController.h
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>

extern NSString *const GOAccountsDidChangeNotification;

@interface GOAccountsViewController : UIViewController{
    ACAccountStore *_store;
    NSArray *_accounts;
}

@property (nonatomic, retain) IBOutlet UILabel *accountNameLabel;

- (IBAction)nextAccount:(id)sender;

- (ACAccount*)currentAccount;
- (void)updateAccountIndicator;
@end
