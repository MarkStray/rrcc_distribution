//
//  OrderDetailViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-21.
//  Copyright (c) 2015年 ting liu. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "DetailOrderTableViewCell.h"
#import "CoreDateManager.h"
#import "BLEViewController.h"
#import "BltPrintFormat.h"
#define BGColor RGB(242,242,242)

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
                             UIView *HeaderView; //HeaderView
                            UILabel *OrderCodeLb;//订单号
                            UILabel *DeliveryTimeLb;//下单时间
                            UILabel *OrderStatusLb;//订单状态
                            UILabel *UserNameLb;//姓名
                            UILabel *MobileLbl;//手机
                           UIButton *CallButt;//拨打电话
                            UILabel *DeliverStyleLb;//送货方式
                            UILabel *DeliverAdressLb;//配送地址
                            UILabel *SvtTimeLb;//预约时间
                            UILabel *RemarkLb;//备注信息
                            UILabel *OrderCountsLb;//下单次数
                            UIView  *NoticeView;//提示界面
                            UILabel *NoticeLb;//提示信息
                        UIImageView *PayStatusImg;//支付状态图片
                     CoreDateManager*OrderDataManage;
                          NSString  *ActPriceStr;
                        NSDictionary*OrderInfoDic;
                    NSMutableArray  *OrderDetailArray;//订单详情数组
                    NSMutableArray  *ActArray;//活动数组
               NSMutableDictionary  *PrintOrderDic;//需要打印的订单信息
               NSMutableDictionary  *ActDic;//下方的那几个活动，总价的数据
               NSMutableDictionary  *OrderDic;
    
                    __weak IBOutlet UIButton *FinshButt;//完成按钮
                    IBOutlet UIView *FinshPrintView;//完成,打印界面
                    IBOutlet UIView *BackView;
    
                    IBOutlet UIView *PrintView;//打印界面
           __weak IBOutlet UIButton *DeliveryButt;//确认按钮
    
       __weak IBOutlet UITableView  *OrderTable;
    }
@end
@implementation OrderDetailViewController
@synthesize OrderId,OrderCode,OrderAdress,OrderRemark,OrderTel;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //获取订单详情
    [self GetDetailOrderInfo];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"订单详情";
    OrderDataManage = [[CoreDateManager alloc] init];
    //自定义返回按钮,刷新界面
    UIImage* image= [UIImage imageNamed:@"BackArrow"];
    UIImage* imagef = [UIImage imageNamed:@"Arrow_press"];
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:imagef forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //设置FooterView
    [OrderTable setTableFooterView:[UIView new]];
    self.view.backgroundColor     = BGColor;
    OrderTable.backgroundColor    = BGColor;
    [self initheaderview];
}

