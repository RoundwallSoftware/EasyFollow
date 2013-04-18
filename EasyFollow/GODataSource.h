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

@property(nonatomic, strong) NSArray *results;

@property(nonatomic, weak) IBOutlet UITableViewCell *customCell;
@property(nonatomic, weak) IBOutlet id<GODataSourceInformer> informer;

- (id)objectAtIndexPath:(NSIndexPath *)path;

@end

@protocol GODataSourceInformer <NSObject>
@required;
- (void)configureCell:(UITableViewCell*)cell forTableView:(UITableView*)tableView andIndexPath:(NSIndexPath *)path;
@end
