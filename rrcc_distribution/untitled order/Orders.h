//
//  Orders.h
//  rrcc_sj
//
//  Created by lawwilte on 15/7/15.
//  Copyright © 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Orders : NSObject
@property (strong,nonatomic) NSString *address;//地址
@property (strong,nonatomic) NSString *confirmtime;
@property (strong,nonatomic) NSString *contact;
@property (strong,nonatomic) NSString *delivery;
@property (strong,nonatomic) NSString *deliverytime;
@property (strong,nonatomic) NSString *has_deliveried;
@property (strong,nonatomic) NSString *has_dispatched;
@property (strong,nonatomic) NSString *has_paid;
@property (strong,nonatomic) NSString *orderId;
@property (strong,nonatomic) NSString *inserttime;
@property (strong,nonatomic) NSString *ordercode;
@property (strong,nonatomic) NSString *payment;
@property (strong,nonatomic) NSString *remark;
@property (strong,nonatomic) NSString *status;
@property (strong,nonatomic) NSString *svtime;
@property (strong,nonatomic) NSString *tel;
@property (strong,nonatomic) NSString *updatetime;
 
-(id)initWithDictionary:(NSMutableDictionary*)dictionary;
@end
