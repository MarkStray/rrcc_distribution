//
//  CoreDateManager.h
//  rrcc_distribution
//
//  Created by lawwilte on 8/25/15.
//  Copyright (c) 2015 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Orders.h"
#define TableName @"OrderModel"

@interface CoreDateManager : NSObject

+(CoreDateManager*)Share;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//CoreData 方法
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray;
//删除
- (void)deleteData;
//删除上周的订单
-(void)deleteLastWeekOrders:(NSString*)lastWeekDay;
//根据OrderCode 更新
-(void)UpdateDate:(Orders*)Info WithOrderCode:(NSString*)OrderCode;
-(void)UpdateOrderInfo:(NSMutableDictionary *)Info WithOrderCode:(NSString *)OrderCode;
//分页查询
-(NSMutableArray*)FliterFromDb:(int)pageSize andOffSet:(int)currentPage;
//读取全部数据
-(NSMutableArray*)readAllOrders;
//根据谓词查询
-(NSMutableArray*)FliterFromDb:(NSPredicate*)FetchPredicate;
@end
