//
//  Utility.m
//  CloudTravel
//
//  Created by hetao on 10-12-5.
//  Copyright 2010 oulin. All rights reserved.
//

#import "Utility.h"
#import <JSONKit.h>
#import <arpa/inet.h>
#import "AppDelegate.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#define picMidWidth 200
#define picSmallWidth 100

@interface Utility (){
    UITextField *accountField,*passField;
    NSString *phoneNum;
    UIAlertView *alertview;
    NSString *strIFlyType;
}
@property (nonatomic,strong) NSURL *phoneNumberURL;
@end

MBProgressHUD *HUD;

@implementation Utility

static Utility *_utilityinstance=nil;
static dispatch_once_t utility;

+(id)Share
{
    dispatch_once(&utility, ^ {
        _utilityinstance = [[Utility alloc] init];
    });
	return _utilityinstance;
}


-(UIButton*) createBackButton
{
    UIImage* image= [UIImage imageNamed:@"Arrow"];
    UIImage* imagef = [UIImage imageNamed:@"Arrow_press"];
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 60, 44);
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    if (IOS7) {
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    }else{
        [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    }
    
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:imagef forState:UIControlStateHighlighted];
    return backButton;
}



#pragma mark validateMobile
-(BOOL)validateMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSString *C11 = @"^1([3-9])\\d{9}$";
    NSPredicate *regextest11 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",C11];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextest11 evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 验证身份证

- (BOOL) validateIdentityCard: (NSString *)identityCard;{
    BOOL flag;
    if (identityCard.length <= 0){
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark validateEmail
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}



#pragma mark makeCall
- (void) makeCall:(NSString *)phoneNumber{
    
    phoneNum = phoneNumber;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拨打号码?"
                         message:phoneNum
                         delegate:self
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@"拨打",nil];
                         [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([alertView.title isEqualToString:@"拨打号码?"]) {//phoneCall AlertView
        if (buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNum]]];
        }
      //  phoneNum=nil;
	}
    else if (alertView.tag == 1001) {//版本验证
        UIView *notTouchView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        notTouchView.backgroundColor = [UIColor blackColor];
        notTouchView.alpha = 0.2;
        [[[UIApplication sharedApplication] keyWindow] addSubview:notTouchView];
    }
}


-(NSString*)GetUnixTime
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:timeInterval] longLongValue]; // 将double转为long long型
    NSString *tempTime = [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
    return tempTime;
}

//时间戳
-(NSString *)timeToTimestamp:(NSString *)timestamp
{
    if (!timestamp)
    {
        return @"";
    }    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
     NSDate *aTime = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    
    NSString *str=[dateFormatter stringFromDate:aTime];
    return str;
}


#pragma mark 数据更新
-(void)saveUserInfoToDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.userName        forKey:default_userName];
    [defaults setValue:self.userPwd         forKey:default_pwd];
    [defaults setValue:self.userLogo        forKey:default_userLogo];
    [defaults setValue:self.userId          forKey:default_userId];
    [defaults setValue:self.userToken       forKey:default_userToken];
    [defaults setValue:self.captchCode      forKey:default_captchCode];
    [defaults setValue:self.storeId         forKey:default_storeId];
    [defaults setValue:self.userAccount     forKey:default_userAccount];
    [defaults setValue:self.openStatus      forKey:default_openStatus];
    [defaults setValue:self.storeDic        forKey:default_storeDic];
    [defaults setValue:self.priviteKey      forKey:default_priviteKey];
    [defaults setValue:self.aiLiPayCountStr forKey:default_aliPayCount];
    [defaults setValue:self.UpdataTime      forKey:default_updateTime];
    [defaults synchronize];
}

-(void)readUserInfoFromDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self setUserPwd:        [defaults valueForKey:default_pwd]];
    [self setUserName:       [defaults valueForKey:default_userName]];
    [self setUserLogo:       [defaults valueForKey:default_userLogo]];
    [self setUserToken:      [defaults valueForKey:default_userToken]];
    [self setUserId:         [defaults valueForKey:default_userId]];
    [self setCaptchCode:     [defaults valueForKey:default_captchCode]];
    [self setStoreId:        [defaults valueForKey:default_storeId]];
    [self setUserAccount:    [defaults valueForKey:default_userAccount]];
    [self setOpenStatus:     [defaults valueForKey:default_openStatus]];
    [self setStoreDic:       [defaults valueForKey:default_storeDic]];
    [self setPriviteKey:     [defaults valueForKey:default_priviteKey]];
    [self setAiLiPayCountStr:[defaults valueForKey:default_aliPayCount]];
    [self setUpdataTime:     [defaults valueForKey:default_updateTime]];
}

