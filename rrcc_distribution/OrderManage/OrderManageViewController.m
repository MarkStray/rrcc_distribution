//
//  OrderManageViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-21.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderManageViewController.h"
#import "OrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "CoreDateManager.h"
#import "OrderRequestCenter.h"
#import "StoreViewController.h"
#import "Orders.h"


@interface OrderManageViewController ()<UISearchBarDelegate,UIGestureRecognizerDelegate>{
                             NSInteger  ViewStatus;//用户点击的界面状态
                               NSArray  *TitleArray;//按钮标题
                        NSMutableArray  *OrderListArray;//数据源
                     NSArray            *fliterArray;
                     NSMutableArray     *SectionTitleArray;//SectionHeader
                     NSMutableDictionary*OrderListDic;//获取订单列表

                        CoreDateManager *OrderDataManage;
                     OrderRequestCenter *orderRequest;//订单请求
                                 UIView *IndexView;//按钮下方的索引图
                               UIButton *StatusButton;//状态按钮
           __weak IBOutlet UIScrollView *SelectScrollView;//选择按钮滚动视图
            __weak IBOutlet UITableView *OrderMangeTable;//管理Table
            __weak IBOutlet UISearchBar *OrderSearchBar;//订单搜索
}
@end
@implementation OrderManageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (ViewStatus == 101){
        [orderRequest GetOrderList:@"0" Status:@"1"];
    }else if (ViewStatus == 102){
        [orderRequest GetOrderList:@"102" Status:@"1"];
    }else if (ViewStatus == 103){
        [orderRequest GetOrderList:@"103" Status:@"1"];
    }else if (ViewStatus == 104){
        [orderRequest GetOrderList:@"104" Status:@"1"];
    }else if (ViewStatus == 105){
        [orderRequest GetOrderList:@"105" Status:@"1"];
    }else if (ViewStatus == 106){
        [orderRequest GetOrderList:@"106" Status:@"1"];
    }
}


-(void)ConfigureRightItem{
    //设置按钮
    UIImage* image= [UIImage imageNamed:@"setting"];
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(kScreenWidth, 0, 40, 40);
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(settingView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)settingView{
    
    StoreViewController *storeView = [[StoreViewController alloc] init];
    [self pushNewViewController:storeView];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"订单管理";
 
    //数据初始化
    OrderListArray = [[NSMutableArray alloc] init];
    SectionTitleArray = [[NSMutableArray alloc] init];
    OrderListDic  = [[NSMutableDictionary alloc] init];
    
     //初始化CoreDataManage 和 OrderRequestCenter
    OrderDataManage = [[CoreDateManager alloc] init];
    orderRequest    = [[OrderRequestCenter alloc] init];
    
    //初始化后台
    BgTask = [[BackgroundTask alloc] init];
    [BgTask startBackgroundTasks:60 target:self selector:@selector(BackgroundCallBack)];
    //下拉刷新,进行网络请求
    [self RefreshOrderInfo];
    //去除分割线，设置按钮文字颜色
    OrderMangeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
     self.view.backgroundColor = [UIColor lightGrayColor];
    [OrderSearchBar setBackgroundImage:[UIImage imageNamed:@"SearchBar"]];
    [self  SetupButtScrolView];
    [self ConfigureRightItem];
    
    //注册通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                   selector:@selector(RefreshData:)
                   name:@"RefreshData"
                   object:nil];
    //网络请求错误
    [defaultCenter addObserver:self
                      selector:@selector(NetWorkError:)
                          name:@"NetWorkError"
                        object:nil];
}

