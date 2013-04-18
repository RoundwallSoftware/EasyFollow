//
//  GOAppDelegate.m
//  EasyFollow
//
//  Created by Samuel Goodwin on 4/9/12.
//  Copyright (c) 2012 SNAP Interactive. All rights reserved.
//

#import "GOAppDelegate.h"

@implementation GOAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"UINavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    return YES;
}

@end
