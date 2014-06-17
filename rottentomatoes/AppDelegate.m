//
//  AppDelegate.m
//  rottentomatoes
//
//  Created by Natarajan Kannan on 6/7/14.
//  Copyright (c) 2014 Y.CORP.YAHOO.COM\natarajk. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    MoviesViewController *boxOfficeVC = [[MoviesViewController alloc] init];
    boxOfficeVC.dataUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=3aw6qppb5a4efy3mn9q5twth";
    UINavigationController *navBoxOfficeVC = [[UINavigationController alloc] initWithRootViewController:boxOfficeVC];
    navBoxOfficeVC.tabBarItem.title = @"Box Office";
    navBoxOfficeVC.tabBarItem.image =  [UIImage imageNamed:@"ticket_icon"];

    
    MoviesViewController *dvdVC = [[MoviesViewController alloc] init];
    dvdVC.dataUrl = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=3aw6qppb5a4efy3mn9q5twth";
    UINavigationController *navDVDVC = [[UINavigationController alloc] initWithRootViewController:dvdVC];
    navDVDVC.tabBarItem.title = @"DVD";
    navDVDVC.tabBarItem.image =  [UIImage imageNamed:@"dvd_icon"];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSArray* controllers = [NSArray arrayWithObjects: navBoxOfficeVC, navDVDVC, nil];
    tabBarController.viewControllers = controllers;
    
    self.window.rootViewController = tabBarController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