-(void)SetupButtScrolView{
    TitleArray = @[@"全部",@"已确认",@"已完成",@"未完成"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    SelectScrollView.contentSize = CGSizeMake(kScreenWidth,0);
    SelectScrollView.backgroundColor = RGB(242,242,242);
    SelectScrollView.showsVerticalScrollIndicator = NO;
    SelectScrollView.bounces = NO;
    for (int i =0;i<TitleArray.count;i++){
        StatusButton = [RHMethods buttonWithFrame:CGRectMake(0+i*(kScreenWidth/4), 0,kScreenWidth/4, 40) title:TitleArray[i] image:@"" bgimage:@""];
        [StatusButton addTarget:self action:@selector(ButtClick:) forControlEvents:UIControlEventTouchUpInside];
        [StatusButton setTintColor:[UIColor blackColor]];
        StatusButton.tag = 101+i;
        StatusButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [SelectScrollView addSubview:StatusButton];
    }
    IndexView = [[UIView alloc] initWithFrame:CGRectMake(0,38,kScreenWidth/4,2)];
    IndexView.backgroundColor = RGB(255,149,54);
    [SelectScrollView addSubview:IndexView];
}


#pragma mark 获得全部订单数据并刷新界面和数据库操作
-(void)RefreshOrderInfo{
    //下拉刷新
    __weak __typeof(self) weakSelf = self;
    OrderMangeTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf GetOrderList];
    }];
    [OrderMangeTable.header beginRefreshing];
}

-(void)GetOrderList{
    
    [orderRequest GetOrderList:@"0" Status:@"1"];
}

//后台回调
-(void)BackgroundCallBack{
    [orderRequest GetOrderList:@"-10" Status:@"1"];
}


#pragma mark UItableView Delegate && DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return SectionTitleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *key = [SectionTitleArray objectAtIndex:section];
    NSArray  *keyArray = [OrderListDic objectForJSONKey:key];
    return keyArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"Identifier";
    NSInteger index = indexPath.row;
    OrderTableViewCell *OrderCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (OrderCell == nil){
        OrderCell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] lastObject];
        OrderCell.backgroundColor = RGBCOLOR(244, 244, 244);
    }
    NSString *key = [SectionTitleArray objectAtIndex:indexPath.section];
    NSArray  *Array = [OrderListDic objectForJSONKey:key];
    OrderCell.OrderCodeLb.text = [[Array objectAtIndex:index] objectForJSONKey:@"ordercode"];
    NSInteger payment  = [[[Array objectAtIndex:index] objectForJSONKey:@"payment"] integerValue];
    NSInteger has_paid = [[[Array objectAtIndex:index] objectForJSONKey:@"has_paid"] integerValue];
    NSInteger status   = [[[Array objectAtIndex:index] objectForJSONKey:@"status"] integerValue];
    //订单状态
    switch (payment){
        case 1:
            OrderCell.PayStatusImg.image = [UIImage imageNamed:@"CashPay"];
            break;
        case 2:
            OrderCell.PayStatusImg.image = [UIImage imageNamed:@"OnLinePay"];
            break;
        default:
            break;
    }
    
    if (status == 1 && has_paid == 0){
        OrderCell.OrderStatusLb.text  = @"未接单-未支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 1 && has_paid == 1){
        OrderCell.OrderStatusLb.text = @"未接单-已支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 2 && has_paid == 0){
        OrderCell.OrderStatusLb.text = @"已确认-未支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 2 && has_paid == 1){
        OrderCell.OrderStatusLb.text = @"已确认-已支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 3 && has_paid == 0){
        OrderCell.OrderStatusLb.text = @"已完成-未支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderRedStatus.png"];
    }
    if (status == 3 && has_paid == 1){
        OrderCell.OrderStatusLb.text = @"已完成-已支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderRedStatus.png"];
    }
    if (status == 4 && has_paid == 0){
        OrderCell.OrderStatusLb.text = @"商户取消-未支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 4 && has_paid == 1){
        OrderCell.OrderStatusLb.text = @"商户取消-已支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 5 && has_paid == 0){
        OrderCell.OrderStatusLb.text = @"用户取消-未支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 5 && has_paid == 1){
        OrderCell.OrderStatusLb.text = @"用户取消-已支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 6 && has_paid == 0){
        OrderCell.OrderStatusLb.text = @"过期订单-未支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 6 && has_paid == 1){
        OrderCell.OrderStatusLb.text = @"过期订单-已支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderGrayStatus.png"];
    }
    if (status == 7 && has_paid == 0){
        OrderCell.OrderStatusLb.text = @"已评价-未支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderRedStatus.png"];
    }
    if (status == 7 && has_paid == 1){
        OrderCell.OrderStatusLb.text = @"已评价-已支付";
        OrderCell.StatusImg.image = [UIImage imageNamed:@"OrderRedStatus.png"];
    }
    OrderCell.SvAddressLb.text = [[Array objectAtIndex:index] objectForJSONKey:@"address"];
    OrderCell.SvTimeLb.text    = [[Array objectAtIndex:index] objectForJSONKey:@"svtime"];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(10,95, kScreenWidth-20,10)];
    cellView.backgroundColor = [UIColor clearColor];
    [OrderCell addSubview:cellView];
    OrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return OrderCell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 105;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [OrderSearchBar resignFirstResponder];
    NSInteger index   = indexPath.row;
    NSInteger section = indexPath.section;
    NSString *Key = [SectionTitleArray objectAtIndex:section];
    NSDictionary *dic = [[OrderListDic objectForJSONKey:Key]objectAtIndex:index];
    OrderDetailViewController *OrderDetailView = [[OrderDetailViewController alloc] init];
    OrderDetailView.OrderId     = [dic objectForJSONKey:@"orderId"];
    OrderDetailView.OrderTel    = [dic objectForJSONKey:@"tel"];
    OrderDetailView.OrderCode   = [dic objectForJSONKey:@"ordercode"];
    OrderDetailView.OrderAdress = [dic objectForJSONKey:@"address"];
    OrderDetailView.OrderRemark = [dic objectForJSONKey:@"remark"];
    [self pushNewViewController:OrderDetailView];
 }

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *rigntHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,5,OrderMangeTable.frame.size.width,20)];
    rigntHeaderView.backgroundColor = RGB(255,149,54);
    UILabel *headerLb = [RHMethods labelWithFrame:CGRectMake(5,0,kScreenWidth, 20) font:Font(15.0f) color:[UIColor blackColor] text:  [NSString stringWithFormat:@"%@%@",[SectionTitleArray objectAtIndex:section],@"预约订单"]];
    [rigntHeaderView addSubview:headerLb];
    return rigntHeaderView;
    
}

