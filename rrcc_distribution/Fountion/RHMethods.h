//
//  RHMethods.h
//  rrcc_sj
//
//  Created by lawwilte on 15-5-20.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Foundation.h"


@interface RHMethods : NSObject
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext;
+(UIButton*)buttonWithFrame:(CGRect)_frame title:(NSString*)_title  image:(NSString*)_image bgimage:(NSString*)_bgimage;
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image;
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h;


@end
