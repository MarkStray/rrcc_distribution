//
//  OrderCountViewController.m
//  rrcc_distribution
//
//  Created by lawwilte on 9/7/15.
//  Copyright (c) 2015 ting liu. All rights reserved.
//

#import "OrderCountViewController.h"
#import "BLEViewController.h"
#import "BltPrintFormat.h"
#import "CountTableViewCell.h"
#import "OrderRequestCenter.h"


@interface OrderCountViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *IndexView;//按钮下方的索引图
    UIButton *timeButt;
    NSString *dayStr;
}
@property (weak, nonatomic) IBOutlet UIView *ButtBackView;
@property (weak, nonatomic) IBOutlet UITableView *CountTable;
@property (strong,nonatomic) NSMutableArray *ordersArray;
@property (strong,nonatomic) NSMutableArray *dayArray;
@property (strong,nonatomic) NSMutableDictionary *printDic;

@end

@implementation OrderCountViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self GetDistributList];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单统计";
    _ButtBackView.backgroundColor = RGB(242,242,242);
    [self initButtView];
}

//获得3天日期数据
-(NSMutableArray*)daysArray{
    NSString *yesDate = [[Utility Share] DayYesterday];
    dayStr = yesDate;
    NSString *nowDate = [[Utility Share] GetTodayDay];
    NSString *nextDate= [[Utility Share] DayNextDay];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:yesDate,nowDate,nextDate,nil];
    return array;
}


-(void)initButtView{
    _dayArray = [[NSMutableArray alloc] init];
    _dayArray = [self daysArray];
    for (int i =0;i<_dayArray.count;i++){
        timeButt = [RHMethods buttonWithFrame:CGRectMake(0+i*(kScreenWidth/3), 0, kScreenWidth/3, 40) title:_dayArray[i] image:@"" bgimage:@""];
        [timeButt addTarget:self action:@selector(ButtClick:) forControlEvents:UIControlEventTouchUpInside];
        [timeButt setTintColor:[UIColor darkGrayColor]];
        timeButt.tag = 101+i;
        timeButt.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_ButtBackView addSubview:timeButt];
    }
    IndexView = [[UIView alloc] initWithFrame:CGRectMake(0,38,80,2)];
    IndexView.backgroundColor = RGB(255,149,54);
    [_ButtBackView addSubview:IndexView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _ordersArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Identifier";
    NSInteger index = indexPath.row;
    CountTableViewCell *countCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!countCell){
        countCell = [[CountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    countCell.indexLb.text = [NSString stringWithFormat:@"%ld",(long)index+1];
    countCell.skuLb.text   = [[_ordersArray objectAtIndex:index] objectForJSONKey:@"skuname"];
    countCell.specLb.text  = [[_ordersArray objectAtIndex:index] objectForJSONKey:@"spec"];
    countCell.countLb.text = [[_ordersArray objectAtIndex:index] objectForJSONKey:@"count"];
    NSString *supplierStr  = [[_ordersArray objectAtIndex:index] objectForJSONKey:@"supplier"];
    if (supplierStr){
        countCell.supplierLb.text = supplierStr;
    }else{
         countCell.supplierLb.text = @"无";
    }
    
    countCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return countCell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *rigntHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,5,_CountTable.frame.size.width,30)];
    rigntHeaderView.backgroundColor =  [UIColor lightGrayColor];
    
    UILabel *indexLb = [RHMethods labelWithFrame:CGRectMake(0,0,40,35) font:Font(13.0) color:[UIColor blackColor] text:@"序列"];
    indexLb.textAlignment = NSTextAlignmentCenter;
    [rigntHeaderView addSubview:indexLb];
    
    UILabel *SkuLb = [RHMethods labelWithFrame:CGRectMake(XW(indexLb),0,120,35) font:Font(13.0) color:[UIColor blackColor] text:@"产品"];
    SkuLb.textAlignment = NSTextAlignmentCenter;
    [rigntHeaderView addSubview:SkuLb];
    
    UILabel *specLb = [RHMethods labelWithFrame:CGRectMake(XW(SkuLb),0,(kScreenWidth-40-120)/3, 35) font:Font(13.0)color:[UIColor blackColor] text:@"规格"];
    specLb.textAlignment = NSTextAlignmentCenter;
    [rigntHeaderView addSubview:specLb];
    
    UILabel *countLb = [RHMethods labelWithFrame:CGRectMake(XW(specLb),0,(kScreenWidth-40-120)/3,35) font:Font(13.0) color:[UIColor blackColor] text:@"数量"];
    countLb.textAlignment = NSTextAlignmentCenter;
    [rigntHeaderView addSubview:countLb];

    UILabel *supplierLb = [RHMethods labelWithFrame:CGRectMake(XW(countLb),0,((kScreenWidth-40-120))/3, 35) font:Font(13.0) color:[UIColor blackColor] text:@"供货商"];
    supplierLb.textAlignment = NSTextAlignmentCenter;
    [rigntHeaderView addSubview:supplierLb];
    return rigntHeaderView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

#pragma mark 打印订单
-(IBAction)PrintOrderInfo:(UIButton*)sender{
    UIAlertView *PrintAlert = [[UIAlertView alloc] initWithTitle:@"是否打印此订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [PrintAlert show];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        BLEViewController *BlPrintView = [[BLEViewController alloc] init];
        NSString *ConnectStr = [BltPrintFormat  ShareBLTPrint].ConnectState;
        if ([ConnectStr isEqualToString:@"1"]){
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"status",dayStr,@"supply",nil];
            [BlPrintView PrinInfoWithStatusDic:dic withInfoDic:_printDic];
        }else{
            [[Utility Share] alertTitle:@"打印机未连接,请去连接打印机!"];
            [self pushNewViewController:BlPrintView];
        }
    }
}


#pragma mark 分类按钮点击
-(void)ButtClick:(UIButton*)button{
    NSInteger tag = button.tag;
    IndexView.frame = CGRectMake(button.frame.origin.x,38,kScreenWidth/3,2);
    switch (tag) {
        case 101:
            dayStr = button.titleLabel.text;
            break;
        case 102:
            dayStr = button.titleLabel.text;
            break;
        case 103:
            dayStr = button.titleLabel.text;
            break;
        default:
            break;
    }
    [self GetDistributList];
}


#pragma mark 获取配送列表
-(void)GetDistributList{

    NSString *StrUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",BASEURL,DistributerDailyList,[[Utility Share]userId],@"?date=",dayStr,@"&uid=",[[Utility Share] userId]];
    NSString *UrlStr = [[RestHttpRequest SharHttpRequest] ApendPubkey:StrUrl InputResourceId:[[Utility Share] userId] InputPayLoad:@""];
    [[AppDelegate Share].manger GET:UrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *ResposDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[ResposDic objectForJSONKey:@"Success"] isEqualToString:@"1"]){
            _ordersArray = [[NSMutableArray alloc] initWithArray:[ResposDic objectForJSONKey:@"CallInfo"]];
            _printDic = [ResposDic mutableCopy];
            [_CountTable reloadData];
            
        } else {
            [[Utility Share] alertTitle:[ResposDic objectForJSONKey:@"ErrorMsg"]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[Utility Share] alertTitle:[error localizedDescription]];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
