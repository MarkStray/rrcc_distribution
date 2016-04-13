//
//  OrderDetailViewController.h
//  rrcc_sj
//
//  Created by lawwilte on 15-5-21.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Orders.h"

@interface OrderDetailViewController : XHBaseViewController
@property (strong,nonatomic) NSString *OrderId;
@property (strong,nonatomic) NSString *OrderTel;
@property (strong,nonatomic) NSString *OrderCode;
@property (strong,nonatomic) NSString *OrderRemark;
@property (strong,nonatomic) NSString *OrderAdress;
@end
