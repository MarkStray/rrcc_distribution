//
//  CountTableViewCell.m
//  rrcc_distribution
//
//  Created by lawwilte on 9/9/15.
//  Copyright (c) 2015 ting liu. All rights reserved.
//

#import "CountTableViewCell.h"

@implementation CountTableViewCell
@synthesize indexLb,skuLb,specLb,countLb,supplierLb;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
       indexLb = [RHMethods labelWithFrame:CGRectMake(0,0,40,35) font:Font(13.0) color:[UIColor darkGrayColor] text:@""];
        indexLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:indexLb];
        
        skuLb = [RHMethods labelWithFrame:CGRectMake(XW(indexLb),0,120,35) font:Font(13.0) color:[UIColor darkGrayColor] text:@""];
        [self addSubview:skuLb];
        
        specLb =  [RHMethods labelWithFrame:CGRectMake(XW(skuLb),0,(kScreenWidth-120-40)/3, 35) font:Font(13.0) color:[UIColor darkGrayColor] text:@""];
        specLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:specLb];
        
        
        countLb = [RHMethods labelWithFrame:CGRectMake(XW(specLb),0,(kScreenWidth-120-40)/3,35) font:Font(13.0) color:[UIColor darkGrayColor] text:@""];
        countLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:countLb];

        
        supplierLb = [RHMethods labelWithFrame:CGRectMake(XW(countLb),0,(kScreenWidth-120-40)/3, 35) font:Font(13.0) color:[UIColor darkGrayColor] text:@""];
        [self addSubview:supplierLb];

    }
    return self;
}

- (void)awakeFromNib {
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
