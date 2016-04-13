//
//  CheckUserInfoViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-23.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "CheckUserInfoViewController.h"
#import "LoginViewController.h"

@interface CheckUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *BackView;

@end

@implementation CheckUserInfoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"注册信息审核";
    //审核状态，不让返回
    UIButton *barBtn   = [RHMethods buttonWithFrame:CGRectMake(0,0,60, 44) title:@"" image:@"" bgimage:@""];
    
    [barBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    _BackView.backgroundColor = [UIColor whiteColor];
    [[Utility Share] viewLayerRound:_BackView borderWidth:0.5 borderColor:[UIColor lightGrayColor]];
}

-(void)dismissSelf{

    
}

-(IBAction)playTell:(id)sender{
    NSString *TelStr = @"4000285927";
    [[Utility Share] makeCall:TelStr];
}

-(IBAction)Submit:(id)sender{
    LoginViewController *loginView = [[LoginViewController alloc] init];
    XHBaseNavigationController *LoginNav = [[XHBaseNavigationController alloc] initWithRootViewController:loginView];
    LoginNav.navigationBar.translucent = NO;
    [AppDelegate Share].window.rootViewController = LoginNav;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
