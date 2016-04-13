//
//  StoreViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-21.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "StoreViewController.h"
#import "ChangPwdViewController.h"
#import "OrderCountViewController.h"
#import "BltPrintFormat.h"
#import "OrderRequestCenter.h"
#import "LoginViewController.h"
#import "CoreDateManager.h"
#import "StatisViewController.h"
#import "BLEViewController.h"


@interface StoreViewController (){
    NSMutableArray *ImgsArray;
    NSMutableArray *NamesArray;
    NSMutableDictionary *StoresDic;
    NSMutableDictionary *MyDic;
    NSMutableDictionary *InfoDic;
    NSMutableArray   *InfoArray;
    NSString         *IsOpenStr;
    OrderRequestCenter *orderRequest;//订单请求

}
@property (weak, nonatomic)   IBOutlet   UITableView *StoreMaagetable;
@property (strong,nonatomic)  UISwitch   *SwitchView;
@end

@implementation StoreViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[Utility Share] readUserInfoFromDefault];
    InfoDic = [[Utility Share]storeDic];
    [_StoreMaagetable reloadData];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"店铺管理";
    ImgsArray  = [[NSMutableArray alloc] initWithObjects:@"Pwd",@"syn",@"Blt",@"supply",@"key",@"supply",nil];
    NamesArray = [[NSMutableArray alloc] initWithObjects:@"修改密码",@"手动同步订单",@"蓝牙打印机",@"配货清单",@"账号注销",@"订单统计",nil];
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_StoreMaagetable setTableFooterView:view];
    orderRequest    = [[OrderRequestCenter alloc] init];
    //注册通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(synchronizeDate:)
                          name:@"synchronize"
                        object:nil];
}

#pragma mark UITableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NamesArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    static NSString *Identifier = @"Identifier";
    UITableViewCell *StoreCell  = [tableView dequeueReusableCellWithIdentifier:Identifier];
    //在复用里，初始化 控件，再在外面赋值
    if (StoreCell == nil){
        
        StoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
        StoreCell.textLabel.font = Font(15.0f);
        StoreCell.detailTextLabel.font = Font(13.0f);
        StoreCell.textLabel.textColor = [UIColor darkGrayColor];
        StoreCell.detailTextLabel.textColor = [UIColor darkGrayColor];
        StoreCell.textLabel.text = [NamesArray objectAtIndex:index];
    }
    //配置Icon 和标题
    StoreCell.imageView.image = [UIImage imageNamed:[ImgsArray objectAtIndex:indexPath.row]];
    if (index == 2){
        if ([[BltPrintFormat ShareBLTPrint].ConnectState  isEqualToString:@"1"]){
            StoreCell.detailTextLabel.text = @"蓝牙打印机已连接";
        }else{
             StoreCell.detailTextLabel.text = @"蓝牙打印机未连接";
        }
    }
    if (index == 1){
        StoreCell.detailTextLabel.text = @"手动同步最近三天订单";
        StoreCell.accessoryType  = UITableViewCellAccessoryNone;
    }else if (index == 4){
        StoreCell.accessoryType  = UITableViewCellAccessoryNone;
    }else{
        StoreCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    StoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return StoreCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    ChangPwdViewController *ChangePwdView = [[ChangPwdViewController alloc]init];
    OrderCountViewController *orderCountView = [[OrderCountViewController alloc] init];
    StatisViewController  *statisView = [[StatisViewController alloc] init];
    BLEViewController *bleView = [[BLEViewController alloc] init];
    switch (index){
        case 0:
            [self pushNewViewController:ChangePwdView];
            break;
         case 1:
            [[Utility Share] showHud];
            [orderRequest GetOrderList:@"-10" Status:@"2"];
            break;
         case 2:
            [self pushNewViewController:bleView];
            break;
        case 3:
            [self pushNewViewController:orderCountView];
            break;
        case 4:
            [self Logot];
            break;
        case 5:
            [self pushNewViewController:statisView];
            break;
        default:
            break;
    }
}

-(void)synchronizeDate:(NSNotification*)notification{
    [[Utility Share] alertTitle:@"订单同步成功!"];
    [[Utility Share] hideHud];
}

#pragma mark 注销账号
-(void)Logot{
    UIAlertView *LogoAlert = [[UIAlertView alloc] initWithTitle:@"是否注销此账号,并重新登录!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [LogoAlert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        //清空用户数据
        [[Utility Share] clearUserInfoInDefault];
        [[Utility Share] saveUserInfoToDefault];
        [[CoreDateManager Share] deleteData];//清空数据库
        //进入登录
        LoginViewController*LoginView = [[LoginViewController alloc] init];
        XHBaseNavigationController *LoginNav = [[XHBaseNavigationController alloc] initWithRootViewController:LoginView];
        LoginNav.navigationBar.translucent = NO;
        [AppDelegate Share].window.rootViewController = LoginNav;
    }
}

//移除通知
- (void)RemoveAllNotifications{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:@"synchronizeDate"
                           object:nil];
}

-(void)dealloc{
    [self RemoveAllNotifications];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
