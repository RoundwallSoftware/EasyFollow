//
//  GODataSource.h
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GODataSourceInformer;

@interface GODataSource : NSObject{
    UINib *_userCellNib;
}

@property(nonatomic, retain) NSString *cellClassName;
@property(nonatomic, retain) NSArray *results;

@property(nonatomic, retain) IBOutlet UITableViewCell *customCell;
@property(nonatomic, retain) IBOutlet id<GODataSourceInformer> informer;

- (id)objectAtIndexPath:(NSIndexPath *)path;

@end

@protocol GODataSourceInformer <NSObject>
@required;
- (void)configureCell:(UITableViewCell*)cell forTableView:(UITableView*)tableView andIndexPath:(NSIndexPath *)path;
@end
