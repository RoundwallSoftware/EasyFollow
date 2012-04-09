//
//  GODataSource.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import "GODataSource.h"
#import "NSArray+GOArrayLiterals.h"

@interface GODataSource()
@end

@implementation GODataSource

- (void)awakeFromNib{
    [super awakeFromNib];
    _userCellNib = [UINib nibWithNibName:self.cellClassName bundle:nil];
    self.results = @[];
}

- (id)objectAtIndexPath:(NSIndexPath *)path{
    return self.results[path.row];
}

#pragma mark -
#pragma mark Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{    
    static NSString *identifier = @"aCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        [_userCellNib instantiateWithOwner:self options:nil];
        cell = self.customCell;
        self.customCell = nil;
    }
    [self.informer configureCell:cell forTableView:tableView andIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleInsert;
}

@end
