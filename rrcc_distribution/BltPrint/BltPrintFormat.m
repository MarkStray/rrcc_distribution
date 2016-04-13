//
//  BltPrintFormat.m
//  rrcc_sj
//
//  Created by lawwilte on 7/9/15.
//  Copyright (c) 2015 ting liu. All rights reserved.
//

#import "BltPrintFormat.h"
#import "BleManager.h"

/** 打印纸一行最大的字节
 *
 */
//订单详情
static int LINE_TOTAL_SIZE  = 32;//打印纸的字符长度为32
static int LEFT_BYTE_SIZE   = 15;//左边最大的字符 //9个字符
static int RIGHT_BYTE_SIZE  = 7; //右边最大字符//9个字节
//订单列表的字节
static int SKU_SIZE = 24;
static int COUNT_SIZE = 3;
static int SUPPLIE_SIZE = 8;
static int SPEC_SIZE = 17;



@implementation BltPrintFormat
@synthesize ConnectPhera,ConnectState,ConnectPerpheras;

-(id)init{
    if (self = [super init]){
        
        
    }
    return self;
}
//单例
+(BltPrintFormat*)ShareBLTPrint{
    static BltPrintFormat *instance = nil;
    @synchronized(self){
        if (!instance){
            instance = [[BltPrintFormat alloc] init];
        }
    }
    return instance;
}

#pragma mark  标题居中对齐
-(NSString*)PrintTitleInCenter:(NSString *)Title{
    EndPrintString = @"";
    for(int i=0;i<(LINE_TOTAL_SIZE - [[BltPrintFormat ShareBLTPrint] GetStringBytesLenth:Title])/2;i++){
        EndPrintString = [EndPrintString stringByAppendingString:@" "];
    }
    EndPrintString = [EndPrintString stringByAppendingString:Title];
    return EndPrintString;
}

-(NSString*)AppendNames:(NSMutableArray *)NameList Nums:(NSMutableArray *)NumList Prices:(NSMutableArray *)Prices Weight:(NSMutableArray*)Weights{
    NSString *OrderInfoStr;
    NSString *NameStr;
    NSString *NumStr;
    NSString *PriceStr;
    NSString *WeightStr;
    int NumWeightLenth;
    int numPrefixLenth;
    int pricePrefixLenth;
    
    NSMutableArray *Array = [[NSMutableArray alloc]init];
    for (int i=0;i<NameList.count;i++){
        NameStr  = [NameList objectAtIndex:i];
        NumStr   = [NumList  objectAtIndex:i];
        PriceStr = [Prices   objectAtIndex:i];
        WeightStr= [Weights  objectAtIndex:i];
        //去除字符串里的空格
        NameStr  = [NameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        numPrefixLenth   = [self GetStringBytesLenth:NumStr];
        pricePrefixLenth = [self GetStringBytesLenth:PriceStr];
        
        NSString *SerialNumber = [NSString stringWithFormat:@"%d%@",i+1,@"."];
        NSString *NumWeightStr = [NSString stringWithFormat:@"%@%@%@%@",@"  ",WeightStr,@"克/份x",NumStr];//数量重量
        NSString *CenterStr    = @" 小计:";
        NumWeightLenth  = [self GetStringBytesLenth:NumWeightStr];
        for (int i=0;i<LEFT_BYTE_SIZE-NumWeightLenth;i++){
            NumWeightStr   =[NumWeightStr stringByAppendingString:@" "];
        }
        NSString *numPrice = [NSString stringWithFormat:@"%.2f",[NumStr floatValue]*[PriceStr floatValue]];
        for (int i=0;i<RIGHT_BYTE_SIZE-pricePrefixLenth;i++){
            EndPrintString = @" ";
            numPrice = [EndPrintString stringByAppendingString:numPrice];
        }
        NSString *ItemInfo = [NSString stringWithFormat:@"%@%@\n%@%@%@%@\n",SerialNumber,NameStr,NumWeightStr,CenterStr,numPrice,@"元"];
        OrderInfoStr = [NSString stringWithFormat:@"%@",ItemInfo];
        [Array addObject:OrderInfoStr];
    }
    NSString *Str = [Array componentsJoinedByString:@""];
    return Str;
}

-(NSString*)AppendOrders:(NSDictionary *)orderDic{
    
    int skuNameLenth;
    int countLenth;
    int specLenth;
    int supplierLenth;
    NSMutableArray *Array  = [orderDic objectForJSONKey:@"CallInfo"] ;
    NSMutableArray *PrintArray = [[NSMutableArray alloc] init];
    NSString *spaceStr = @"    ";
    for (int i = 0;i<Array.count;i++){
        NSString *indexStr = [NSString stringWithFormat:@"%d%@",i+1,@"."];
        NSString *skuStr = [NSString stringWithFormat:@"%@",[[Array objectAtIndex:i] objectForJSONKey:@"skuname"]];
        NSString *specStr = [NSString stringWithFormat:@"%@",[[Array objectAtIndex:i] objectForJSONKey:@"spec"]];
        if (skuStr.length >12){
            skuStr = [skuStr substringToIndex:12];
        }
        if (specStr.length >9){
            specStr = [specStr substringToIndex:9];
        }
        NSString *countStr = [NSString stringWithFormat:@"%@",[[Array objectAtIndex:i] objectForJSONKey:@"count"]];
        NSString *supplierStr = [NSString stringWithFormat:@"%@",[[Array objectAtIndex:i] objectForJSONKey:@"supplier"]];
        if ([supplierStr isEqualToString:@"(null)"]){
            supplierStr = @"--------";
        }
        skuNameLenth = [self GetStringBytesLenth:skuStr];
        countLenth   = [self GetStringBytesLenth:countStr];
        specLenth    = [self GetStringBytesLenth:specStr];
        supplierLenth= [self GetStringBytesLenth:supplierStr];
        for (int i = 0;i<SKU_SIZE - skuNameLenth;i++){
            skuStr = [skuStr stringByAppendingString:@" "];
        }
        for (int i = 0;i<COUNT_SIZE - countLenth;i++){
            countStr = [countStr stringByAppendingString:@" "];
        }
        for (int i = 0;i<SPEC_SIZE - specLenth;i++){
            specStr = [specStr stringByAppendingString:@" "];
        }
        for (int i = 0;i<SUPPLIE_SIZE-supplierLenth;i++){
            supplierStr = [supplierStr stringByAppendingString:@" "];
        }
        NSString *orderStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",indexStr,@" ",skuStr,@" ",countStr,spaceStr,specStr,@" ",supplierStr,@"\n"];
        [PrintArray addObject:orderStr];
    }
    NSString *printStr = [PrintArray componentsJoinedByString:@""];
    return printStr;
}


/**
 * 获取字符串字节长度
 * @param string
 * @return sting
*/
-(int)GetStringBytesLenth:(NSString *)strtemp{
    int strlenth = 0;
    char *p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];i++){
        if (*p){
            p++;
            strlenth++;
        }else{
            p++;
        }
    }
    return strlenth;
}





@end
