//
//  StatisTableViewCell.m
//  rrcc_distribution
//
//  Created by lawwilte on 9/17/15.
//  Copyright (c) 2015 ting liu. All rights reserved.
//

#import "StatisTableViewCell.h"

@implementation StatisTableViewCell

@synthesize TotalLb,AmountLb,NetLb;

- (void)awakeFromNib {
    // Initialization code
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        TotalLb = [RHMethods labelWithFrame:CGRectMake(0, 0, kScreenWidth/3, 35) font:Font(13.0f) color:[UIColor darkGrayColor] text:@""];
        TotalLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:TotalLb];
        
        AmountLb = [RHMethods labelWithFrame:CGRectMake(XW(TotalLb), 0, kScreenWidth/3, 35) font:Font(13.0f) color:[UIColor darkGrayColor] text:@""];
        AmountLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:AmountLb];

        NetLb  = [RHMethods labelWithFrame:CGRectMake(XW(AmountLb),0, kScreenWidth/3,35) font:Font(13.0f) color:[UIColor darkGrayColor] text:@""];
        NetLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:NetLb];
    
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
