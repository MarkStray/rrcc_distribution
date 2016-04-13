//
//  ChangPwdViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-22.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "ChangPwdViewController.h"

@interface ChangPwdViewController ()
{
    __weak IBOutlet UITextField *OriginalPwdTxt;//原始密码
    __weak IBOutlet UITextField *NewPwdTxt;//新密码
    __weak IBOutlet UITextField *RepeatTxt;//重复密码
}

@end

@implementation ChangPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    UIGestureRecognizer *scrolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:scrolTap];

}

 -(IBAction)ChangePwd:(id)sender{

     if (![OriginalPwdTxt.text notEmptyOrNull] || ![NewPwdTxt.text notEmptyOrNull] || ![RepeatTxt.text notEmptyOrNull]){
         [[Utility Share] alertTitle:@"请输入密码!"];
         
    }else if (![NewPwdTxt.text isEqualToString:RepeatTxt.text]){
        
        [[Utility Share] alertTitle:@"您输入的密码不一样!"];
        
    }else{
        
        NSString *PayLoad = [NSString stringWithFormat:@"%@%@%@%@",@"oldPassword=",OriginalPwdTxt.text,@"&newPassword=",RepeatTxt.text];
        NSString *Base64PayLoad = [[Utility Share] base64Encode:PayLoad];
        
        NSString *PwdUrl = [NSString stringWithFormat:@"%@%@%@%@%@",BASEURL,Password,[[Utility Share] userId],@"?uid=",[[Utility Share] userId]];
        NSString *UrlPwd = [[RestHttpRequest SharHttpRequest] ApendPubkey:PwdUrl InputResourceId:[[Utility Share] userId] InputPayLoad:Base64PayLoad];
        NSURL *url = [NSURL URLWithString:UrlPwd];
        //获得HTTP Body
        NSString *bodyStr = [[RestHttpRequest SharHttpRequest] GetHttpBody:Base64PayLoad];
        //发送网络请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                        cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody: [bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
            if ([[responseObject objectForJSONKey:@"Success"] isEqualToString:@"1"]){
                [[Utility Share] setPriviteKey:RepeatTxt.text.md5];
                [[Utility Share] setUserPwd:RepeatTxt.text];
                [[Utility Share] saveUserInfoToDefault];
                [[Utility Share] alertTitle:@"您已成功修改密码!"];
                [self.navigationController popViewControllerAnimated:YES];
             }else{
                 [[Utility Share] alertTitle:@"请重新修改密码!"];
             }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         }];
        [op start];
    }
}



-(void)closeKeyBoard{
    
    [OriginalPwdTxt resignFirstResponder];
    [NewPwdTxt resignFirstResponder];
    [RepeatTxt resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
