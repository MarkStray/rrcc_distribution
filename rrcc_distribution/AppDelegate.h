//
//  AppDelegate.h
//  rrcc_distribution
//
//  Created by lawwilte on 8/25/15.
//  Copyright (c) 2015 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseNavigationController.h"
#import "AFHTTPRequestOperationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(AppDelegate*)Share;

@property (strong,nonatomic) UIWindow *window;
@property (strong,nonatomic) XHBaseNavigationController *orderNav;
@property (strong,nonatomic) XHBaseNavigationController *loginNav;
@property (strong,nonatomic) AFHTTPRequestOperationManager *manger;

@end

