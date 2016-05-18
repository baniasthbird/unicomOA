//
//  NewApplication.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewApplication.h"
#import "PrintApplication.h"
#import "CarApplication.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"

@interface NewApplication()<UITableViewDelegate,UITableViewDataSource,CarApplicationDelegate,PrintApplicationDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (nonatomic,strong) AFHTTPSessionManager *session;

//能发起的流程
@property (nonatomic,strong) NSArray *arr_sop;

//流程组
@property (nonatomic,strong) NSArray *arr_groupList;

//数据组织后的行列数据
@property (nonatomic,strong) NSDictionary *dic_rowsection;

//数据组织后的数据
@property (nonatomic,strong) NSDictionary *dic_data;

@end

@implementation NewApplication {
    DataBase *db;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选择申请流程";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    _arr_sop=[[NSMutableArray alloc]init];

    _arr_groupList=[[NSMutableArray alloc]init];
    [self AvaliableSOP];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.05, self.view.frame.size.width, self.view.frame.size.height*0.3) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableView 方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_arr_groupList count]==0) {
       return 1;
    }
    else {
        return [_arr_groupList count];
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_arr_sop count]==0) {
        return 2;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)section];
        NSString *str_rownum= [_dic_rowsection objectForKey:str_index];
        NSInteger i_rownum=[str_rownum integerValue];
        return i_rownum;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    if (_dic_data==nil) {
        cell.textLabel.text=@"aaa";
    }
    else {
        NSString *str_section=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
        NSArray *arr_sub_data=[_dic_data objectForKey:str_section];
        NSDictionary *dic_sub_data=[arr_sub_data objectAtIndex:indexPath.row];
        NSString *str_label=[dic_sub_data objectForKey:@"label"];
        cell.textLabel.text=str_label;
    }
    
    
   // UIImageView *img_icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    /*
    UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.font=[UIFont systemFontOfSize:16];
    lbl_title.textAlignment=NSTextAlignmentLeft;
    */
    
    if (indexPath.row==0) {
        //cell.imageView.image=[UIImage imageNamed:@"printmission.png"];
    //    img_icon.image=[UIImage imageNamed:@"printmission.png"];
     //   lbl_title.text=@"复印申请";
    }
    else if (indexPath.row==1) {
       // cell.imageView.image=[UIImage imageNamed:@"carmission.png"];
   //     img_icon.image=[UIImage imageNamed:@"carmission.png"];
    //    lbl_title.text=@"预约用车";
    }
  //  [cell.contentView addSubview:img_icon];
  //  [cell.contentView addSubview:lbl_title];
    //[cell.imageView setFrame:CGRectMake(10, 10, 10, 10)];
    //[cell.imageView setFrame:CGRectMake(0, 0, 50, 50)];

    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        PrintApplication *viewController=[[PrintApplication alloc]init];
        viewController.delegate=self;
        viewController.userInfo=_userInfo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row==1) {
        CarApplication *viewController=[[CarApplication alloc]init];
        viewController.delegate=self;
        viewController.userInfo=_userInfo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)PassCarValue:(NSString *)str_reason CarObject:(CarService *)carservice {
    [_delegate PassValueFromCarApplication:str_reason CarObject:carservice];
}

-(void)PassPrintValue:(NSString *)str_title PrintObject:(PrintService *)service{
    [_delegate PassValueFromPrintApplication:str_title PrintObject:service];
}

//可用的流程
-(void)AvaliableSOP {
    NSString *str_TaskAudit= [db fetchInterface:@"TaskAudit"];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_TaskAudit];
    [_session POST:str_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取能发起的流程成功");
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *str_success= [JSON objectForKey:@"success"];
        BOOL b_success=[str_success boolValue];
        if (b_success==YES) {
            _arr_sop=[JSON objectForKey:@"list"];
            _arr_groupList=[JSON objectForKey:@"groupList"];
            _dic_rowsection=[self manageRowSectionData:_arr_sop groupList:_arr_groupList];
            _dic_data=[self manageData:_arr_sop groupList:_arr_groupList];
            [self.tableView reloadData];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取能发起的流程失败");
    }];
}


//整理获取的数据，重新布局界面的section和row
-(NSMutableDictionary*)manageRowSectionData:(NSArray*)arr_sop groupList:(NSArray*)arr_groupList {
    NSMutableDictionary *dic_tmp=[NSMutableDictionary dictionaryWithCapacity:2];
    int i_count=0;
    for (int i=0;i<arr_groupList.count;i++) {
        NSDictionary *dic_group=[arr_groupList objectAtIndex:i];
        NSString *str_key=[dic_group objectForKey:@"key"];
        for (int j=0;j<arr_sop.count;j++) {
            NSDictionary *dic_sop=[arr_sop objectAtIndex:j];
            NSString *str_keygroup=[dic_sop objectForKey:@"groupKey"];
            if ([str_keygroup isEqualToString:str_key]) {
                i_count++;
            }
        }
        NSString *str_index=[NSString stringWithFormat:@"%d",i];
        NSString *str_count=[NSString stringWithFormat:@"%d",i_count];
        [dic_tmp setValue:str_count forKey:str_index];
        i_count=0;
    }
    return dic_tmp;
}


//整理获取的数据，并组织数据
-(NSMutableDictionary*)manageData:(NSArray*)arr_sop groupList:(NSArray*)arr_groupList {
    NSMutableDictionary *dic_tmp=[NSMutableDictionary dictionaryWithCapacity:2];
    for (int i=0;i<arr_groupList.count;i++) {
        NSDictionary *dic_group=[arr_groupList objectAtIndex:i];
        NSString *str_key=[dic_group objectForKey:@"key"];
        NSMutableArray *arr_array=[[NSMutableArray alloc]init];
        for (int j=0;j<arr_sop.count;j++) {
            NSDictionary *dic_sop=[arr_sop objectAtIndex:j];
            NSString *str_keygroup=[dic_sop objectForKey:@"groupKey"];
            if ([str_keygroup isEqualToString:str_key]) {
                [arr_array addObject:dic_sop];
            }
            NSString *str_index=[NSString stringWithFormat:@"%d",i];
            [dic_tmp setValue:arr_array forKey:str_index];
        }
    }
    return dic_tmp;
}

@end
