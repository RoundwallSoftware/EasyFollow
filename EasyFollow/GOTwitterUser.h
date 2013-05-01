//
//  GOTwitterUser.h
//  EasyFollow
//
//  Created by Samuel Goodwin on 6/12/11.
//  Copyright 2011 Goodwinlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GOCompletionBlock)(void);

@class ACAccount;
@interface GOTwitterUser : NSObject
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *realName;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *urlString;
@property(nonatomic, copy) NSString *tagline;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSString *profileImageURLString;

+ (id)userWithDictionary:(NSDictionary*)dict;
- (void)updateWithDictionary:(NSDictionary*)dict;

- (NSAttributedString *)followingStatusConsideringFollowings:(NSSet *)followings blocks:(NSSet *)blocks;

- (void)followFromAccount:(ACAccount*)account completion:(GOCompletionBlock)block;
- (void)unfollowFromAccount:(ACAccount*)account completion:(GOCompletionBlock)block;
- (void)blockFromAccount:(ACAccount *)account completion:(GOCompletionBlock)block;
- (void)unblockFromAccount:(ACAccount *)account completion:(GOCompletionBlock)block;

@end
