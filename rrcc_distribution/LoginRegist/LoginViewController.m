//
//  LoginViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-19.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "LoginViewController.h"
#import "OrderManageViewController.h"
#import "RegistMobileViewController.h"


@interface LoginViewController (){
    __weak IBOutlet UITextField *TelText;
    __weak IBOutlet UITextField *PwdText;
    }
@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"登录";
    UIGestureRecognizer *scrolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:scrolTap];
 }


-(IBAction)Login:(id)sender{
    if (![TelText.text notEmptyOrNull]){
        [[Utility Share] alertTitle:@"请输入手机号"];
    }else if (![[Utility Share] validateMobileNumber:TelText.text]){
        [[Utility Share] alertTitle:@"请输入正确的手机号码!"];
    }else if (![PwdText.text notEmptyOrNull]){
        [[Utility Share]alertTitle:@"请输入密码"];
    }else{
        UIDevice *device_=[[UIDevice alloc] init];
        NSString *DeviceInfo = [NSString stringWithFormat:@"%@%@%@%@%@",@"IOS:",device_.model,@"(",device_.systemVersion,@")"];
        NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@%@",BASEURL,CustomerLogin,@"?account=",TelText.text];
        NSString *loginUrl = [[RestHttpRequest SharHttpRequest] LoginPubKey:baseUrl InputResourceId:@"" InputPayLoad:@"" InPutPwd:PwdText.text];
        //配置参数
        NSDictionary *loginDic = [[NSDictionary alloc] initWithObjectsAndKeys:DeviceInfo,@"device",nil];
        [[Utility Share] showHud];
        
        NSLog(@"loginUrl : %@",loginUrl);
        
        [[AppDelegate Share].manger GET:loginUrl parameters:loginDic success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"userDic : %@",userDic);

            
            if ([[userDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"userid"]){
                [[Utility Share] setStoreDic:[userDic objectForJSONKey:@"CallInfo"]];
                [[Utility Share] setUserId:[[userDic objectForJSONKey:@"CallInfo"]objectForJSONKey:@"userid"]];
                [[Utility Share] setPriviteKey:PwdText.text.md5];
                [[Utility Share] setUserAccount:TelText.text];
                [[Utility Share] setUserPwd:PwdText.text];
                [[Utility Share] saveUserInfoToDefault];
                //进入主界面
                OrderManageViewController *orderView = [[OrderManageViewController alloc] init];
                XHBaseNavigationController*orderNav = [[XHBaseNavigationController alloc] initWithRootViewController:orderView];
                orderNav.navigationBar.translucent = NO;
                [AppDelegate Share].window.rootViewController = orderNav;
            }else{
                [[Utility Share] alertTitle:@"密码错误,请重新登录!"];
            }
            [[Utility Share] hideHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [[Utility Share] alertTitle:[error localizedDescription]];
            [[Utility Share] hideHud];
        }];
    }
}

-(IBAction)PushMobileView:(UIButton*)sender{
    RegistMobileViewController *registView = [[RegistMobileViewController alloc] init];
    [self pushNewViewController:registView];
    
}


-(void)closeKeyBoard{
    [TelText resignFirstResponder];
    [PwdText resignFirstResponder];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
