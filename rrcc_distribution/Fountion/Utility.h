//
//  Utility.h
//  CloudTravel
//
//  Created by hetao on 10-12-5.
//  Copyright 2010 oulin. All rights reserved.
//  先放在这边，后期有时间再整合

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


#define default_pwd         @"default_pwd"
#define default_userName    @"default_userName"
#define default_userLogo    @"default_userLogo"
#define default_userId      @"default_userId"
#define default_userToken   @"default_userToken"
#define default_captchCode  @"default_captchCode"
#define default_storeId     @"default_storeId"
#define default_userAccount @"default_userAccount"//用户账号
#define default_openStatus  @"default_openStatus"//店铺是否开启
#define default_storeDic    @"default_storeDic" //店铺信息
#define default_priviteKey  @"default_priviteKey"//私钥
#define default_aliPayCount @"default_aliPayCount"//支付宝账号
#define default_updateTime  @"default_updateTime"//更新时间


@interface Utility : NSObject<MBProgressHUDDelegate>

+(id)Share;
-(UIButton*) createBackButton;
//验证电话号码
- (BOOL) validateMobileNumber:(NSString*)mobileNum;
- (BOOL) validateEmail: (NSString *) candidate;
- (void) makeCall:(NSString *)phoneNumber;
- (BOOL) validateIdentityCard: (NSString *)identityCard;

//用户相关
@property (nonatomic, strong) NSString *userId;//用户ID
@property (nonatomic, strong) NSString *userName;//用户姓名
@property (nonatomic, strong) NSString *userPwd;//用户密码/
@property (nonatomic, strong) NSString *userLogo;//用户头像
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *captchCode;//验证码
@property (nonatomic, strong) NSString *storeId;//店铺Id 
@property (nonatomic, strong) NSString *userAccount;//账号
@property (nonatomic, strong) NSString *openStatus;//店铺状态
@property (nonatomic, strong) NSMutableDictionary *storeDic;//店铺信息
@property (nonatomic, strong) NSString *priviteKey;//私钥
@property (nonatomic, strong) NSString *aiLiPayCountStr;//支付宝账号
@property (nonatomic, strong) NSString *UpdataTime;//每次更新订单的时间


//用户本地数据
-(void)saveUserInfoToDefault;
-(void)readUserInfoFromDefault;
-(void)clearUserInfoInDefault;

//时间戳
-(NSString *)timeToTimestamp:(NSString *)timestamp;

//圆角或椭圆
-(void)viewLayerRound:(UIView *)view borderWidth:(float)width borderColor:(UIColor *)color;


//获取UNIX 时间戳
-(NSString*)GetUnixTime;
-(NSData*)Data2Image:(NSString*)string;
-(NSString*)image2DataURL:(UIImage *)image;
-(NSString*)toBase64String:(NSString*)string;
-(NSString*)base64Encode:(NSString *)plainText;



// 获取当前时间
-(NSString*)GetNowTime;
//获取2天前的时间
-(NSString*)DayBeforeYesterday;
//获取前天的时间
-(NSString*)DayYesterday;
//获取下一天
-(NSString*)DayNextDay;
//获取今天日期
-(NSString*)GetTodayDay;
//获取一周前的日期
-(NSString*)lastWeekDay;
//字符串转时间
-(NSDate*)dateFromString:(NSString*)dateString;

//提示
-(void)showHud;
-(void)hideHud;

-(void)alertTitle:(NSString*)str;

@end