//修改了返回按钮的方法
-(void)back{
 
    [self.navigationController popViewControllerAnimated:YES];
    //发起通知，更新界面
    NSNotification *notification = [NSNotification notificationWithName:@"RefreshData" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}


//初始化HeaderView
-(void)initheaderview{
    //设置TableView HeaderView
    HeaderView = [UIView new];
    HeaderView.backgroundColor = [UIColor whiteColor];
    OrderCodeLb    = [RHMethods labelWithFrame:CGRectMake(10,1,150,15) font:Font(14.0f) color:[UIColor darkGrayColor] text:@""];
    DeliveryTimeLb = [RHMethods labelWithFrame:CGRectMake(X(OrderCodeLb), YH(OrderCodeLb)+5,260, 15) font:Font(15.0f) color:[UIColor darkGrayColor] text:@""];
    OrderStatusLb  = [RHMethods labelWithFrame:CGRectMake(kScreenWidth-100,5,150,15)font:Font(13.0f) color:[UIColor redColor] text:@""];
    UIView *LineAView = [[UIView alloc] initWithFrame:CGRectMake(0, YH(DeliveryTimeLb), kScreenWidth, 1)];
    LineAView.backgroundColor =[UIColor lightGrayColor];
    
    UserNameLb = [RHMethods labelWithFrame:CGRectMake(X(OrderCodeLb),YH(LineAView)+3,150,15) font:Font(14.0f) color:[UIColor darkGrayColor] text:@""];
    MobileLbl  = [RHMethods labelWithFrame:CGRectMake(X(UserNameLb),YH(UserNameLb)+3,150,15) font:Font(14.0f) color:[UIColor darkGrayColor] text:@""];
    CallButt   = [RHMethods buttonWithFrame:CGRectMake(kScreenWidth-40, Y(UserNameLb), 25, 25) title:@"" image:@"" bgimage:@"tel"];
    [CallButt addTarget:self action:@selector(TelCall) forControlEvents:UIControlEventTouchUpInside];
    UIView *LineBView = [[UIView alloc] initWithFrame:CGRectMake(0, YH(MobileLbl)+3, kScreenWidth, 1)];
    LineBView.backgroundColor = [UIColor lightGrayColor];
    DeliverStyleLb  = [RHMethods labelWithFrame:CGRectMake(X(OrderCodeLb),YH(LineBView)+2,150,20) font:Font(14.0f) color:[UIColor darkGrayColor] text:@"配送方式:送货上门"];
    PayStatusImg    = [RHMethods imageviewWithFrame:CGRectMake(kScreenWidth-50, Y(DeliverStyleLb), 45,15) defaultimage:@"OnLinePay"];
    //发货地址,高度随便设
    DeliverAdressLb = [[UILabel alloc] initWithFrame:CGRectMake(X(OrderCodeLb),YH(DeliverStyleLb),kScreenWidth-X(OrderCodeLb),0)];
    DeliverAdressLb.text=[NSString stringWithFormat:@"%@%@",@"配送地址:",OrderAdress];
    DeliverAdressLb.textColor = [UIColor darkGrayColor];
    DeliverAdressLb.font = Font(14.0f);
    DeliverAdressLb.textAlignment = NSTextAlignmentLeft;
    DeliverAdressLb.lineBreakMode = NSLineBreakByCharWrapping;
    DeliverAdressLb.numberOfLines = 0;
    //自适应高度
    CGRect DeliverAdressFrame = DeliverAdressLb.frame;
    DeliverAdressFrame.size.height =[DeliverAdressLb.text boundingRectWithSize:CGSizeMake(DeliverAdressFrame.size.width, CGFLOAT_MAX) options:
        NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:[NSDictionary
                                                            dictionaryWithObjectsAndKeys:DeliverAdressLb.font,NSFontAttributeName, nil] context:nil].size.height;
    //此处修改下固定的长度
    DeliverAdressLb.frame = CGRectMake(X(OrderCodeLb),YH(DeliverStyleLb),kScreenWidth-X(OrderCodeLb),DeliverAdressFrame.size.height);
    //预约时间:
    SvtTimeLb = [RHMethods labelWithFrame:CGRectMake(X(OrderCodeLb),YH(DeliverAdressLb),260,20) font:Font(14.0f) color:[UIColor darkGrayColor] text:@""];
    //备注信息,高度随便设
    RemarkLb = [[UILabel alloc] initWithFrame:CGRectMake(X(OrderCodeLb),YH(SvtTimeLb),kScreenWidth-X(OrderCodeLb),0)];
    if (![OrderRemark notEmptyOrNull]){
        RemarkLb.text   =[NSString stringWithFormat:@"%@",@"备注信息:"];
    }else{

        RemarkLb.text  =[NSString stringWithFormat:@"%@%@",@"备注信息:",OrderRemark];
    }
    RemarkLb.textColor = [UIColor darkGrayColor];
    RemarkLb.font = Font(14.0f);
    RemarkLb.textAlignment = NSTextAlignmentLeft;
    //自动折行设置
    RemarkLb.lineBreakMode = NSLineBreakByCharWrapping;
    RemarkLb.numberOfLines = 0;
    //自适应高度
    CGRect RemarkFrame = RemarkLb.frame;
    RemarkFrame.size.height = [RemarkLb.text boundingRectWithSize:CGSizeMake
                               (RemarkFrame.size.width, CGFLOAT_MAX) options:
                                NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:RemarkLb.font,NSFontAttributeName,nil] context:nil].size.height;
    RemarkLb.frame = CGRectMake(10,YH(SvtTimeLb),kScreenWidth-X(OrderCodeLb),RemarkFrame.size.height);
    //订单次数
    OrderCountsLb  =[RHMethods labelWithFrame:CGRectMake(X(OrderCodeLb),YH(RemarkLb),260,20) font:Font(14.0f) color:[UIColor darkGrayColor] text:@""];
    NoticeView  = [[UIView alloc]initWithFrame:CGRectMake(0,YH(OrderCountsLb),kScreenWidth,40)];
    NoticeView.backgroundColor = RGBCOLOR(242,242,242);
    NoticeLb    = [RHMethods labelWithFrame:CGRectMake(10,0,kScreenWidth-20,40)font:Font(13.0f) color:[UIColor redColor] text:@"为避免拒收,请尽可能为客人挑选新鲜蔬菜,并准时送达!挑选商品请尽量与用户下单价钱不要相差太大!"];
    NoticeLb.numberOfLines = 3;
    NoticeLb.lineBreakMode = NSLineBreakByCharWrapping;
    [NoticeView addSubview:NoticeLb];
    
    UIView *LineCView = [[UIView alloc] initWithFrame:CGRectMake(0,YH(OrderCountsLb)-1, kScreenWidth, 1)];
    LineCView.backgroundColor = [UIColor lightGrayColor];
    UIView *LineDView = [[UIView alloc] initWithFrame:CGRectMake(0,YH(NoticeView), kScreenWidth, 1)];
    LineDView.backgroundColor = [UIColor lightGrayColor];
    UILabel *ProductsNameLb = [RHMethods labelWithFrame:CGRectMake(10, YH(LineDView),kScreenWidth-10, 30) font:Font(15.0f) color:[UIColor darkGrayColor] text:@"购买菜品"];
    ProductsNameLb.backgroundColor = [UIColor whiteColor];
    UIView *LineEView = [[UIView alloc] initWithFrame:CGRectMake(0,YH(ProductsNameLb)+1, kScreenWidth, 1)];
    LineEView.backgroundColor = [UIColor lightGrayColor];
    [HeaderView addSubview:LineAView];
    [HeaderView addSubview:LineBView];
    [HeaderView addSubview:LineCView];
    [HeaderView addSubview:OrderCodeLb];
    [HeaderView addSubview:DeliveryTimeLb];
    [HeaderView addSubview:OrderStatusLb];
    [HeaderView addSubview:UserNameLb];
    [HeaderView addSubview:MobileLbl];
    [HeaderView addSubview:CallButt];
    [HeaderView addSubview:DeliverStyleLb];
    [HeaderView addSubview:PayStatusImg];
    [HeaderView addSubview:DeliverAdressLb];
    [HeaderView addSubview:SvtTimeLb];
    [HeaderView addSubview:RemarkLb];
    [HeaderView addSubview:OrderCountsLb];
    [HeaderView addSubview:NoticeView];
    [HeaderView addSubview:LineDView];
    [HeaderView addSubview:LineEView];
    [HeaderView addSubview:ProductsNameLb];
    HeaderView.frame = CGRectMake(0,0,kScreenWidth,YH(LineEView));
    [OrderTable setTableHeaderView:HeaderView];
}

