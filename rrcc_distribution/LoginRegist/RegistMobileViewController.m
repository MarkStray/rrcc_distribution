//
//  RegistMobileViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "RegistMobileViewController.h"
#import "StoreInfoViewController.h"
#import "BaseWebViewController.h"

BOOL AgreeBool = YES;//判断用户是否同意了协议
@interface RegistMobileViewController (){
    NSTimer     *timer;
    NSInteger   timeCount;
    __weak IBOutlet UITextField *TelText;
    __weak IBOutlet UITextField *CaptchText;
    __weak IBOutlet UIButton    *AgreeButt;
    __weak IBOutlet UIButton    *ProtoclButt;
    __weak IBOutlet UIButton    *CaptchButt;
    __weak IBOutlet UIButton    *NextButt;
    }
@end

@implementation RegistMobileViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"注册";
    UIGestureRecognizer *scrolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:scrolTap];
    [AgreeButt setBackgroundImage:[UIImage imageNamed:@"Select"] forState:UIControlStateNormal];
    [NextButt setEnabled:YES];
    AgreeBool = NO;
}
// 判断用户是否同意了协议
-(IBAction)AgreeOrDisAgree:(id)sender{
    if (AgreeBool){
        [AgreeButt setBackgroundImage:[UIImage imageNamed:@"Select"] forState:UIControlStateNormal];
        [NextButt setEnabled:YES];
        AgreeBool = NO;
    }else{
        [AgreeButt setBackgroundImage:[UIImage imageNamed:@"UnSelect"] forState:UIControlStateNormal];
        [NextButt setEnabled:NO];
        AgreeBool = YES;
    }
}

//获取验证码
-(IBAction)onGetCodeBtn:(UIButton*)sender{
    if ([TelText.text  isEqual: @""]){
        [[Utility Share] alertTitle:@"请输入手机号码"];
    }else if (![[Utility Share] validateMobileNumber:TelText.text]){
        [[Utility Share] alertTitle:@"请输入正确的手机号码!"];
    }else{
        UIDevice *device_=[[UIDevice alloc] init];
        NSString *DeviceInfo = [NSString stringWithFormat:@"%@%@%@%@%@",@"IOS:",device_.model,@"(",device_.systemVersion,@")"];
        NSDictionary *CaptchDic = [[NSDictionary alloc] initWithObjectsAndKeys:TelText.text,@"mobile", DeviceInfo,@"device",nil];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,Captcha];
        [[Utility Share] showHud];
        [[AppDelegate Share].manger  POST:urlStr parameters:CaptchDic success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSDictionary *CaptchDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[CaptchDic objectForJSONKey:@"Success"] isEqualToString:@"1"]){
                [[Utility Share] alertTitle:@"验证码已发送,请注意查收!"];
                [self getCodeSuccess];
            }else{
                [[Utility Share] alertTitle:[CaptchDic objectForKey:@"ErrorMsg"]];
            }
            [[Utility Share] hideHud];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[Utility Share] hideHud];
    }];
    }
}

-(void)getCodeSuccess{
    
     [CaptchText becomeFirstResponder];
     [self setCodeBtnBg:NO];
}


-(void)setCodeBtnBg:(BOOL)isNormal{
    if (isNormal){
        [CaptchButt setTitle:@"发送验证码" forState:UIControlStateNormal];
        [CaptchButt setBackgroundColor:[UIColor colorWithRGBHex:0x2ea821]];
        [self stopTimer];
    }else{
        [CaptchButt setTitle:@"60秒后获取"forState:UIControlStateNormal];
        CaptchButt.titleLabel.textAlignment = NSTextAlignmentLeft;
        [CaptchButt setBackgroundColor:[UIColor lightGrayColor]];
        timeCount = 60;
        [self startTimer];
    }
}

-(void)startTimer{
    if (timer==nil){
        CaptchButt.userInteractionEnabled = NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick)userInfo:nil repeats:YES];
    }
}

-(void) tick{
    timeCount--;
    NSString *str = [NSString stringWithFormat:@"%ld",(long)timeCount];
    [CaptchButt setTitle:str forState:UIControlStateNormal];
    if (timeCount<=0){
        [self setCodeBtnBg:YES];
    }
}

-(void)stopTimer{
    CaptchButt.userInteractionEnabled = YES;
    if (timer){
        [timer invalidate];
        timer = nil;
    }
}

-(IBAction)Protocl:(id)sender{
    
    BaseWebViewController *BaseWebView = [[BaseWebViewController alloc] init];
    [self pushNewViewController:BaseWebView];
}

-(IBAction)ValiteCode:(id)sender{
    if ([TelText.text isEqualToString:@""]){
        [[Utility Share] alertTitle:@"请输入手机号码"];
        return;
    }
    if (![[Utility Share] validateMobileNumber:TelText.text]){
        [[Utility Share] alertTitle:@"请输入正确的手机号码"];
        return;
    }
    if (CaptchText.text.length<4){
        [[Utility Share] alertTitle:@"请输入4位数验证码"];
        return;
    }
    [self SubmitCode];
}


-(void)SubmitCode{
    [self resignAll];
    NSDictionary *CaptchDic = [[NSDictionary alloc] initWithObjectsAndKeys:TelText.text,@"mobile", CaptchText.text,@"captcha",nil];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,Captcha];
    [[AppDelegate Share].manger PUT:urlStr parameters:CaptchDic success:^(AFHTTPRequestOperation *operation, id responseObject){
         NSDictionary *CaptchDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             if ([[CaptchDic objectForJSONKey:@"Success"]isEqualToString:@"1"]){
                 NSArray *CallArray = [CaptchDic objectForJSONKey:@"CallInfo"];
                 [[Utility Share] setUserId:[CallArray[0] objectForKey:@"userid"]];
                 [[Utility Share] setCaptchCode:CaptchText.text];
                 [[Utility Share] saveUserInfoToDefault];
                 StoreInfoViewController *storeInfoView = [[StoreInfoViewController alloc]init];
                 [self pushNewViewController:storeInfoView];
        }else{
            [[Utility Share] alertTitle:@"注册失败,请重新注册!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark 关闭键盘
-(void)closeKeyBoard{
    [TelText    resignFirstResponder];
    [CaptchText resignFirstResponder];
}

-(void)resignAll{
    [self setCodeBtnBg:YES];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
