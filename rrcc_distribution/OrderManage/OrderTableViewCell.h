//
//  OrderTableViewCell.h
//  rrcc_sj
//
//  Created by lawwilte on 15-5-20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Orders.h"

@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *CellBackView;
@property (weak, nonatomic) IBOutlet UIImageView *StatusImg;//状态图
@property (weak, nonatomic) IBOutlet UIImageView *PayStatusImg;//支付状态
@property (weak, nonatomic) IBOutlet UILabel *OrderCodeLb;//订单号
@property (weak, nonatomic) IBOutlet UILabel *OrderStatusLb;//订单状态
@property (weak, nonatomic) IBOutlet UILabel *SvStyleLb;//配送方式
@property (weak, nonatomic) IBOutlet UILabel *SvAddressLb;//配送小区
@property (weak, nonatomic) IBOutlet UILabel *SvTimeLb;//配送时间
@end
