//
//  GOViewController.h
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GODataSource.h"

@class GOUserCell;
@class GODataSource;
@class GOAccountsViewController;
@interface GOSearchViewController : UITableViewController<GODataSourceInformer, UIActionSheetDelegate, UISearchBarDelegate>

// UI
@property(nonatomic, weak) IBOutlet UISearchBar *searchBar;

// Helpers
@property(nonatomic, strong) IBOutlet GODataSource *dataSource;
@property(nonatomic, strong) IBOutlet GOAccountsViewController *accountsController;
@end