//打电话
-(void)TelCall{
    [[Utility Share] makeCall:OrderTel];
}

#pragma mark UITableView  Delegate && DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return  OrderDetailArray.count;
    }
    if (section == 1){
        return 6;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.row;
    NSInteger section = indexPath.section;
    if (tableView == OrderTable){
        static NSString *Identifier = @"Identifier";
        DetailOrderTableViewCell *OrderCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (OrderCell == nil){
            OrderCell = [[[NSBundle mainBundle] loadNibNamed:@"DetailOrderTableViewCell" owner:self options:nil] lastObject];
            if (section == 0){
                NSString *urlStr = [[[OrderDetailArray objectAtIndex:index] objectForJSONKey:@"imgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *logoUrl = [NSURL URLWithString:urlStr];
                [OrderCell.ItemImgView sd_setImageWithURL:logoUrl];
                OrderCell.ItemNameLb.text = [[OrderDetailArray objectAtIndex:index] objectForJSONKey:@"skuname"];
                OrderCell.OrderCountLb.text = [NSString stringWithFormat:@"%@%@",@"x",[[OrderDetailArray objectAtIndex:index] objectForJSONKey:@"ordercount"]];
                OrderCell.PriceLb.text = [NSString stringWithFormat:@"%@%@",@"￥",[[OrderDetailArray objectAtIndex:index] objectForJSONKey:@"price"]];
                OrderCell.ItemRuleLb.text = [[OrderDetailArray objectAtIndex:index] objectForJSONKey:@"spec"];
            }
            
            if (section == 1){
                if (index == 0){
                    UIImageView *DicsountImg = [RHMethods imageviewWithFrame:CGRectMake(15,8,25,25) defaultimage:@"Jian"];
                    [OrderCell addSubview:DicsountImg];
                    //满减
                    UILabel *DiscountLb = [RHMethods labelWithFrame:CGRectMake(XW(DicsountImg)+5,8,100, 30) font:Font(13.0f) color:[UIColor blackColor] text:@"满减活动"];
                    [OrderCell addSubview:DiscountLb];
                    //折扣
                    NSString  *DiscountPrice;
                    float floatDisCounPrice = [[[ActArray objectAtIndex:index] objectForJSONKey:@"discount"] floatValue];
                    if (floatDisCounPrice == 0){
                        DiscountPrice = [NSString stringWithFormat:@"%@%@",@"￥",[NSString stringWithFormat:@"%.2f",floatDisCounPrice]];
                    }else{
                        DiscountPrice = [NSString stringWithFormat:@"%@%@",@"-￥",[NSString stringWithFormat:@"%.2f",floatDisCounPrice]];
                    }
                    UILabel *PriceLb = [RHMethods labelWithFrame:CGRectMake(kScreenWidth-105, 8, 100, 30) font:Font(13.0f) color:[UIColor blackColor] text:DiscountPrice];
                    PriceLb.textAlignment = NSTextAlignmentRight;
                    [OrderCell addSubview:PriceLb];
                }
                
                if(index == 1){
                    UIImageView *DicsountImg = [RHMethods imageviewWithFrame:CGRectMake(15,8,25,25) defaultimage:@"zen"];
                    [OrderCell addSubview:DicsountImg];
                    UILabel *GiftLb = [RHMethods labelWithFrame:CGRectMake(XW(DicsountImg)+5,8,100, 30) font:Font(13.0f) color:[UIColor blackColor] text:@"赠品活动"];
                    [OrderCell addSubview:GiftLb];
                    UILabel *DetailGifitLb = [RHMethods labelWithFrame:CGRectMake(kScreenWidth-155,8,150,30) font:Font(13.0f) color:[UIColor blackColor] text:@""];
                    [DetailGifitLb setTextAlignment:NSTextAlignmentRight];
                    NSString *StrGifit = [[ActArray objectAtIndex:index] objectForJSONKey:@"gift"];
                    if(StrGifit.length == 0){
                        DetailGifitLb.text = @"暂时没有赠品";
                    }else{
                        DetailGifitLb.text = [[ActArray objectAtIndex:index] objectForJSONKey:@"gift"];
                    }
                    [OrderCell addSubview:DetailGifitLb];
                }
                
                if (index == 2){
                    UIImageView *VouchImg = [RHMethods imageviewWithFrame:CGRectMake(15,8,25,25) defaultimage:@"vouvher"];
                    [OrderCell addSubview:VouchImg];
                    UILabel *VouchLb  = [RHMethods labelWithFrame:CGRectMake(XW(VouchImg)+5,8,100, 30) font:Font(13.0f) color:[UIColor blackColor] text:@"红包"];
                    [OrderCell addSubview:VouchLb];
                    NSString *VoucherPrice;
                    float floatVoucherPrice = [[[ActArray objectAtIndex:index] objectForJSONKey:@"voucher"] floatValue];
                    if (floatVoucherPrice == 0){
                        VoucherPrice = [NSString stringWithFormat:@"%@%@",@"￥",[NSString stringWithFormat:@"%.2f",floatVoucherPrice]];
                    }else{
                        VoucherPrice = [NSString stringWithFormat:@"%@%@",@"-￥",[NSString stringWithFormat:@"%.2f",floatVoucherPrice]];
                    }
                    UILabel *VoPriceLB = [RHMethods labelWithFrame:CGRectMake(kScreenWidth-95,8,90,30) font:Font(13.0f) color:[UIColor blackColor] text:VoucherPrice];
                    VoPriceLB.textAlignment = NSTextAlignmentRight;
                    [OrderCell addSubview:VoPriceLB];
                }
                
                if (index == 3){
                    UILabel *PersellLb  = [RHMethods labelWithFrame:CGRectMake(15, 8, 100, 30) font:Font(13.0f) color:[UIColor blackColor] text:@"预售折扣"];
                    [OrderCell addSubview:PersellLb];
                    float presell_discount = [[[ActArray objectAtIndex:index] objectForJSONKey:@"presell_discount"] floatValue];
                    NSString *PerPrice;
                    if (presell_discount >0){
                        PerPrice = [NSString stringWithFormat:@"%@%@",@"-￥",[[ActArray objectAtIndex:index]objectForJSONKey:@"presell_discount"]];
                    }else{
                        PerPrice = [NSString stringWithFormat:@"%@%@",@"￥",[[ActArray objectAtIndex:index]objectForJSONKey:@"presell_discount"]];
                    }
                    UILabel *PriceLb = [RHMethods labelWithFrame:CGRectMake(kScreenWidth-105, 8, 100, 30) font:Font(13.0f) color:[UIColor blackColor] text:PerPrice];
                    PriceLb.textAlignment = NSTextAlignmentRight;
                    [OrderCell addSubview:PriceLb];
                }
                
                if (index == 4){
                    UILabel *CountPriceLb = [RHMethods labelWithFrame:CGRectMake(15,8,100,30) font:Font(13.0f) color:[UIColor blackColor] text:@"总价"];
                    [OrderCell addSubview:CountPriceLb];
                    float CountPrice = [[[ActArray objectAtIndex:index] objectForJSONKey:@"price"] floatValue];
                    NSString *StrPrice = [NSString stringWithFormat:@"%@%.2f",@"￥",CountPrice];
                    UILabel *PriceLb = [RHMethods labelWithFrame:CGRectMake(kScreenWidth-105,8,100,30) font:Font(13.0f) color:[UIColor blackColor] text:StrPrice];
                    PriceLb.textAlignment = NSTextAlignmentRight;
                    [OrderCell addSubview:PriceLb];
                }
                
                if (index == 5){
                    UILabel *CountPriceLb = [RHMethods labelWithFrame:CGRectMake(15,8,100,30) font:Font(13.0f) color:[UIColor blackColor] text:@"实际价格"];
                    [OrderCell addSubview:CountPriceLb];
                    NSString *ActPrice = [NSString stringWithFormat:@"%@%@",@"￥",ActPriceStr];
                    UILabel *ActPriceLb = [RHMethods labelWithFrame:CGRectMake(kScreenWidth-105,8,100,30) font:Font(13.0f) color:[UIColor redColor] text:ActPrice];
                    ActPriceLb.textAlignment= NSTextAlignmentRight;
                    [OrderCell addSubview:ActPriceLb];
                }
            }
        }
        OrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return OrderCell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        return 40;
    }
    return 70;
}

#pragma mark 网络请求
//获取订单详情,OrderID 为空
-(void)GetDetailOrderInfo{
    
    NSString *StrUrl = [NSString stringWithFormat:@"%@%@%@%@%@",BASEURL,DistributerOrderDetails,OrderId,@"?uid=",[[Utility Share] userId]];
    NSString *UrlStr = [[RestHttpRequest SharHttpRequest] ApendPubkey:StrUrl InputResourceId:OrderId InputPayLoad:@""];
    [[AppDelegate Share].manger GET:UrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        OrderInfoDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[OrderInfoDic objectForJSONKey:@"Success"] isEqualToString:@"1"]){
            //打印信息
            PrintOrderDic = [OrderInfoDic mutableCopy];
            [OrderDataManage UpdateOrderInfo: [OrderInfoDic objectForJSONKey:@"CallInfo"] WithOrderCode: [[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"ordercode"]];
            //订单次数
            OrderCountsLb.text = [NSString stringWithFormat:@"%@%@",@"订单次数:", [[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"user_order_index"]];
            //发货状态
            NSString *deliveryStatu = [[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"delivery"];
            //显示数据
            OrderCodeLb.text = [NSString stringWithFormat:@"%@%@",@"订单号:",[[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"ordercode"]];
            DeliveryTimeLb.text =[NSString stringWithFormat:@"%@%@",@"下单时间:",[[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"inserttime"]];
            UserNameLb.text  =[NSString stringWithFormat:@"%@%@",@"姓名:",[[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"contact"]];
            MobileLbl.text  =[NSString stringWithFormat:@"%@%@",@"手机:",[[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"tel"]];
            SvtTimeLb.text =[NSString stringWithFormat:@"%@%@",@"预约时间:",[[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"svtime"]];
            if ([deliveryStatu isEqualToString:@"1"]){
                DeliverStyleLb.text = @"配送方式:到店自提";
            }else{
                DeliverStyleLb.text = @"配送方式:送货上门";
            }
            NSInteger payment = [[[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"payment"]integerValue];
            switch (payment){
                case 1:
                    PayStatusImg.image = [UIImage imageNamed:@"CashPay"];
                    break;
                case 2:
                    PayStatusImg.image = [UIImage imageNamed:@"OnLinePay"];
                    break;
                default:
                    break;
            }
            //订单状态
            NSInteger status =[[[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"status"] integerValue];
            NSInteger has_paid =[[[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"has_paid"] integerValue];
            NSInteger has_dispatched =[[[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"has_dispatched"] integerValue];
            
            //2 是确认，3和7是已完成，其余是，未完成
            if (status == 1 && has_paid == 0){
                OrderStatusLb.text = @"未接单-未支付";
                [OrderTable setTableFooterView:PrintView];
            }
            if (status == 1 && has_paid == 1){
                OrderStatusLb.text = @"未接单-已支付";
                [OrderTable setTableFooterView:PrintView];
            }
            if (status == 2 && has_paid == 0 && has_dispatched == 0){
                OrderStatusLb.text = @"已确认-未支付";
                [OrderTable setTableFooterView:FinshPrintView];
                
            }if (status == 2 && has_paid == 0 && has_dispatched == 1){
                OrderStatusLb.text = @"已确认-未支付";
                [OrderTable setTableFooterView:FinshPrintView];
                
            }if (status == 2 && has_paid == 1 && has_dispatched == 0){
                OrderStatusLb.text = @"已确认-已支付";
                [OrderTable setTableFooterView:FinshPrintView];
                
            }if (status == 2 && has_paid == 1 && has_dispatched == 1){
                OrderStatusLb.text = @"已确认-已支付";
                [OrderTable setTableFooterView:FinshPrintView];
                
            }if (status == 3 && has_paid == 0 ){
                OrderStatusLb.text = @"已完成-未支付";
                [OrderTable setTableFooterView:PrintView];
                [FinshButt setTitle:@"已完成" forState:UIControlStateNormal];
                [FinshButt setEnabled:NO];
                
            }if (status == 3 && has_paid == 1){
                OrderStatusLb.text = @"已完成-已支付";
                [OrderTable setTableFooterView:PrintView];
                [FinshButt setTitle:@"已完成" forState:UIControlStateNormal];
                [FinshButt setEnabled:NO];
            }if (status == 4 && has_paid == 0){
                OrderStatusLb.text = @"商户取消-未支付";
                [OrderTable setTableFooterView:PrintView];
                
            }if (status == 4 && has_paid == 1){
                OrderStatusLb.text = @"商户取消-已支付";
                [OrderTable setTableFooterView:PrintView];
                
            }if (status == 5 && has_paid == 0){
                OrderStatusLb.text = @"用户取消-未支付";
                [OrderTable setTableFooterView:PrintView];
                
            }if (status == 5 && has_paid == 1){
                OrderStatusLb.text = @"用户取消-已支付";
                [OrderTable setTableFooterView:PrintView];
                
            }if (status == 6 && has_paid == 0){
                OrderStatusLb.text = @"过期订单-未支付";
                
            }if (status == 6 && has_paid == 1){
                OrderStatusLb.text = @"过期订单-已支付";
                [OrderTable setTableFooterView:PrintView];
                
            }if (status == 7 && has_paid == 0){
                OrderStatusLb.text = @"已评价-未支付";
                [OrderTable setTableFooterView:PrintView];
                
            }if (status == 7 && has_paid == 1){
                OrderStatusLb.text = @"已评价-已支付";
                [OrderTable setTableFooterView:PrintView];
            }
            //获得数据
            OrderDetailArray = [OrderInfoDic objectForJSONKey:@"CallInfo"][@"itemList"];
            //实际价格
            ActPriceStr = [[OrderInfoDic objectForJSONKey:@"CallInfo"] objectForJSONKey:@"custprice"];
            [OrderTable reloadData]; //刷新列表
            //封装下方列表数据
            NSString *StrDiscount =OrderInfoDic[@"CallInfo"][@"discount"];//满减折扣
            NSString *StrGift     =OrderInfoDic[@"CallInfo"][@"gift"]; //赠品
            NSString *StrVoucher  =OrderInfoDic[@"CallInfo"][@"voucher"];//红包
            NSString *StrPrice    =OrderInfoDic[@"CallInfo"][@"price"]; //价格
            NSString *PresellDiscount=OrderInfoDic[@"CallInfo"][@"presell_discount"];//促销优惠
            NSDictionary *discountDic = [NSDictionary dictionaryWithObjectsAndKeys:StrDiscount,@"discount",nil];
            NSDictionary *giftDic = [NSDictionary dictionaryWithObjectsAndKeys:StrGift,@"gift",nil];
            NSDictionary *voucherDic = [NSDictionary dictionaryWithObjectsAndKeys:StrVoucher,@"voucher",nil];
            NSDictionary *priceDic = [NSDictionary dictionaryWithObjectsAndKeys:StrPrice,@"price",nil];
            NSDictionary *PresellDiscountDic= [NSDictionary dictionaryWithObjectsAndKeys:PresellDiscount,@"presell_discount",nil];
            ActArray = [NSMutableArray arrayWithObjects:discountDic,giftDic,voucherDic,PresellDiscountDic,priceDic,nil];
        }else{
            [[Utility Share] alertTitle:[OrderInfoDic objectForJSONKey:@"ErrorMsg"]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[Utility Share] alertTitle:[error localizedDescription]];
    }];
}


//完成订单
-(IBAction)FinshOrder:(UIButton*)sender{
    
    UIAlertView *FinshAlert = [[UIAlertView alloc] initWithTitle:@"是否完成此订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    FinshAlert.tag = 1;
    [FinshAlert show];
}

#pragma mark 打印订单
-(IBAction)PrintOrderInfo:(UIButton*)sender{
    UIAlertView *PrintAlert = [[UIAlertView alloc] initWithTitle:@"是否打印此订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    PrintAlert.tag = 2;
    [PrintAlert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSInteger tag = [alertView tag];
    if (tag == 1 && buttonIndex == 1){
        [self finshOrder];
    }
    if (tag == 2 && buttonIndex == 1){
        BLEViewController *BlPrinView = [[BLEViewController alloc]init];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"status",nil];
        NSString *ConnectStr = [BltPrintFormat ShareBLTPrint].ConnectState;
        if ([ConnectStr isEqualToString:@"1"]){
            NSDictionary *PrintDic = PrintOrderDic;
            [BlPrinView PrinInfoWithStatusDic:dic withInfoDic:PrintDic];
        }else{
            [[Utility Share] alertTitle:@"打印机未连接,请去连接打印机!"];
            [self pushNewViewController:BlPrinView];
        }
    }
}

//完成订单
-(void)finshOrder{
    
    NSString *BaseUrl = [NSString stringWithFormat:@"%@%@%@%@%@",BASEURL,DistributerOrder,OrderId,@"?uid=",[[Utility Share] userId]];
    NSString *PayLoadStr = [NSString stringWithFormat:@"%@%@%@%@",@"action=",@"finish",@"&distributerId=",[[Utility Share] userId]];
    NSString *PayLoad = [[Utility Share] base64Encode:PayLoadStr];
    NSString *urlStr = [[RestHttpRequest SharHttpRequest] ApendPubkey:BaseUrl InputResourceId:OrderId InputPayLoad:PayLoad];
    NSURL *url = [NSURL URLWithString:urlStr];
    //获得HTTP Body
    NSString *bodyStr = [[RestHttpRequest SharHttpRequest] GetHttpBody:PayLoad];
    //发送网络请求
    [[Utility Share] showHud];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    [request setHTTPMethod:@"put"];
    [request setHTTPBody: [bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *ResponseDic = responseObject;
        if ([[ResponseDic objectForJSONKey:@"Success"] isEqualToString:@"1"]){
            [[Utility Share] alertTitle:@"订单已完成"];
            [[Utility Share] hideHud];
            [self GetDetailOrderInfo];
        }else{
            [[Utility Share]alertTitle:[ResponseDic objectForJSONKey:@"ErrorMsg"]];
            [[Utility Share]hideHud];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[Utility Share] alertTitle:[error localizedDescription]];
        [[Utility Share] hideHud];
    }];
    [op start];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
