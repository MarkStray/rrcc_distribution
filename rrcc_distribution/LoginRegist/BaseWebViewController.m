//
//  BaseWebViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-31.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "BaseWebViewController.h"

@interface BaseWebViewController (){
    
    __weak IBOutlet UIWebView *BaseWebView;
}

@end

@implementation BaseWebViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商户入驻协议";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.renrencaichang.com/agreement.html"]];
    [BaseWebView loadRequest:request];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
