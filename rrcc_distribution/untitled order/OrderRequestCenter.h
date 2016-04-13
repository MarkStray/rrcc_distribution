//
//  OrderRequestCenter.h
//  rrcc_sj
//
//  Created by lawwilte on 7/23/15.
//  Copyright © 2015 ting liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface OrderRequestCenter : NSObject
@property (strong,nonatomic) AVSpeechSynthesizer *Synthesizer;

//线程获取订单列表
-(void)MulitThread:(id)Object;
//根据状态获取订单列表
-(void)GetOrderList:(NSString*)OrderStatus Status:(NSString*)status;
//更新数据
-(void)UpdateObject:(NSMutableArray*)OrderArray;
@end
