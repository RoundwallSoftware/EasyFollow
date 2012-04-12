//
//  GOTwitterUser.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 6/12/11.
//  Copyright 2011 Goodwinlabs. All rights reserved.
//

#import "GOTwitterUser.h"
#import <Twitter/TWRequest.h>
#import "NSDictionary+GODictionaryLiterals.h"

@implementation GOTwitterUser

NSString *const kUserDescriptionKey = @"description";
NSString *const kUserScreennameKey = @"screen_name";
NSString *const kUserNameKey = @"name";
NSString *const kUserIsFollowingKey = @"following";
NSString *const kUserProfileURLStringKey = @"profile_image_url";

static NSInteger requestCount = 0;

+ (id)userWithDictionary:(NSDictionary*)dict{
    GOTwitterUser *user = [[self alloc] init];
    [user updateWithDictionary:dict];
    return user;
}

- (void)updateWithDictionary:(NSDictionary*)dict{
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
    
    NSNumber *isFollowing = dict[kUserIsFollowingKey];
    if(isFollowing != nil && ![isFollowing isEqual:[NSNull null]]){
        self.following = [isFollowing boolValue];
    }
    
    NSString *profileURLString = dict[kUserProfileURLStringKey];
    if(profileURLString){
        self.profileImageURL = [NSURL URLWithString:profileURLString];
    }
}

- (void)handleRequest:(TWRequest*)request withBlock:(GOCompletionBlock)block{
    requestCount++;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [request performRequestWithHandler:^(NSData *__strong responseData, NSHTTPURLResponse *__strong urlResponse, NSError *__strong error) {
        requestCount--;
        if(requestCount <= 0){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        if([urlResponse statusCode] != 200){
            NSLog(@"error %i, %@", [urlResponse statusCode], [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
            return;
        }
        NSDictionary *returnedObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if([returnedObject objectForKey:@"error"]){
                NSLog(@"error %i, %@", [urlResponse statusCode], returnedObject);
            }else{
                [self updateWithDictionary:returnedObject];
            }
            block();
        });
    }];
}

- (void)followFromAccount:(ACAccount*)account andBlock:(GOCompletionBlock)block{
    if([self isFollowing]){
        return;
    }
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/friendships/create.json"];
    NSDictionary *params = @{
        @"screen_name":[self username],
        @"skip_status":@"t"
    };
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodPOST];
    
    [request setAccount:account];
    [self handleRequest:request withBlock:block];
}

- (void)unfollowFromAccount:(ACAccount*)account andBlock:(GOCompletionBlock)block{
    if(![self isFollowing]){
        return;
    }
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/friendships/destroy.json"];
    NSDictionary *params = @{
        @"screen_name":[self username],
        @"skip_status":@"t"
    };
    TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodPOST];
    
    [request setAccount:account];
    [self handleRequest:request withBlock:block];
}

@end
