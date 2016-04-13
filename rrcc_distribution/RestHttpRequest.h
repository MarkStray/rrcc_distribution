//
//  RestHttpRequest.h
//  rrcc_sj
//
//  Created by lawwilte on 15-5-28.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestHttpRequest : NSObject
+(RestHttpRequest*)SharHttpRequest;

//返回公钥
-(NSString*) PayLoadStr:(NSString *)PayLoad;
//返回HttpBody
-(NSString*) GetHttpBody:(NSString*)Parametr;

//根据资源ID 返回公钥
-(NSString*)GetResouIdstr:(NSString*)Resource GetPayLoad:(NSString*)PayLoad;

//传入URl 和ResourceId 和payLoad 返回一个拼接好的URl
-(NSString*)AppendPublickKey:(NSString*)BaseUrl InputResourceId:(NSString *)ResourceId InputPayLoad:(NSString *)PayLoad;

-(NSString*)ApendPubkey:(NSString*)ResourceUrl InputResourceId:(NSString*)ResourceId InputPayLoad:
(NSString*)PayLoad;

-(NSString*)LoginPubKey:(NSString*)ResourceUrl InputResourceId:(NSString*)ResourceId InputPayLoad:
(NSString*)PayLoad InPutPwd:(NSString*)Pwd;

//返回店铺订单列表Url
-(NSString*)BackOrderListUrl:(NSString*)BaseUrl InputResourceId:(NSString*)ResourceId Inputstatus:(NSString*)Status InputStartTime:(NSString*)StartTime InputEndTime:(NSString*)EndTime InputPayLoad:(NSString*)PayLoad;

@end
