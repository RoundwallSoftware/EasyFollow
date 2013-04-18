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
@class GOAccountsView;
@interface GOSearchViewController : UIViewController<GODataSourceInformer, UIActionSheetDelegate, UISearchBarDelegate>

// UI
@property(nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property(nonatomic, weak) IBOutlet UITableView *tableView;

// Helpers
@property(nonatomic, strong) IBOutlet GODataSource *dataSource;
@property(nonatomic, strong) IBOutlet GOAccountsView *accountsControl;
@end
