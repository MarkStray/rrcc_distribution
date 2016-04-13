


#define URL_serverUrl  @""
//#define URL_serverUrl  @"http://api.test.renrencaichang.com/Service.php"
//#define URL_serverUrl  @"http://api.dev.renrencaichang.com/Service.php"

#define URL_getServerUrl(url) [NSString stringWithFormat:@"%@%@",URL_serverUrl,url]

#define URL_imageUrl @"http://api.test.renrencaichang.com/" //本地调试
#define URL_getImageUrl(url) [NSString stringWithFormat:@"%@%@",URL_imageUrl,url]

//#define DEBUG 1
//#ifdef DEBUG
//#define trace(format,...) NSLog(format,##__VA_ARGS__)
//#else
//#define trace(format,...)
//#endif

//#define DEBUG 1
//#ifdef DEBUG
//#define track() NSLog(@"%s",__FUNCTION__)
//#else
//#define track()
//#endif


#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//提示文字

#define tip_noInfo @"网络异常,请稍后重试"
#define tip_noNet @"没发现网络"
#define tip_getData(num) [NSString stringWithFormat:@"发现%d条更新",num]
#define messageSplitStr @"_*#_"


//是否是iphone5
//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height>960 : NO)
#define isRetina ([UIScreen mainScreen].scale>1.0)
//判断系统是否是iOS7
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

#define kDeviceWidth                [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight               [UIScreen mainScreen].bounds.size.height


//每次获取列表数目
#define EE_TableRefreshNum 20
#define EE_TableProFirstNum 100
#define EE_TableProNum 21


#define EE_TableRefreshHistory [NSString stringWithFormat:@"%@/Library/Caches/refresh_history.plist",NSHomeDirectory()]
#define EE_Version_Path [NSString stringWithFormat:@"%@/Library/Caches/version.plist",NSHomeDirectory()]
#define is_iPhone5                  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_5                 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)

#define ee_AppSize [[UIScreen mainScreen] bounds].size




//友盟
//#define UmengAppkey @"5346609a56240b74b200001d"
#define UmengAppkey @"5360c40d56240bd7f7025568"
//默认城市
#define DefaultCity @"北京"

//刷歌词时间间隔
#define timeGap (iPhone5?0.1:0.2)

#define ee_AppStatusHeight ( ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? 0.0 : 20.0 )
#define ee_AppDetailControllerHeight 44
#define TopMenuHeight 35
#define ee_TabVcY (ee_AppDetailControllerHeight+TopMenuHeight)
#define ee_TabVcHeight (ee_AppSize.height-ee_AppStatusHeight-ee_AppDetailControllerHeight-ee_AppDetailControllerHeight)
#define ee_CellLeftSpace 5
#define ee_DetailTitleHeight 100

#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#pragma mark - 颜色值

#define color_noraml_blue         0x3375b8
#define color_noraml_black         0x121212
#define color_noraml_white         0xffffff
#define color_noraml_gray         0x808080

#define color_all_blue              0x3375b8

#define color_content_title_gray    0x212121
#define color_content_summry_black  0x9f9f9f
#define color_content_head_gray     0x808080

#define color_leftmenu_title 0xdcdcdc
#define color_leftmenu_tag 0x868686

#define color_info_blue 0x346997

#define color_pageControl_circle 0x4F494C;

#if DEBUG
#define MCRelease(x) [x release]
#else
#define MCRelease(x) [x release], x = nil
#endif

#define SafeClearRequest(request)\
if(request!=nil)\
{\
[request clearDelegatesAndCancel];\
[request release];\
request=nil;\
}\

#define Sns_mobile @"mobile"
#define Sns_mail @"mail"

#define EE_JsonDetailFilePath [NSString stringWithFormat:@"%@/Library/Caches/detail",NSHomeDirectory()]
#define EE_APP_Types_Path [[NSBundle mainBundle] pathForResource:@"config_app_modal_types" ofType:@"plist"]
#define EE_APP_Menu_Path [NSString stringWithFormat:@"%@/Library/Caches/config_app_menu.plist",NSHomeDirectory()]

#define EE_APP_Infor_Path [NSString stringWithFormat:@"%@/Library/Caches/config_appinfor.plist",NSHomeDirectory()]
#define EE_APP_UserWebInfo_Path [NSString stringWithFormat:@"%@/Library/Caches/userWebInfo.plist",NSHomeDirectory()]
#define EE_APP_ActivityList_Path [NSString stringWithFormat:@"%@/Library/Caches/activityList.plist",NSHomeDirectory()]
#define EE_APP_IndustryMenu_Path [NSString stringWithFormat:@"%@/Library/Caches/industryMenu.plist",NSHomeDirectory()]
#define EE_APP_ListIndustry_Path(ss) [NSString stringWithFormat:@"%@/Library/Caches/List%@Industry.plist",NSHomeDirectory(),ss]


/*****************************************
 weakSelf
 *****************************************/

#define WeakSelf __weak typeof(self) weakSelf = self;

#define defaultImgIcon [UIImage imageNamed:@"MeIcon.png"]
#define defaultImgAvatar [UIImage imageNamed:@"icon-avatar-60x60"]

//----------------------图片----------------------------
//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]
//清除背景色
#define CLEARCOLOR [UIColor clearColor]