-(void)clearUserInfoInDefault{
    //
    self.userId     =nil;
    self.userName   =nil;
    self.userPwd    =nil;
    self.userLogo   =nil;
    self.userToken  =nil;
    self.captchCode =nil;
    self.storeId    =nil;
    self.userAccount=nil;
    self.openStatus =nil;
    self.storeDic   =nil;
    self.priviteKey =nil;
    self.aiLiPayCountStr =nil;
    self.UpdataTime =nil;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //消除用户手势
    [defaults removeObjectForKey:default_pwd];
    [defaults removeObjectForKey:default_userLogo];
    [defaults removeObjectForKey:default_userName];
    [defaults removeObjectForKey:default_userId];
    [defaults removeObjectForKey:default_userToken];
    [defaults removeObjectForKey:default_captchCode];
    [defaults removeObjectForKey:default_storeId];
    [defaults removeObjectForKey:default_userAccount];
    [defaults removeObjectForKey:default_openStatus];
    [defaults removeObjectForKey:default_storeDic];
    [defaults removeObjectForKey:default_priviteKey];
    [defaults removeObjectForKey:default_aliPayCount];
    [defaults removeObjectForKey:default_updateTime];
    [defaults synchronize];
}


//获取当前时间
-(NSString*)GetNowTime
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
      [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}



//圆角或椭圆
-(void)viewLayerRound:(UIView *)view borderWidth:(float)width borderColor:(UIColor *)color{
    // 必須加上這一行，這樣圓角才會加在圖片的「外側」
    view.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    view.layer.cornerRadius =H(view)/ 35.0;
    //边框
    view.layer.borderWidth=width;
    view.layer.borderColor =[color CGColor];
}




//图片转Base64
-(NSString*)image2DataURL:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image,0.5);
    data = [data base64EncodedDataWithOptions:0];
    NSString *endStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return endStr;
}

//Base64转图片
-(NSData*)Data2Image:(NSString*)string
{
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return imageData;
}


-(NSString*)toBase64String:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUnicodeStringEncoding];
    data = [data base64EncodedDataWithOptions:0];
    NSString *endStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return endStr;
}

//字符串转Bas464
- (NSString *)base64Encode:(NSString *)plainText{
    
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainTextData base64EncodedStringWithOptions:0];
    return base64String;
}




-(NSString*)DayBeforeYesterday
{
    //设置时间
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //获取前天,使用日历类
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *Comps;
    Comps = [calendar components:(kCFCalendarUnitHour| kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:[[NSDate alloc] init]];
    [Comps setHour:-48]; //+24表示获取下一天的date，-24表示获取前一天的date；
    [Comps setMinute:0];
    [Comps setSecond:0];
    NSDate *nowDate = [calendar dateByAddingComponents:Comps toDate:[NSDate date] options:0];
    NSString *BeforeYesterday  = [[NSString stringWithFormat:@"%@",nowDate] substringWithRange:NSMakeRange(0, 10)];
    return BeforeYesterday;
}


-(NSString*)DayYesterday
{
    //设置时间
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //获取前天,使用日历类
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *Comps;
    Comps = [calendar components:(kCFCalendarUnitHour| kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:[[NSDate alloc] init]];
    [Comps setHour:-24]; //+24表示获取下一天的date，-24表示获取前一天的date；
    [Comps setMinute:0];
    [Comps setSecond:0];
    NSDate *nowDate = [calendar dateByAddingComponents:Comps toDate:[NSDate date] options:0];
    NSString *BeforeYesterday  = [[NSString stringWithFormat:@"%@",nowDate] substringWithRange:NSMakeRange(0, 10)];
    return BeforeYesterday;
}

//获取今天日期
-(NSString*)GetTodayDay{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayDate = [formatter stringFromDate:[NSDate date]];
    return todayDate;
}

//获取下一天
-(NSString*)DayNextDay{
    //设置时间
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //获取前天,使用日历类
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *Comps;
    Comps = [calendar components:(kCFCalendarUnitHour| kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:[[NSDate alloc] init]];
    [Comps setHour:+24]; //+24表示获取下一天的date，-24表示获取前一天的date；
    [Comps setMinute:0];
    [Comps setSecond:0];
    NSDate *nowDate = [calendar dateByAddingComponents:Comps toDate:[NSDate date] options:0];
    NSString *NextDay  = [[NSString stringWithFormat:@"%@",nowDate] substringWithRange:NSMakeRange(0, 10)];
    return NextDay;
}

-(NSString*)lastWeekDay{
    
    //设置时间
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //获取前天,使用日历类
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *Comps;
    Comps = [calendar components:(kCFCalendarUnitHour| kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:[[NSDate alloc] init]];
    [Comps setHour:-24*7]; //+24表示获取下一天的date，-24表示获取前一天的date；
    [Comps setMinute:0];
    [Comps setSecond:0];
    NSDate *nowDate = [calendar dateByAddingComponents:Comps toDate:[NSDate date] options:0];
    NSString *lastDay  = [[NSString stringWithFormat:@"%@",nowDate] substringWithRange:NSMakeRange(0, 10)];
    return lastDay;
}

//字符串转时间
-(NSDate*)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormater dateFromString:dateString];
    return date;
}


#pragma mark Hud
- (void)creatHUD{
    if (HUD) {
        [self hudWasHidden:HUD];
    }
    HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    HUD.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    HUD.delegate = nil;
    [HUD removeFromSuperview];
    HUD = nil;
}


-(void)showHud{
    [self creatHUD];
    HUD.labelText = @"请稍等";
    [HUD show:YES];
}


-(void)hideHud
{
    if (HUD){
        [HUD hide:YES];
    }
}

-(void)alertTitle:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self dismss:alert];
}


-(void)dismss:(UIAlertView*)alert{
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}




@end
