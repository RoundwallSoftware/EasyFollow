//
//  GODataSource.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import "GODataSource.h"

@interface GODataSource()
@property (nonatomic, assign, getter = isEmpty) BOOL empty;
@end

@implementation GODataSource

- (void)awakeFromNib{
    [super awakeFromNib];
    _userCellNib = [UINib nibWithNibName:@"GOUserCell" bundle:nil];
    self.results = nil;
}

- (id)objectAtIndexPath:(NSIndexPath *)path{
    if([self.results count]){
        return self.results[path.row];
    }
    return nil;
}

- (void)setResults:(NSArray *)results
{
    if(results != nil && [results count] == 0){
        self.empty = YES;
    }else{
        self.empty = NO;
    }
    _results = results;
}

#pragma mark -
#pragma mark Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6; [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{    
    static NSString *identifier = @"aCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [self.informer configureCell:cell forTableView:tableView andIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleInsert;
}

@end
