//
//  RestHttpRequest.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-28.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "RestHttpRequest.h"

@implementation RestHttpRequest

+(RestHttpRequest*)SharHttpRequest{
    static RestHttpRequest *instance = nil;
    @synchronized(self){
        if (!instance){
            instance = [[RestHttpRequest alloc] init];
        }
    }
    return instance;
}


//获取PublicKey
-(NSString*) PayLoadStr:(NSString *)PayLoad{
    //完成注册之前，私钥是密码的MD5值
    //登录时的私钥是密码的MD5值
    NSString *Privitestr = [[Utility Share] userPwd].md5;
    //ResourcdId 是用户登录后返回的UserId;
    NSString *ResourceStr = [[Utility Share] userId];
    //TimeStamp 是现在的时间戳
    NSString *TimeStr   = [[Utility Share] GetUnixTime];
    //payLoad 是 用户传递的参数取base64
    NSString *PayLoadStr = [[Utility Share] base64Encode:PayLoad];
    //最后获得的公钥是 字符串拼接后取md5;
    NSString *EndStr  = [NSString stringWithFormat:@"%@%@%@%@",Privitestr,ResourceStr,TimeStr,PayLoadStr].md5;
    return EndStr;
}

-(NSString*)GetResouIdstr:(NSString*)Resource GetPayLoad:(NSString*)PayLoad{
    NSString *PriviteStr  = [[Utility Share]userPwd].md5;
    NSString *resourceStr = Resource;
    NSString *timeStr   = [[Utility Share] GetUnixTime];
    NSString *PayLoadStr = [[Utility Share] base64Encode:PayLoad];
    NSString *publick = [NSString stringWithFormat:@"%@%@%@%@",PriviteStr,resourceStr,timeStr,PayLoadStr].md5;
    return publick;
}


-(NSString*)AppendPublickKey:(NSString *)BaseUrl  InputResourceId:(NSString *)ResourceId InputPayLoad:(NSString *)PayLoad{
    NSString *priviteKeyStr =[[Utility Share] userPwd].md5;
    NSString *resourceStr   =ResourceId;
    NSString *TimeStamp     =[[Utility Share] GetUnixTime];
    NSString *PayloadStr    =PayLoad;
    NSString *PublicKey     =[NSString stringWithFormat:@"%@%@%@%@",priviteKeyStr,resourceStr,TimeStamp,PayloadStr].md5;
    NSString *UrlStr        =[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",BaseUrl,resourceStr,@"?",@"uid=",[[Utility Share] userId],@"&t=",TimeStamp,@"&k=",PublicKey];
    return UrlStr;
}

-(NSString*)ApendPubkey:(NSString *)ResourceUrl InputResourceId:(NSString *)ResourceId InputPayLoad:(NSString *)PayLoad{
    NSString *URLStr;
    NSString *priviteKeyStr =[[Utility Share] userPwd].md5;
    NSString *TimeStamp     =[[Utility Share] GetUnixTime];
    NSString *PublicKey     =[NSString stringWithFormat:@"%@%@%@%@",priviteKeyStr,ResourceId,TimeStamp,PayLoad].md5;
    URLStr = [NSString stringWithFormat:@"%@%@%@%@%@",ResourceUrl,@"&t=",TimeStamp,@"&k=",PublicKey];
    return URLStr;
}

-(NSString*)LoginPubKey:(NSString*)ResourceUrl  InputResourceId:(NSString*)ResourceId InputPayLoad:
(NSString*)PayLoad InPutPwd:(NSString*)Pwd{
    
    NSString *URLStr;
    NSString *priviteKeyStr =Pwd.md5;
    NSString *TimeStamp     =[[Utility Share] GetUnixTime];
    NSString *PublicKey     =[NSString stringWithFormat:@"%@%@%@%@",priviteKeyStr,ResourceId,TimeStamp,PayLoad].md5;
    URLStr = [NSString stringWithFormat:@"%@%@%@%@%@",ResourceUrl,@"&t=",TimeStamp,@"&k=",PublicKey];
    return URLStr;
}


-(NSString*)BackOrderListUrl:(NSString *)BaseUrl InputResourceId:(NSString *)ResourceId Inputstatus:(NSString *)Status InputStartTime:(NSString *)StartTime InputEndTime:(NSString *)EndTime InputPayLoad:(NSString *)PayLoad
{
    
    NSString *privitekey =[[Utility Share]userPwd].md5;
    NSString *timestr    =[[Utility Share] GetUnixTime];
    NSString *PublicKey  =[NSString stringWithFormat:@"%@%@%@",privitekey,ResourceId,timestr].md5;
    
    NSString *UrlStr   = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",BaseUrl,ResourceId,@"?",@"uid=",[[Utility Share] userId],@"&status=",Status,@"&start=",StartTime,@"&end=",EndTime,@"&o=0",@"&l=1000",@"&t=",timestr,@"&k=",PublicKey];
    return UrlStr;
}

//返回Http Body
-(NSString*)GetHttpBody:(NSString *)Parametr
{
    NSString *bodyStr = [NSString stringWithFormat:@"%@%@",@"payload=",Parametr];
   // DLog(@"body Str 是%@",bodyStr);
    return bodyStr;
}


@end
