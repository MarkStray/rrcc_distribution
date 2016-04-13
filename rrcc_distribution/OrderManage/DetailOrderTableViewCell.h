//
//  DetailOrderTableViewCell.h
//  rrcc_sj
//
//  Created by lawwilte on 15-6-10.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ItemImgView;//图片
@property (weak, nonatomic) IBOutlet UILabel *ItemNameLb;//名字
@property (weak, nonatomic) IBOutlet UIView *CellBackView;
@property (weak, nonatomic) IBOutlet UILabel *ItemRuleLb;//规格
@property (weak, nonatomic) IBOutlet UILabel *PriceLb;//价格
@property (weak, nonatomic) IBOutlet UILabel *OrderCountLb;//订单数量
@end
