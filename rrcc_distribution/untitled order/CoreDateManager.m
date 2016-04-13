//
//  CoreDateManager.m
//  rrcc_distribution
//
//  Created by lawwilte on 8/25/15.
//  Copyright (c) 2015 ting liu. All rights reserved.
//

#import "CoreDateManager.h"

@implementation CoreDateManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static const int ImportBatchSize = 250;


+(CoreDateManager*)Share{
    static CoreDateManager *instance = nil;
    @synchronized(self){
        if (!instance){
            instance = [[CoreDateManager alloc] init];
        }
    }
    return instance;
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Core Data Stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    _managedObjectContext.undoManager = nil;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:TableName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"OrderModel.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray{
    NSManagedObjectContext *context = [self newPrivateContext];
    [context performBlockAndWait:^{
        [self Import:dataArray WithConytext:context];
    }];
}



-(void)Import:(NSMutableArray*)dataArray WithConytext:(NSManagedObjectContext*)Context{
    
    __block NSInteger idx = -1;
    for (Orders *info in dataArray){
        idx++;
        Orders *ordersEntity = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:Context];
        ordersEntity.address =info.address;
        ordersEntity.confirmtime =info.confirmtime;
        ordersEntity.contact  =info.contact;
        ordersEntity.delivery =info.delivery;
        ordersEntity.deliverytime =info.deliverytime;
        ordersEntity.has_deliveried =info.has_deliveried;
        ordersEntity.has_dispatched =info.has_dispatched;
        ordersEntity.has_paid =info.has_paid;
        ordersEntity.orderId =info.orderId;
        ordersEntity.inserttime =info.inserttime;
        ordersEntity.ordercode  =info.ordercode;
        ordersEntity.payment  =info.payment;
        ordersEntity.remark  =info.remark;
        ordersEntity.status =info.status;
        ordersEntity.svtime =info.svtime;
        ordersEntity.tel   =info.tel;
        ordersEntity.updatetime = info.updatetime;
        if (idx % ImportBatchSize == 0){
            [Context save:NULL];
        }
    }
    [Context save:NULL];
}

//读取全部数据
-(NSMutableArray*)readAllOrders{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context reset];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:TableName];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort =  [NSSortDescriptor sortDescriptorWithKey:@"svtime" ascending:NO];
    
    fetchRequest.sortDescriptors =@[sort];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    for  (Orders *info in fetchedObjects){
        [resultArray addObject:info];
    }
    return resultArray;
}


//根据谓词查询
-(NSMutableArray*)FliterFromDb:(NSPredicate *)FetchPredicate{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context reset];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:TableName];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:FetchPredicate];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSSortDescriptor *sort2 =  [NSSortDescriptor sortDescriptorWithKey:@"ordercode" ascending:NO];
    fetchRequest.sortDescriptors =@[sort2];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultarray = [NSMutableArray array];
    for (Orders *info in fetchedObjects){
        [resultarray addObject: info];
    }
    return resultarray;
}


/*分页查询
 限定查询结果的数量
 setFetchLimit
 查询的偏移量
 setFetchOffset*/
-(NSMutableArray*)FliterFromDb:(int)pageSize andOffSet:(int)currentPage{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest  = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *fetchArray = [NSMutableArray array];
    for (Orders *info in fetchObjects){
        [fetchArray addObject:info];
    }
    return fetchArray;
}

//删除
-(void)deleteData{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count]){
        for (NSManagedObject *obj in datas){
            [context deleteObject:obj];
        }
        if (![context save:&error]){
            NSLog(@"error:%@",error);
        }
    }
}


-(void)deleteLastWeekOrders:(NSString*)lastWeekDay{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count]){
        for (NSManagedObject *obj in datas){
            [context deleteObject:obj];
        }
        if (![context save:&error]){
            NSLog(@"error:%@",error);
        }
    }
}

//更新
-(void)UpdateDate:(Orders *)Info WithOrderCode:(NSString *)OrderCode{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ordercode  like[cd] %@",OrderCode];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *DbArray = [context executeFetchRequest:request error:&error];
    for (Orders *DbInfo in DbArray){
        DbInfo.address        = Info.address;
        DbInfo.confirmtime    = Info.confirmtime;
        DbInfo.contact        = Info.contact;
        DbInfo.delivery       = Info.delivery;
        DbInfo.deliverytime   = Info.deliverytime;
        DbInfo.has_deliveried = Info.has_deliveried;
        DbInfo.has_dispatched = Info.has_dispatched;
        DbInfo.has_paid       = Info.has_paid;
        DbInfo.orderId        = Info.orderId;
        DbInfo.inserttime     = Info.inserttime;
        DbInfo.ordercode      = Info.ordercode;
        DbInfo.payment        = Info.payment;
        DbInfo.remark         = Info.remark;
        DbInfo.status         = Info.status;
        DbInfo.svtime         = Info.svtime;
        DbInfo.tel            = Info.tel;
        DbInfo.updatetime     = Info.updatetime;
    }
    if ([context save:&error]){
    //    DLog(@"更新成功");
    }
}

-(void)UpdateOrderInfo:(NSMutableDictionary *)Info WithOrderCode:(NSString *)OrderCode {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ordercode  like[cd] %@",OrderCode];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *DbArray = [context executeFetchRequest:request error:&error];
    for (Orders *DbInfo in DbArray){
        DbInfo.address        = [Info  objectForJSONKey:@"address"];
        DbInfo.confirmtime    = [Info  objectForJSONKey:@"confirmtime"];
        DbInfo.contact        = [Info  objectForJSONKey:@"contact"];
        DbInfo.delivery       = [Info  objectForJSONKey:@"delivery"];
        DbInfo.deliverytime   = [Info  objectForJSONKey:@"deliverytime"];
        DbInfo.has_deliveried = [Info  objectForJSONKey:@"has_deliveried"];
        DbInfo.has_dispatched = [Info  objectForJSONKey:@"has_dispatched"];
        DbInfo.has_paid       = [Info  objectForJSONKey:@"has_paid"];
        DbInfo.orderId        = [Info  objectForJSONKey:@"id"];
        DbInfo.inserttime     = [Info  objectForJSONKey:@"inserttime"];
        DbInfo.ordercode      = [Info  objectForJSONKey:@"ordercode"];
        DbInfo.payment        = [Info  objectForJSONKey:@"payment"];
        DbInfo.remark         = [Info  objectForJSONKey:@"remark"];
        DbInfo.status         = [Info  objectForJSONKey:@"status"];
        DbInfo.svtime         = [Info  objectForJSONKey:@"svtime"];
        DbInfo.tel            = [Info  objectForJSONKey:@"tel"];

    }
    if ([context save:&error]){
     //   DLog(@"更新成功");
    }
}

-(NSManagedObjectContext*)newPrivateContext{
    
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.undoManager = nil;
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return context;
    
}

@end
