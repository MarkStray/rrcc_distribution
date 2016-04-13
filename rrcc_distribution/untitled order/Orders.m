//
//  Orders.m
//  rrcc_sj
//
//  Created by lawwilte on 15/7/15.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import "Orders.h"

@implementation Orders

-(id)initWithDictionary:(NSMutableDictionary *)dictionary{
    self = [super init];
    if (self){
        self.address = [dictionary objectForJSONKey:@"address"];
        self.confirmtime = [dictionary objectForJSONKey:@"confirmtime"];
        self.contact = [dictionary objectForJSONKey:@"contact"];
        self.delivery = [dictionary objectForJSONKey:@"delivery"] ;
        self.deliverytime = [dictionary objectForJSONKey:@"deliverytime"];
        self.has_deliveried = [dictionary objectForJSONKey:@"has_deliveried"] ;
        self.has_dispatched = [dictionary objectForJSONKey:@"has_dispatched"] ;
        self.has_paid = [dictionary objectForJSONKey:@"has_paid"] ;
        self.orderId = [dictionary objectForJSONKey:@"id"] ;
        self.inserttime = [dictionary objectForJSONKey:@"inserttime"];
        self.ordercode = [dictionary objectForJSONKey:@"ordercode"];
        self.payment = [dictionary objectForJSONKey:@"payment"];
        self.remark = [dictionary objectForJSONKey:@"remark"];
        self.status = [dictionary objectForJSONKey:@"status"];
        self.svtime = [dictionary objectForJSONKey:@"svtime"];
        self.tel = [dictionary objectForJSONKey:@"tel"];
        self.updatetime = [dictionary objectForJSONKey:@"updatetime"];
    }
    return self;
}

@end
