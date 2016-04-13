//
//  StoreInfoViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-25.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "StoreInfoViewController.h"
#import "RegistLogoViewController.h"
#import "GetCityListViewController.h"

@interface StoreInfoViewController ()<UITextViewDelegate>{
    
    NSDictionary *CityDic;
    NSString *UrlStr;
    IBOutlet UIScrollView *BackScroll;
    __weak IBOutlet UITextField *UserNameText;
    __weak IBOutlet UITextField *StoreNameText;
    __weak IBOutlet UITextField *UserCardtext;
    __weak IBOutlet UILabel     *CityLb;
    __weak IBOutlet UITextView  *DetailAdressText;
    
}
@end

@implementation StoreInfoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"注册";
    CityLb.userInteractionEnabled = YES;
    UIGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GoToCityList:)];
    [CityLb addGestureRecognizer:tapLabel];
    [CityLb setUserInteractionEnabled:YES];
    
    DetailAdressText.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CityName:) name:@"CityName" object:nil];
    [BackScroll setContentSize:CGSizeMake(kScreenWidth,kScreenHeight+100)];
    BackScroll.scrollEnabled = YES;
    BackScroll.userInteractionEnabled = YES;
    UIGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ClosKeyBoard)];
    [BackScroll addGestureRecognizer:tapScroll];
}

-(void)GoToCityList:(id)sender{
    GetCityListViewController *CityListView = [[GetCityListViewController alloc] init];
    [self pushNewViewController:CityListView];
}

-(void)CityName:(NSNotification *)text{
    CityDic = [[NSDictionary alloc] init];
    CityDic = text.userInfo;
    CityLb.text = [NSString stringWithFormat:@"%@%@",[CityDic objectForJSONKey:@"ProvinceName"],[CityDic objectForJSONKey:@"RegionName"]];
}


-(IBAction)SubmitRegistInfo:(id)sender{
    if (![[Utility Share] validateIdentityCard:UserCardtext.text]){
        [[Utility Share] alertTitle:@"请输入正确的身份证号码"];
        return;
    }
    //配置PayLoad 并且Base64
    NSString *Str1 = [NSString stringWithFormat:@"%@%@%@",@"custname=",UserNameText.text,@"&"];
    NSString *Str2 = [NSString stringWithFormat:@"%@%@%@",@"shopname=",StoreNameText.text,@"&"];
    NSString *Str3 = [NSString stringWithFormat:@"%@%@%@",@"idcard=",UserCardtext.text,@"&"];
    NSString *Str4 = [NSString stringWithFormat:@"%@%@%@",@"provinceid=",[CityDic objectForKey:@"Parentid"],@"&"];
    NSString *Str5 = [NSString stringWithFormat:@"%@%@%@",@"cityid=",[CityDic objectForKey:@"id"],@"&"];
    NSString *Str6 = [NSString stringWithFormat:@"%@%@",@"address=",DetailAdressText.text];
    NSString *BasePayLoad = [NSString stringWithFormat:@"%@%@%@%@%@%@",Str1,Str2,Str3,Str4,Str5,Str6];
    NSString *payLoadStr = [[Utility Share] base64Encode:BasePayLoad];
     //私钥是验证码的Md5
    NSString *priviteKeyStr = [[Utility Share] captchCode].md5;
    NSString *TimeStamp = [[Utility Share] GetUnixTime];
    NSString *PublicKey = [NSString stringWithFormat:@"%@%@%@%@",priviteKeyStr,[[Utility Share] userId],TimeStamp,payLoadStr].md5;
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",BASEURL,Profile,[[Utility Share] userId],@"?t=",TimeStamp,@"&uid=",[[Utility Share] userId],@"&k=",PublicKey];
    NSString *PostPayLoad = [[RestHttpRequest SharHttpRequest] GetHttpBody:payLoadStr];
    NSURL *url=[NSURL URLWithString:baseUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                        cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody: [PostPayLoad dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if ([[responseObject objectForJSONKey:@"Success"] isEqualToString:@"1"]){
            
            RegistLogoViewController *LoGoView = [[RegistLogoViewController alloc] init];
            [self pushNewViewController:LoGoView];
        }else{
            [[Utility Share] alertTitle:@"注册失败,请重新注册!"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
    [op start];

}


#pragma mark 关闭键盘
-(void)ClosKeyBoard{
    [UserNameText     resignFirstResponder];
    [StoreNameText    resignFirstResponder];
    [UserCardtext     resignFirstResponder];
    [DetailAdressText resignFirstResponder];
}


- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


@end
