//
//  MHAppDelegate.m
//  MHSliderPicker
//
//  Created by piggy on 16/8/5.
//  Copyright © 2016年 piggy. All rights reserved.
//

#import "MHAppDelegate.h"
#import "MHViewController.h"

@implementation MHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MHViewController *controller = [[MHViewController alloc] init];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
