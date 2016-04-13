//
//  StatisViewController.m
//  rrcc_distribution
//
//  Created by lawwilte on 9/17/15.
//  Copyright (c) 2015 ting liu. All rights reserved.
//

#import "StatisViewController.h"
#import "CoreDateManager.h"
#import "StatisTableViewCell.h"

@interface StatisViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UIView *IndexView;//按钮下方的索引图
    UIButton *timeButt;
    NSString *dayStr;
}

@property (weak, nonatomic) IBOutlet UIView *buttBackView;
@property (weak, nonatomic) IBOutlet UITableView *StatisTable;
@property (strong,nonatomic) NSMutableArray *dayArray;
@property (strong,nonatomic) NSMutableArray *billsArray;
@end

@implementation StatisViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self GetDistributerDailyBill];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单统计";
    [self initButtView];
    _buttBackView.backgroundColor = RGB(242,242,242);
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_StatisTable setTableFooterView:v];
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
        [_buttBackView addSubview:timeButt];
    }
    IndexView = [[UIView alloc] initWithFrame:CGRectMake(0,38,kScreenWidth/3,2)];
    IndexView.backgroundColor = RGB(255,149,54);
    [_buttBackView addSubview:IndexView];
    
}


#pragma mark TableViewDataSource && Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _billsArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    static NSString *Identifier = @"Identifier";
    StatisTableViewCell *statisCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!statisCell){
        statisCell = [[StatisTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    statisCell.TotalLb.text = [[_billsArray objectAtIndex:index] objectForJSONKey:@"total"];
    statisCell.AmountLb.text = [[_billsArray objectAtIndex:index] objectForJSONKey:@"amount"];
    statisCell.NetLb.text   = [[_billsArray objectAtIndex:index] objectForJSONKey:@"net"];
    statisCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return statisCell;
}




-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,5,_StatisTable.frame.size.width,30)];
    HeaderView.backgroundColor =  [UIColor lightGrayColor];
    
    UILabel *totalLb = [RHMethods labelWithFrame:CGRectMake(0, 0, kScreenWidth/3, 30) font:Font(13.0f) color:[UIColor blackColor] text:@"总订单量"];
    totalLb.textAlignment = NSTextAlignmentCenter;
    [HeaderView addSubview:totalLb];
    
    UILabel *amountLb = [RHMethods labelWithFrame:CGRectMake(XW(totalLb),0,kScreenWidth/3, 30) font:Font(13.0f) color:[UIColor blackColor] text:@"总流水"];
    amountLb.textAlignment = NSTextAlignmentCenter;
    [HeaderView addSubview:amountLb];
    
    UILabel *netLb = [RHMethods labelWithFrame:CGRectMake(XW(amountLb),0, kScreenWidth/3, 30) font:Font(13.0f) color:[UIColor blackColor] text:@"实际销售额"];
    netLb.textAlignment = NSTextAlignmentCenter;
    [HeaderView addSubview:netLb];
    return HeaderView;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}


-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}



#pragma mark ButtAction
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
    [self GetDistributerDailyBill];
}

#pragma 获得销售统计数据
-(void)GetDistributerDailyBill{
    NSString *StrUrl = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",BASEURL,DistributerDailyBill,[[Utility Share] userId],@"?date=",dayStr,@"&uid=",[[Utility Share] userId]];
    NSString *UrlStr = [[RestHttpRequest SharHttpRequest] ApendPubkey:StrUrl InputResourceId:[[Utility Share] userId] InputPayLoad:@""];
    [[AppDelegate Share].manger GET:UrlStr parameters:nil success:^ (AFHTTPRequestOperation * operation, id responseObject){
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        _billsArray = [dic objectForJSONKey:@"CallInfo"];
        //DLog(@"_billsArray 是%@",_billsArray);
        
        [_StatisTable reloadData];
    } failure:^(AFHTTPRequestOperation * operation, NSError * error){
        
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
