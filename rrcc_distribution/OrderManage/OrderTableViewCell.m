//
//  OrderTableViewCell.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderTableViewCell.h"
@implementation OrderTableViewCell


- (void)awakeFromNib{
     // Initialization code
    _CellBackView.layer.borderWidth  = 1;
    _CellBackView.layer.cornerRadius = 2;
    _CellBackView.backgroundColor    = [UIColor whiteColor];
    _CellBackView.frame = CGRectMake(10, 0, kScreenWidth-20, 95);
    _CellBackView.layer.borderColor  = [[UIColor lightGrayColor] CGColor];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}
@end
