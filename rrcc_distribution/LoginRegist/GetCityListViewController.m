//
//  GetCityListViewController.m
//  rrcc_sj
//
//  Created by lawwilte on 15-5-25.
//  Copyright (c) 2015年 ting liu. All rights reserved.
// 分离数据，根据ID组装数据，并封装成一个Dic 返回过去

#import "GetCityListViewController.h"
#import "StoreInfoViewController.h"

@interface GetCityListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray  *CityListArray; //城市列表数据
    NSMutableArray  *AllArray;//所有数据
    NSArray *endArray;//筛选后的数据
    NSMutableDictionary *CityDic ;
    NSArray *ProvinceArray;//省份数据
    NSMutableArray *CityIdArray;
    __weak IBOutlet UITableView *CityListTable;
}

@end

@implementation GetCityListViewController

-(void)getCityList{
    
    [[Utility Share] showHud];
    NSString *CityUrl = [NSString stringWithFormat:@"%@%@",BASEURL,CityList];
    [[AppDelegate Share].manger GET:CityUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary *cityDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[cityDic objectForJSONKey:@"Success"] isEqualToString:@"1"]){
            CityListArray = [cityDic objectForKey:@"CallInfo"];
            //获得全国的ID
            ProvinceArray =[[NSArray  alloc] init];
            CityIdArray   =[NSMutableArray array];
            //返回所有的省市
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Parentid like %@",@"1"];
            ProvinceArray = [CityListArray filteredArrayUsingPredicate:predicate];
            for (int i = 0;i<ProvinceArray.count;i++){
                [CityIdArray addObject:[[ProvinceArray objectAtIndex:i] objectForJSONKey:@"id"]];
            }
            CityDic =[[NSMutableDictionary alloc] init];
            for (int i = 0;i<CityIdArray.count;i++){
                NSString *StrId = [CityIdArray objectAtIndex:i];
                NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"Parentid like %@",StrId];
                endArray = [CityListArray filteredArrayUsingPredicate:predicate];
                [CityDic setObject:endArray forKey:StrId];
            }
            [CityListTable reloadData];
        }
        [[Utility Share] hideHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[Utility Share] hideHud];
    }];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"城市列表";
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [CityListTable setTableFooterView:view];
    [self getCityList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [CityDic allKeys].count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *StrId = [CityIdArray objectAtIndex:section];
    NSArray *Arrary = [CityDic objectForJSONKey:StrId];
    return Arrary.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger Section = indexPath.section;
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *StrId = [CityIdArray objectAtIndex:Section];
    NSArray *Array = [CityDic objectForJSONKey:StrId];
    cell.textLabel.font = Font(13.0f);
    cell.textLabel.text = [[Array objectAtIndex:indexPath.row]  objectForJSONKey:@"RegionName"];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *rigntHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,CityListTable.frame.size.width, 30)];
    rigntHeaderView.backgroundColor = RGB(242, 242, 242);
    UILabel *headerLb = [RHMethods labelWithFrame:CGRectMake(5,2,100, 20) font:Font(15.0f) color:[UIColor blackColor] text:[[ProvinceArray objectAtIndex:section] objectForJSONKey:@"RegionName"]];
    [rigntHeaderView addSubview:headerLb];
    return rigntHeaderView;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index   = indexPath.row;
    NSInteger Section = indexPath.section;
    NSString *StrId = [CityIdArray objectAtIndex:Section];
    NSString *ProvinceName = [[ProvinceArray objectAtIndex:Section] objectForJSONKey:@"RegionName"];
    NSArray  *Array = [CityDic objectForJSONKey:StrId];
    NSDictionary *dic = [Array objectAtIndex:index];
    
    NSMutableDictionary *CityNameDic = [NSMutableDictionary dictionary];
    [CityNameDic setObject:ProvinceName forKey:@"ProvinceName"];
    [CityNameDic setObject:[dic objectForJSONKey:@"RegionName"] forKey:@"RegionName"];
    [CityNameDic setObject:[dic objectForJSONKey:@"Parentid"] forKey:@"Parentid"];
    [CityNameDic setObject:[dic objectForJSONKey:@"id"] forKey:@"id"];
    
    NSNotification *notification = [NSNotification notificationWithName:@"CityName" object:nil userInfo:CityNameDic];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



@end
