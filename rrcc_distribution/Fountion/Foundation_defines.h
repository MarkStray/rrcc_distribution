//
//  NSObject_system.h
//  AFDFramework
//
//  Created by thomas on 13-7-9.
//  Copyright (c) 2013年 thomas. All rights reserved.
//

#ifdef _foundation_defines
#else
#ifdef DEBUG
//#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
//#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
//#   define DLog(...)
//#   define ELog(err)
#endif

#define docPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define docDataPath [docPath stringByAppendingPathComponent:@"data.db"]
//#define docDataInfoPath [docPath stringByAppendingPathComponent:@"Data/info"]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]



//判断系统是否是iOS7
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kApplicationFrameHeight [UIScreen mainScreen].applicationFrame.size.height


#define W(obj)   (!obj?0:(obj).frame.size.width)
#define H(obj)   (!obj?0:(obj).frame.size.height)
#define X(obj)   (!obj?0:(obj).frame.origin.x)
#define Y(obj)   (!obj?0:(obj).frame.origin.y)
#define XW(obj) X(obj)+W(obj)
#define YH(obj) Y(obj)+H(obj)
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]
#define Font(x) [UIFont systemFontOfSize:x]

#define CGRectMakeXY(x,y,size) CGRectMake(x,y,size.width,size.height)
#define CGRectMakeWH(origin,w,h) CGRectMake(origin.x,origin.y,w,h)

#define S2N(x) [NSNumber numberWithInt:[x intValue]]
#define I2N(x) [NSNumber numberWithInt:x]
#define F2N(x) [NSNumber numberWithFloat:x]

#define ee_AppSize [[UIScreen mainScreen] bounds].size

#endif