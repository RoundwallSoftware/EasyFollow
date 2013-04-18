//
//  GOViewController.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import "GOSearchViewController.h"
#import "GOAccountsView.h"
#import "GOTwitterUser.h"
#import <Social/Social.h>
#import "JGAFImageCache.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface GOSearchViewController ()
@property (nonatomic, strong) SLRequest *searchRequest;
@property (nonatomic, strong) NSMutableSet *blockedIDs;
@property (nonatomic, strong) NSMutableSet *followingIDs;
- (void)becomeReady;
- (void)accountsDidChange:(NSNotification *)notification;
@end

@implementation GOSearchViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getBlocksAndFollows];
    
    self.searchBar.placeholder = NSLocalizedString(@"real name or username", @"Search bar placeholder");
    
    if(CGRectGetHeight([[UIScreen mainScreen] bounds]) > 480.0f){
        self.backgroundImageView.image = [UIImage imageNamed:@"MainBackground-568h"];
        NSParameterAssert(self.backgroundImageView.image);
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountsDidChange:) name:GOAccountsDidChangeNotification object:nil];
    
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:type options:nil completion:^(BOOL granted, NSError *error) {
        NSArray *accounts = [store accountsWithAccountType:type];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!granted || accounts == nil || [accounts count] == 0){
                NSString *title = NSLocalizedString(@"Sorry", @"Alert title for when we don't have twitter access.");
                NSString *message = NSLocalizedString(@"We cannot do anything without access to one of your twitter accounts.", @"Alert message when we don't have twitter access.");
                                                      
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"Alert button title.") otherButtonTitles:nil] show];
                
                [self.accountsControl setupEmpty];
                [self.accountsControl updateAccountIndicator];
            }else{
                [self becomeReady];
            }
        });
    }];
}

#pragma mark -
#pragma mark Actions

- (void)becomeReady{
    NSParameterAssert([self accountsControl]);
    [self.accountsControl setup];
    [self.accountsControl updateAccountIndicator];
    [self.searchBar setUserInteractionEnabled:YES];
    [self.searchBar becomeFirstResponder];
    
    [self getBlocksAndFollows];
}

- (void)configureCell:(UITableViewCell *)cell forTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    GOTwitterUser *user = [self.dataSource objectAtIndexPath:indexPath];
    cell.textLabel.text = [user realName];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = [user username];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCellBackground"]];
    cell.imageView.image = [self treatedImage:[UIImage imageNamed:@"default_profile"]];
    
    NSString *state = nil;
    
    if([self isBlocked:user]){
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlockedIndicator"]];
        state = NSLocalizedString(@"Blocked", @"When a user is blocked");
    }else{
        if([self isFollowing:user]){
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FollowingIndicator"]];
            state = NSLocalizedString(@"Following", @"When a user is being followed");
        }else{
            cell.accessoryView = nil;
        }
    }
    
    if(state){
        cell.accessibilityLabel = [NSString stringWithFormat:@"%@\n%@\n%@", [user realName], [user username], state];
    }
    
    if(!user){
        return;
    }
    
    cell.imageView.image = user.image;
    if(!user.image){
        cell.imageView.image = [self treatedImage:[UIImage imageNamed:@"default_profile"]];
        
        [[JGAFImageCache sharedInstance] imageForURLString:[user profileImageURLString] completion:^(UIImage *image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *newImage = [self treatedImage:image];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
                    currentCell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [currentCell.imageView setImage:newImage];
                });
            });
        }];
    }
}

- (UIImage *)treatedImage:(UIImage *)image
{
    CGFloat padding = 6.0f;
    CGFloat scale = image.scale;
    
    CGRect frame = CGRectMake(0.0f+(padding/2.0f), 0.0f+(padding/2.0f), image.size.width*scale, image.size.height*scale);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width*scale+(padding*scale), image.size.height*scale+(padding*scale)), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Color Declarations
    UIColor* outerBorder = [UIColor colorWithRed: 0.082 green: 0.082 blue: 0.082 alpha: 1];
    UIColor* avatarShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.75];
    UIColor* color = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.35];
    
    //// Shadow Declarations
    UIColor* avatarShadow = avatarShadowColor;
    CGSize avatarShadowOffset = CGSizeMake(0.0f, 1.0f*scale);
    CGFloat avatarShadowBlurRadius = 1.0f*scale;
    
    //// Avatar Drawing
    UIBezierPath* avatarPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(frame, 1.0f*scale, 1.0f*scale)];
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, avatarShadowOffset, avatarShadowBlurRadius, avatarShadow.CGColor);
    
    [outerBorder setStroke];
    avatarPath.lineWidth = 2.0f*scale;
    [avatarPath stroke];
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    [avatarPath addClip];
    
    [image drawInRect:CGRectMake(0.0f+(padding*0.5f*scale), 0.0f+(padding*0.5f*scale), image.size.width*scale, image.size.height*scale)];
    
    //// Inner Highlight Drawing
    UIBezierPath* innerHighlightPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(frame, 1.0f*scale, 1.0f*scale)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, avatarShadowOffset, avatarShadowBlurRadius, avatarShadow.CGColor);
    CGContextRestoreGState(context);
    
    [color setStroke];
    innerHighlightPath.lineWidth = 2.0f*scale;
    [innerHighlightPath stroke];
    
    // Get the image, here setting the UIImageView image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)accountsDidChange:(NSNotification *)notification{
    [self getBlocksAndFollows];
    [self search:self.searchBar.text];
}