#pragma mark 本地搜索
-(void)searchRequest:(NSString*)searchText{

    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"tel",searchText];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"ordercode",searchText];
    NSPredicate *predicate  = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1,predicate2]];
    [self DataSourceHandle:[OrderDataManage FliterFromDb:predicate]];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString *)searchText{
    [self searchRequest:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchBar:searchBar textDidChange:searchBar.text];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:NO];
}

#pragma mark 分类按钮点击
-(void)ButtClick:(UIButton*)button{
    
    [OrderSearchBar resignFirstResponder];
    NSInteger tag = button.tag;
    IndexView.frame = CGRectMake(button.frame.origin.x,38,kScreenWidth/4,2);
    switch (tag) {
        case 101:
            //刷新，读取全部数据
            ViewStatus = 101;
            OrderMangeTable.header.hidden = NO;
            [self ReadDataByStatus:@"101"];
            break;
        case 102:
            ViewStatus = 102;
            OrderMangeTable.header.hidden = YES;
            [self ReadDataByStatus:@"102"];
            //状态为1,读取新订单
            break;
        case 103:
            //已确认,状态为2,has_dispatched =0;
            ViewStatus = 103;
            OrderMangeTable.header.hidden = YES;
            [self ReadDataByStatus:@"103"];
            break;
        case 104:
            //已发货,状态为2,has_dispatched = 1;
            ViewStatus = 104;
            OrderMangeTable.header.hidden = YES;
            [self ReadDataByStatus:@"104"];
            break;
        default:
            break;
    }
}


