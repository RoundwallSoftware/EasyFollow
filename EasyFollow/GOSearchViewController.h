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
@interface GOSearchViewController : UIViewController<UITableViewDelegate, GODataSourceInformer, UIActionSheetDelegate>

// UI
@property(nonatomic, retain) IBOutlet UISearchBar *searchBar;

// Helpers
@property(nonatomic, retain) IBOutlet GODataSource *dataSource;
@property(nonatomic, retain) IBOutlet GOAccountsViewController *accountsController;
@end
