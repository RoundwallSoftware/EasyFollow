//
//  GODataSource.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import "GODataSource.h"

@interface GODataSource()
@end

@implementation GODataSource

- (void)awakeFromNib{
    [super awakeFromNib];
    _userCellNib = [UINib nibWithNibName:self.cellClassName bundle:nil];
    self.results = @[];
}

- (id)objectAtIndexPath:(NSIndexPath *)path{
    if([self.results count]){
        return self.results[path.row];
    }
    return nil;
}

#pragma mark -
#pragma mark Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [self.results count];
    if(count == 0){
        count = 1;
    }
    return count;
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
