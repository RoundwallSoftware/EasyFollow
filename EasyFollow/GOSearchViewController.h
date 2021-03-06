//
//  GOViewController.h
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GODataSource.h"

extern NSString *const GOLaunchParametersNotification;

@class GOUserCell;
@class GODataSource;
@class GOAccountsView;
@interface GOSearchViewController : UIViewController<GODataSourceInformer, UIActionSheetDelegate, UISearchBarDelegate>

// UI
@property(nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

// Helpers
@property(nonatomic, strong) IBOutlet GODataSource *dataSource;
@property(nonatomic, strong) IBOutlet GOAccountsView *accountsControl;

- (IBAction)exit:(UIStoryboardSegue *)sender;
@end
