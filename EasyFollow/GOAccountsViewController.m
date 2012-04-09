//
//  GOAccountsControllerViewController.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import "GOAccountsViewController.h"

NSString *const GOAccountsDidChangeNotification = @"omgtheaccountchanged!";
NSString *const kDefaultAccountIdentifierKey = @"omgcurrentAccountIdentifier";

@implementation GOAccountsViewController

- (void)awakeFromNib{
    [super awakeFromNib];
    _store = [[ACAccountStore alloc] init];
    ACAccountType *type = [_store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    _accounts = [_store accountsWithAccountType:type];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.accountNameLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (ACAccount*)currentAccount{
    NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultAccountIdentifierKey];
    if(identifier){
        return [_store accountWithIdentifier:identifier];
    }
    
    ACAccount *account = [_accounts objectAtIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:[account identifier] forKey:kDefaultAccountIdentifierKey];
    return account;
}

- (void)updateAccountIndicator{
    ACAccount *currentAccount = [self currentAccount];
    self.accountNameLabel.text = [currentAccount username];
}

- (IBAction)nextAccount:(id)sender{
    ACAccount *currentAccount = [self currentAccount];
    NSUInteger index = [_accounts indexOfObject:currentAccount] + 1;
    if(index > [_accounts count]){
        index = 0;
    }
    
    ACAccount *newAccount = [_accounts objectAtIndex:index];
    [[NSUserDefaults standardUserDefaults] setObject:[newAccount identifier] forKey:kDefaultAccountIdentifierKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GOAccountsDidChangeNotification object:nil];
    [self updateAccountIndicator];
}

@end