#pragma mark -
#pragma mark Searching

- (void)search:(NSString*)term{
    if(!term || [term length] == 0){
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:[self.view superview] animated:YES];
    
    [self.dataSource setResults:nil];
    [self.tableView reloadData];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/search.json"];
    NSDictionary *params = @{@"q":term, @"include_entities": @"0"};
    
    self.searchRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
    ACAccount *currentAccount = [self.accountsControl currentAccount];
    NSString *username = [@"@" stringByAppendingString:[currentAccount username]];
    [self.searchRequest setAccount:currentAccount];
    
    [self.searchRequest performRequestWithHandler:^(NSData *__strong responseData, NSHTTPURLResponse *__strong urlResponse, NSError *__strong error) {
        if([urlResponse statusCode] != 200){
            NSLog(@"error %i, %@", [urlResponse statusCode], [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [MBProgressHUD hideHUDForView:[self.view superview] animated:YES];
            });
            return;
        }
        
        NSArray *returnedObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        NSMutableArray *newResults = [NSMutableArray array];
        [returnedObject enumerateObjectsUsingBlock:^(__strong id obj, NSUInteger idx, BOOL *stop) {
            GOTwitterUser *user = [GOTwitterUser userWithDictionary:obj];
            if(![[user username] isEqualToString:username]){
                [newResults addObject:user];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSParameterAssert([self tableView]);
            NSParameterAssert([self dataSource]);
            NSParameterAssert([newResults count]);
            [self.dataSource setResults:newResults];
            [self.tableView reloadData];
            
            [MBProgressHUD hideHUDForView:[self.view superview] animated:YES];
        });
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar{
    [aSearchBar resignFirstResponder];
    if([[aSearchBar text] length] > 0){
        [self search:[aSearchBar text]];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    GOTwitterUser *user = [self.dataSource objectAtIndexPath:indexPath];
    if(!user){
        return;
    }
    
    NSString *followTitle = nil;
    if([self isFollowing:user]){
        followTitle = NSLocalizedString(@"Unfollow", @"Stop following action sheet button.");
    }else{
        followTitle = NSLocalizedString(@"Follow", @"Start following action sheet button.");
    }
    
    NSString *blockedTitle = nil;
    if([self isBlocked:user]){
        blockedTitle = NSLocalizedString(@"Unblock", @"Unblock action sheet button");
    }else{
        blockedTitle = NSLocalizedString(@"Block", @"Block action sheet button");
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[user username] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button title") destructiveButtonTitle:blockedTitle otherButtonTitles:followTitle, nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITableView *tableView = self.tableView;
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(buttonIndex == [actionSheet cancelButtonIndex]){
        return;
    }
    
    GOTwitterUser *user = [self.dataSource objectAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    cell.accessoryView = indicatorView;
    
    GOCompletionBlock block = ^(void){
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    if(buttonIndex == [actionSheet destructiveButtonIndex]){
        if([self isBlocked:user]){
            [self.blockedIDs removeObject:[user userID]];
            [user unblockFromAccount:[self.accountsControl currentAccount] completion:block];
        }else{
            [self.blockedIDs addObject:[user userID]];
            [self.followingIDs removeObject:[user userID]];
            [user blockFromAccount:[self.accountsControl currentAccount] completion:block];
        }
        return;
    }
    
    if([self isFollowing:user]){
        [self.followingIDs removeObject:[user userID]];
        [user unfollowFromAccount:[self.accountsControl currentAccount] completion:block];
    }else{
        [self.followingIDs addObject:[user userID]];
        [user followFromAccount:[self.accountsControl currentAccount] completion:block];
    }
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.dataSource setResults:nil];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

#pragma mark - Blocks and Follows

- (void)getBlocksAndFollows
{
    NSURL *blockURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/blocks/ids.json"];
    SLRequest *blockRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:blockURL parameters:@{@"stringify_ids":@"1"}];
    ACAccount *currentAccount = [self.accountsControl currentAccount];
    [blockRequest setAccount:currentAccount];
    
    [blockRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSDictionary *returnedObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        NSArray *blockedIDs = returnedObject[@"ids"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blockedIDs = [NSMutableSet setWithArray:blockedIDs];
            [self.searchDisplayController.searchResultsTableView reloadData];
        });
    }];
    
    NSURL *friendURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/friends/ids.json"];
    SLRequest *friendRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:friendURL parameters:@{@"stringify_ids":@"1"}];
    [friendRequest setAccount:currentAccount];
    
    [friendRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSDictionary *returnedObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        NSArray *friendIDs = returnedObject[@"ids"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.followingIDs = [NSMutableSet setWithArray:friendIDs];
            [self.searchDisplayController.searchResultsTableView reloadData];
        });
    }];
}

- (BOOL)isBlocked:(GOTwitterUser *)user
{
    return [self.blockedIDs containsObject:[user userID]];
}

- (BOOL)isFollowing:(GOTwitterUser *)user
{
    return [self.followingIDs containsObject:[user userID]];
}

@end
