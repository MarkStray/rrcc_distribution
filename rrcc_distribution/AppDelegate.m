//
//  AppDelegate.m
//  rrcc_distribution
//
//  Created by lawwilte on 8/25/15.
//  Copyright (c) 2015 ting liu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "OrderManageViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate*)Share{
    
    return  (AppDelegate*)[UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //为Manager 对象指定使用HTTP 响应解析器
    self.manger = [AFHTTPRequestOperationManager manager];
    self.manger.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    //自动登陆
    [[Utility Share] readUserInfoFromDefault];
    NSString *UserIdStr  = [[Utility Share] userId];
    NSString *PriviteStr = [[Utility Share] priviteKey];
    if (!UserIdStr && !PriviteStr){
        LoginViewController *loginView = [[LoginViewController alloc] init];
        _loginNav = [[XHBaseNavigationController alloc] initWithRootViewController:loginView];
        _loginNav.navigationBar.translucent = NO;
        self.window.rootViewController = _loginNav;
    }else{
        OrderManageViewController *orderView = [[OrderManageViewController alloc] init];
        _orderNav = [[XHBaseNavigationController alloc] initWithRootViewController:orderView];
        self.orderNav.navigationBar.translucent = NO;
        self.window.rootViewController = _orderNav;
    }
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
}

@end
