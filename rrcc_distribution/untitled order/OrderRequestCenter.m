//
//  OrderRequestCenter.m
//  rrcc_sj
//
//  Created by lawwilte on 7/23/15.
//  Copyright © 2015 ting liu. All rights reserved.
//

#import "OrderRequestCenter.h"
#import "Orders.h"
#import "CoreDateManager.h"
#import "LoginViewController.h"

@interface OrderRequestCenter(){
    NSString *StrStatus;
}
@end

@implementation OrderRequestCenter
-(void)MulitThread:(id)Object{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(GetOrderListRequest:) object:Object];
    NSOperationQueue *queue =[[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark 获得订单列表
-(void)GetOrderListRequest:(id)Object{
    StrStatus = [Object objectForJSONKey:@"status"];
    NSString *OrderListUrl = [NSString stringWithFormat:@"%@%@",BASEURL,DistributerOrderList];
    if (![[Utility Share] priviteKey]){
        return;
    }else{
        NSString *strUrl = [[RestHttpRequest SharHttpRequest] BackOrderListUrl:OrderListUrl InputResourceId:[[Utility Share] userId] Inputstatus:[Object objectForJSONKey:@"OrderStatus"] InputStartTime:[Object objectForJSONKey:@"StartTime"] InputEndTime:[Object objectForJSONKey:@"EndTime"] InputPayLoad:@""];
        
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString: strUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        [request setHTTPBody:nil];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation,id responseObject){
            NSDictionary *ResponseDic = responseObject;
            if ([[ResponseDic objectForJSONKey:@"Success"] isEqualToString:@"1"]){
                //获取更新后的时间，存入本地
                NSString *UpdateTime = [[Utility Share] GetNowTime];
                [[Utility Share] setUpdataTime:UpdateTime];
                [[Utility Share] saveUserInfoToDefault];
                [self insertOrdersInDb:[ResponseDic objectForJSONKey:@"CallInfo"]];
            }
            if ([[ResponseDic objectForJSONKey:@"ErrorCode"] isEqualToString:@"2002"]){
                [[Utility Share] alertTitle:@"密码错误,请重新登录!"];
                //清空用户数据
                [[Utility Share] clearUserInfoInDefault];
                [[CoreDateManager Share] deleteData];//清空数据库
                //进入登录
                LoginViewController*LoginView = [[LoginViewController alloc] init];
                XHBaseNavigationController *LoginNav = [[XHBaseNavigationController alloc] initWithRootViewController:LoginView];
                LoginNav.navigationBar.translucent = NO;
                [AppDelegate Share].window.rootViewController = LoginNav;
            }
        } failure:^(AFHTTPRequestOperation *  operation, NSError * error) {
            //如果存在错误
            if (error){
                [[Utility Share] alertTitle:[error localizedDescription]];
                NSNotification *notification = [NSNotification notificationWithName:@"NetWorkError" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }];
        [op start];
    }
  }


#pragma mark 操作CoreData

-(void)insertOrdersInDb:(NSMutableArray*)orderArray{

    NSMutableArray *SaveArray = [[NSMutableArray alloc] init];
    NSMutableArray *CodeArray = [self ReadAllArray];//订单号数组
    NSMutableArray *AllDataArray = [self ReadAllData];
    NSMutableArray *UnSaveArray = [[NSMutableArray alloc] init];//存放没有保存的数据
    for (NSMutableDictionary *orderEntity in orderArray){
        Orders *OrderInfo = [[Orders alloc] initWithDictionary:orderEntity];
        [SaveArray addObject:OrderInfo];
    }
    // 如果数据库里有数据
    if (SaveArray.count != 0){
        for (int  i = 0;i<SaveArray.count;i++){
            Orders *orderInfo = [SaveArray objectAtIndex:i];
            NSString *Code    = orderInfo.ordercode;
            NSString *Status  = orderInfo.status;
            //数据不存在,存入数据库,如果数据位新订单则存在数据库里,如果为新订单则发起本地通知
            if([CodeArray containsObject:Code] == NO){
                [UnSaveArray addObject:orderInfo];
            }
            //如果订单号存在数据库里
            if ([CodeArray containsObject:Code]){
                for (Orders *info in AllDataArray){
                    if ([Code isEqualToString:info.ordercode]&& [Status isEqualToString:info.status]== NO){
                        [[CoreDateManager Share] UpdateDate:orderInfo WithOrderCode:Code];
                    }
                }
            }
        }
        //如果数据不为空，则存入数据库
        if(UnSaveArray.count != 0){
            [[CoreDateManager Share] insertCoreData:UnSaveArray];
        }
    }
    //发起通知，更新界面
    if ([StrStatus isEqualToString:@"1"]){
        NSNotification *notification = [NSNotification notificationWithName:@"RefreshData" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else{
        NSNotification *synchronizeNot = [NSNotification notificationWithName:@"synchronize" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:synchronizeNot];
    }
}

#pragma 操作CoreData
-(void)UpdateObject:(NSMutableArray*)OrderArray{
    NSMutableArray *SaveArray = [[NSMutableArray alloc] init];
    NSMutableArray *CodeArray = [self ReadAllArray];//订单号数组
    NSMutableArray *AllDataArray = [self ReadAllData];
    NSMutableArray *UnSaveArray = [[NSMutableArray alloc] init];//存放没有保存的数据
    for (NSMutableDictionary *orderEntity in OrderArray){
    Orders *OrderInfo = [[Orders alloc] initWithDictionary:orderEntity];
    [SaveArray addObject:OrderInfo];
    }
    // 如果数据库里有数据
    if (SaveArray.count != 0){
        for (int  i = 0;i<SaveArray.count;i++){
            Orders *orderInfo = [SaveArray objectAtIndex:i];
            NSString *Code    = orderInfo.ordercode;
            NSString *Status  = orderInfo.status;
       //数据不存在,存入数据库,如果数据位新订单则存在数据库里,如果为新订单则发起本地通知
        if([CodeArray containsObject:Code] == NO){
            [UnSaveArray addObject:orderInfo];
            }
        //如果订单号存在数据库里
         if ([CodeArray containsObject:Code]){
            for (Orders *info in AllDataArray){
            if ([Code isEqualToString:info.ordercode]&& [Status isEqualToString:info.status]== NO){
                [[CoreDateManager Share] UpdateDate:orderInfo WithOrderCode:Code];
                }
              }
            }
        }
        //如果数据不为空，则存入数据库
         if(UnSaveArray.count != 0){
         [[CoreDateManager Share] insertCoreData:UnSaveArray];
        }
    }
    
    //发起通知，更新界面
    if ([StrStatus isEqualToString:@"1"]){
        NSNotification *notification = [NSNotification notificationWithName:@"RefreshData" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }else{
        NSNotification *synchronizeNot = [NSNotification notificationWithName:@"synchronize" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:synchronizeNot];
    }
}

//读取所有的OrderCode
-(NSMutableArray*)ReadAllArray{
    NSMutableArray *DBList = [[CoreDateManager Share] readAllOrders];
    NSMutableArray *CodeArray = [[NSMutableArray alloc] init];
    for (Orders *info  in DBList){
        [CodeArray addObject:info.ordercode];
    }
    return CodeArray;
}

-(NSMutableArray*)ReadAllData{
    NSMutableArray *AllDBArray = [[CoreDateManager Share] readAllOrders];
    return AllDBArray;
}

//读取数据库，获得最新的 UpdateTime 作为startTime
-(NSString*)startTime{
    
    NSString *lastWeekDay = [[[Utility Share] lastWeekDay]stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSMutableArray *AllDBArray = [[CoreDateManager Share] readAllOrders];
    NSMutableArray *updateTimeArray = [[NSMutableArray alloc] init];
    for (Orders *orderInfo in AllDBArray){
        //以防万一updateTime 为空
        if (orderInfo.updatetime){
            [updateTimeArray addObject:orderInfo.updatetime];
        }
        NSString *insertTime = [[orderInfo.inserttime substringWithRange:NSMakeRange(0, 10)] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([insertTime integerValue] < [lastWeekDay integerValue]){
            //删除一周以前的订单
            [[CoreDateManager Share] deleteLastWeekOrders:[orderInfo.inserttime substringWithRange:NSMakeRange(0, 10)]];
        }
    }
    NSArray *sortArray = [updateTimeArray sortedArrayUsingSelector:@selector(compare:)];
    NSString *updateTime = [sortArray lastObject];
    return updateTime;
}

//根据状态获取订单列表
-(void)GetOrderList:(NSString*)OrderStatus Status:(NSString*)status{
    //配置状态和开始结束时间
    if ([status isEqualToString:@"1"]){
        NSString *TimeStart;
        if (![[Utility Share] UpdataTime]){
            TimeStart = [[Utility Share] DayBeforeYesterday];
        }else{
            TimeStart = [self startTime];
        }
        NSString *TimeEnd  = [[Utility Share] GetNowTime];
        NSDictionary *RequestDic = [NSDictionary dictionaryWithObjectsAndKeys:OrderStatus,@"OrderStatus",TimeStart,@"StartTime",TimeEnd,@"EndTime",status,@"status",nil];
        [self MulitThread:RequestDic];
    }else{
        NSString *TimeStart= [[Utility Share] DayBeforeYesterday];
        NSString *TimeEnd  = [[Utility Share] GetNowTime];
        NSDictionary *RequestDic = [NSDictionary dictionaryWithObjectsAndKeys:OrderStatus,@"OrderStatus",TimeStart,@"StartTime",TimeEnd,@"EndTime",status,@"status",nil];
        [self MulitThread:RequestDic];
    }

}
@end