//从数据库读取数据,刷新数据 ,返回该界面时，不重新刷新
-(void)RefreshData:(NSNotification*)notification{
    //查询条件
    [OrderMangeTable.header endRefreshing];
    if (!ViewStatus || ViewStatus == 101){
        [self ReadDataByStatus:@"101"];
        }else if (ViewStatus == 102){
            [self ReadDataByStatus:@"102"];
        }else if (ViewStatus == 103){
            [self ReadDataByStatus:@"103"];
        }else if (ViewStatus == 104){
            [self ReadDataByStatus:@"104"];
        }
}

//网络请求错误
-(void)NetWorkError:(NSNotification*)notification{
    //查询条件
    [OrderMangeTable.header endRefreshing];
    if (!ViewStatus || ViewStatus == 101){
        [self ReadDataByStatus:@"101"];
    }else if (ViewStatus == 102){
        [self ReadDataByStatus:@"102"];
    }else if (ViewStatus == 103){
        [self ReadDataByStatus:@"103"];
    }else if (ViewStatus == 104){
        [self ReadDataByStatus:@"104"];
    }
}


//更根据状态读取数据库,刷新界面
-(void)ReadDataByStatus:(NSString*)Status{
    NSPredicate *predicate ;
    if ([Status isEqualToString:@"101"]){
        predicate = [NSPredicate predicateWithFormat:@"status =1 or status =2 or status=3 or status=4 or status=5 or status=6 or status=7"];
    }
    if([Status isEqualToString:@"102"]){
        predicate  = [NSPredicate predicateWithFormat:@"status =2"];
    }
    if ([Status isEqualToString:@"103"]){
        predicate = [NSPredicate predicateWithFormat:@"status =3 or status =7"];
    }
    if ([Status isEqualToString:@"104"]){
        predicate = [NSPredicate predicateWithFormat:@"status =4 or status =5 or status=6"];
    }
    [self DataSourceHandle:[OrderDataManage FliterFromDb:predicate]];
}


//分栏数据处理
-(void)DataSourceHandle:(NSArray*)listArray{
    
    NSMutableArray *InsertTimeArray = [[NSMutableArray alloc] init];
    NSMutableArray *orderArray   = [[NSMutableArray alloc] init];
    NSMutableArray *sectionArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *orderDic = [[NSMutableDictionary alloc]init];
    
    for (NSObject *obj in listArray){
        NSString *timeStr  = [[obj valueForKey:@"svtime"] substringToIndex:10];
        [InsertTimeArray addObject:timeStr];
    }
    for (int i = 0;i<InsertTimeArray.count;i++){
        if ([sectionArray containsObject:[InsertTimeArray objectAtIndex:i]] == NO){
            [sectionArray addObject:[InsertTimeArray objectAtIndex:i]];
        }
    }
    for (Orders *info  in listArray){
        NSString *StrAddress;
        if (!info.address){
            StrAddress = @"";
        }else{
            StrAddress = info.address;
        }
        NSMutableDictionary *InfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:info.ordercode,@"ordercode",StrAddress,@"address",info.delivery,@"delivery",info.status,@"status",info.payment,@"payment",info.has_paid,@"has_paid",info.orderId,@"orderId",info.svtime,@"svtime",[info.svtime substringToIndex:10],@"identifier",info.tel,@"tel",info.remark,@"remark",nil];
        [orderArray addObject:InfoDic];
    }
    for (NSObject *object in sectionArray){
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"identifier =%@",object];
        fliterArray = [orderArray filteredArrayUsingPredicate:predicate];
        if (fliterArray.count > 0){
            [orderDic setObject:fliterArray forKey:[object copy]];
        }
    }
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    SectionTitleArray = [[sectionArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]] copy];
    OrderListDic = [orderDic copy];
    [OrderMangeTable reloadData];
}


//移除通知
- (void)RemoveAllNotifications{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:@"RefreshData"
                           object:nil];
    [defaultCenter removeObserver:self
                             name:@"NetWorkError"
                           object:nil];
}

-(void)dealloc{
    [self RemoveAllNotifications];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
