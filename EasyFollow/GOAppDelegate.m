//
//  GOAppDelegate.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import "GOAppDelegate.h"
#import "GOSearchViewController.h"

@implementation GOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"SearchBarBackground.png"]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"UINavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(launchOptions[UIApplicationLaunchOptionsURLKey]){
            [[NSNotificationCenter defaultCenter] postNotificationName:GOLaunchParametersNotification object:launchOptions[UIApplicationLaunchOptionsURLKey]];
        }
    });
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:GOLaunchParametersNotification object:url];
    return YES;
}

@end
