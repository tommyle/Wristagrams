//
//  AppDelegate.m
//  Wristagrams
//
//  Created by admin on 2015-05-16.
//  Copyright (c) 2015 Kodemine. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UIColor+Custom.h"
#import "CoreDataStack.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.coreDataStack = [[CoreDataStack alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1.0]];
    
    self.viewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    [navigationController pushViewController:self.viewController animated:NO];
    
    //makes the status bar text white
    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        navigationController.navigationBar.barTintColor = [UIColor dayOneBlue];
        navigationController.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        navigationController.navigationBar.tintColor = [UIColor dayOneBlue];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor paleWhite],
                                                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0],
                                                           }];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor paleWhite],
                                                                                                       NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:16.0]
                                                                                                       } forState:UIControlStateNormal];
    
    //changes the color of the back button arrow
    navigationController.navigationBar.tintColor = [UIColor paleWhite];
    
    self.window.rootViewController = navigationController;
    
    /*
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:
                                          [[ViewController alloc] init],
                                          nil]];
    
    self.window.rootViewController = tabBarController;
    */
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self.coreDataStack saveContext];
}

@end
