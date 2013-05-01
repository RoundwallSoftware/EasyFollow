//
//  GOTwitterUser.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 6/12/11.
//  Copyright 2011 Goodwinlabs. All rights reserved.
//

#import "GOTwitterUser.h"
#import <Twitter/TWRequest.h>

@implementation GOTwitterUser

NSString *const kUserDescriptionKey = @"description";
NSString *const kUserScreennameKey = @"screen_name";
NSString *const kUserNameKey = @"name";
NSString *const kUserIsFollowingKey = @"following";
NSString *const kUserProfileURLStringKey = @"profile_image_url";
NSString *const kUserLocationKey = @"location";
NSString *const kUserURLStringKey = @"url";

static NSInteger requestCount = 0;

+ (id)userWithDictionary:(NSDictionary*)dict{
    GOTwitterUser *user = [[self alloc] init];
    [user updateWithDictionary:dict];
    return user;
}

- (void)updateWithDictionary:(NSDictionary*)dict{
    self.userID = dict[@"id_str"];
    
    NSString *tagLineString = dict[kUserDescriptionKey];
    if(![tagLineString isEqual:[NSNull null]]){
        self.tagline = tagLineString;
    }
    
    NSString *screenName = dict[kUserScreennameKey];
    if(![screenName isEqual:[NSNull null]]){
        self.username = [NSString stringWithFormat:@"@%@", screenName];
    }
    NSAssert(self.username, @"NO Screen name!");
    
    NSString *realNameString = [dict objectForKey:kUserNameKey];
    if(![realNameString isEqual:[NSNull null]]){
        self.realName = realNameString;
    }
    NSAssert(self.realName, @"NO REAL NAME!");
    
    NSString *profileURLString = dict[kUserProfileURLStringKey];
    if(![profileURLString isEqual:[NSNull null]]){
        self.profileImageURLString = profileURLString;
    }
    
    NSString *location = dict[kUserLocationKey];
    if(![location isEqual:[NSNull null]]){
        self.location = location;
    }
    
    NSString *urlString = dict[kUserURLStringKey];
    if(![urlString isEqual:[NSNull null]]){
        self.urlString = urlString;
    }
}

- (NSAttributedString *)followingStatusConsideringFollowings:(NSSet *)followings blocks:(NSSet *)blocks
{
    NSMutableAttributedString *text = nil;
    
    if([blocks containsObject:self.userID]){
        text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Blocked", @"Blocked status label")];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [text length])];
        return text;
    }
    
    if([followings containsObject:self.userID]){
        text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Following", @"Following status label")];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, [text length])];
    }else{
        text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Not Following", @"Not-Following status label")];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [text length])];
    }
    return text;
}

- (void)handleRequest:(SLRequest*)request block:(GOCompletionBlock)block{
    requestCount++;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [request performRequestWithHandler:^(NSData *__strong responseData, NSHTTPURLResponse *__strong urlResponse, NSError *__strong error) {
        
        if([urlResponse statusCode] != 200){
            NSLog(@"error %i, %@", [urlResponse statusCode], [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                requestCount--;
                if(requestCount <= 0){
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }
                block();
            });
            return;
        }
        NSDictionary *returnedObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            requestCount--;
            if(requestCount <= 0){
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
            
            if([returnedObject objectForKey:@"error"]){
                NSLog(@"error %i, %@", [urlResponse statusCode], returnedObject);
            }else{
                [self updateWithDictionary:returnedObject];
            }
            
            block();
        });
    }];
}

- (void)followFromAccount:(ACAccount*)account completion:(GOCompletionBlock)block{
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/friendships/create.json"];
    NSDictionary *params = @{
        @"screen_name":[self username],
        @"skip_status":@"1",
        @"include_entities": @"0"
    };
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:params];
    
    [request setAccount:account];
    [self handleRequest:request block:block];
}

- (void)unfollowFromAccount:(ACAccount*)account completion:(GOCompletionBlock)block{
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/friendships/destroy.json"];
    NSDictionary *params = @{
        @"screen_name":[self username],
        @"skip_status": @"1",
        @"include_entities": @"0"
    };
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:params];
    
    [request setAccount:account];
    [self handleRequest:request block:block];
}

- (void)blockFromAccount:(ACAccount *)account completion:(GOCompletionBlock)block
{
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/blocks/create.json"];
    NSDictionary *params = @{
                             @"screen_name":[self username],
                             @"skip_status":@"1",
                             @"include_entities": @"0"
                             };
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:params];
    
    [request setAccount:account];
    [self handleRequest:request block:block];
}

- (void)unblockFromAccount:(ACAccount *)account completion:(GOCompletionBlock)block
{
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/blocks/destroy.json"];
    NSDictionary *params = @{
                             @"user_id":[self userID],
                             @"skip_status":@"1",
                             @"include_entities": @"0"
                             };
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:url parameters:params];
    
    [request setAccount:account];
    [self handleRequest:request block:block];
}

@end
