//
//  FinishVc.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/27.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "FinishVc.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "PrintFileNavCell.h"
#import "PrintFileDetail.h"
#import "NewsDetailVc.h"

@interface FinishVc ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) AFHTTPSessionManager *session;

@end

@implementation FinishVc {
    DataBase *db;
    UITableView *tableView;
    //控件组
    NSArray *arr_groupList;
    //初始控件列表
    NSArray *arr_ctlList;
    //提交的url
    NSString *str_url_postdata;
    
    NSDictionary *dic_ctl;
    
    NSMutableDictionary *dic_m_ctl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"已办审批";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"审批记录" style:UIBarButtonItemStyleDone target:self action:@selector(Submit:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barButtonItem2;
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    dic_param[@"processInstID"]=_str_processInstID;
    [self PrePareData:dic_param];
    
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)PrePareData:(NSMutableDictionary*)param {
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_urldata=_str_url;
    NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    str_urldata= [str_urldata stringByTrimmingCharactersInSet:whitespace];
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
    [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic_exp=[JSON objectForKey:@"exception"];
        if (dic_exp!=nil) {
            NSString *str_msg=[dic_exp objectForKey:@"message"];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"异常" message:str_msg cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
               
            }];
            [alert showLXAlertView];
            return;
        }
        else {
            NSDictionary *dic_result= [JSON objectForKey:@"result"];
            if (dic_result!=nil) {
                NSString *str_success=[dic_result objectForKey:@"success"];
                BOOL b_success=[str_success boolValue];
                if (b_success==YES) {
                    NSLog(@"获取界面成功!");
                    arr_groupList=[dic_result objectForKey:@"groupList"];
                    arr_ctlList=[dic_result objectForKey:@"ctlList"];
                    dic_ctl=[self manageData:arr_groupList ctlList:arr_ctlList];
                    dic_m_ctl=[self DispalyUIAdvance:dic_ctl];
                    str_url_postdata=[dic_result objectForKey:@"url"];
                    [tableView reloadData];
                }
            }
            else {
                NSString *str_success=[JSON objectForKey:@"success"];
                BOOL b_success=[str_success boolValue];
                if (b_success==YES) {
                    NSLog(@"获取界面成功!");
                    arr_groupList=[JSON objectForKey:@"groupList"];
                    arr_ctlList=[JSON objectForKey:@"ctlList"];
                    dic_ctl=[self manageData:arr_groupList ctlList:arr_ctlList];
                    dic_m_ctl=[self DispalyUIAdvance:dic_ctl];
                    str_url_postdata=[JSON objectForKey:@"url"];
                    [tableView reloadData];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取界面失败");
    }];
    
}



-(NSDictionary*)manageData:(NSArray*)groupList ctlList:(NSArray*)ctlList {
    NSMutableDictionary *dic_tmp=[NSMutableDictionary dictionaryWithCapacity:1];
    for (int i=0;i<[groupList count];i++) {
        NSDictionary *dic_group=[groupList objectAtIndex:i];
        NSString *str_key=[dic_group objectForKey:@"groupKey"];
        NSMutableArray *arr_array=[[NSMutableArray alloc]init];
        for (int j=0;j<[ctlList count];j++) {
            NSDictionary *dic_ctll=[ctlList objectAtIndex:j];
            NSString *str_key2=[dic_ctll objectForKey:@"groupKey"];
            if ([str_key isEqualToString:str_key2]) {
                [arr_array addObject:dic_ctll];
            }
        }
        NSString *str_index=[NSString stringWithFormat:@"%d",i];
        [dic_tmp setValue:arr_array forKey:str_index];
    }
    
    return dic_tmp;
}


-(void)Submit:(UIButton*)sender {
    //提交申请
    // NSMutableDictionary *dic_submit=[[NSMutableDictionary alloc]init];
   
    
}


#pragma mark tableView方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([arr_groupList count]==0) {
        return 1;
    }
    else {
        return [arr_groupList count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dic_ctl count]==0) {
        return 1;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)section];
        NSArray *arr_ctl= [dic_ctl objectForKey:str_index];
        NSInteger i_count=0;
        for (int i=0;i<[arr_ctl count];i++) {
            NSDictionary *dic_tmp=[arr_ctl objectAtIndex:i];
            NSString *str_type= [dic_tmp objectForKey:@"type"];
            if ([str_type isEqualToString:@"hidden"]) {
                //i_count=i_count+1;
            }
            else if ([str_type isEqualToString:@"tableView"]) {
                NSArray *arr_list=[dic_tmp objectForKey:@"tableData"];
                i_count=i_count+[arr_list count];
            }
            else {
                i_count=i_count+1;
            }
        }
        return i_count;

    }
}

-(UITableViewCell*)tableView:(UITableView *)tb cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=@"cellId";
    UITableViewCell *cell=[tb dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    
    UIView *leftView=[[UIView alloc]init];
    UIView *rightView=[[UIView alloc]init];
    if (iPhone5_5s || iPhone4_4s) {
        [leftView setFrame:CGRectMake(0, 0, 100, cell.frame.size.height)];
        [rightView setFrame:CGRectMake(100, 0, 220, cell.frame.size.height)];
    }
    else if (iPhone6) {
        [leftView setFrame:CGRectMake(0, 0, 105, cell.frame.size.height)];
        [rightView setFrame:CGRectMake(105, 0, 270, cell.frame.size.height)];
    }
    else {
        [leftView setFrame:CGRectMake(0, 0, 113, cell.frame.size.height)];
        [rightView setFrame:CGRectMake(113, 0, 301, cell.frame.size.height)];
    }
    if (indexPath.row%2==0) {
        if (indexPath.row!=0) {
            leftView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
            rightView.backgroundColor=[UIColor whiteColor];
        }
    }
    else {
        leftView.backgroundColor=[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
        rightView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    }

    
    
    if ([dic_ctl count]==0) {
        cell.textLabel.text=@"";
        return cell;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
        NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
        NSDictionary  *dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
        NSString *str_type=[dic_tmp objectForKey:@"type"];
        if ([str_type isEqualToString:@"text"] || [str_type isEqualToString:@"int"] || [str_type isEqualToString:@"date"] || [str_type isEqualToString:@"textarea"]) {
            NSString *str_label=[dic_tmp objectForKey:@"label"];
            NSObject *obj_value=[dic_tmp objectForKey:@"value"];
            NSString *str_value=@"";
            if (obj_value!=[NSNull null]) {
                str_value=(NSString*)obj_value;
            }
            cell.textLabel.text=str_label;
            cell.detailTextLabel.text=str_value;
            cell.detailTextLabel.numberOfLines=0;
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.detailTextLabel.backgroundColor=[UIColor clearColor];
            
            return cell;
        }
        else if ([str_type isEqualToString:@"tableView"]) {
            NSArray *arr_title=[dic_tmp objectForKey:@"tableTitle"];
            NSArray *arr_data=[dic_tmp objectForKey:@"tableDataContent"];
            NSString *str_titlename=[arr_title objectAtIndex:0];
            NSString *str_title=[arr_data objectAtIndex:0];
            PrintFileNavCell *cell=[PrintFileNavCell cellWithTable:tb withTitle:str_title withTileName:str_titlename atIndexPath:indexPath];
            cell.file_data=arr_data;
            cell.file_title=arr_title;
            return cell;   
        }
        else if ([str_type isEqualToString:@"list"]) {
            NSString *str_label=[dic_tmp objectForKey:@"label"];
            NSObject *obj_value=[dic_tmp objectForKey:@"value"];
            NSString *str_value=@"";
            if (obj_value!=[NSNull null]) {
                str_value=(NSString*)obj_value;
            }
            NSArray *arr_listData=[dic_tmp objectForKey:@"listData"];
            NSInteger i_value=[str_value integerValue];
            NSString *str_detail_value=@"";
            NSString *str_value2=[NSString stringWithFormat:@"%ld",(long)i_value];

            for (int l=0;l<[arr_listData count];l++) {
                NSDictionary *dic= [arr_listData objectAtIndex:l];
                NSString *str_tmp=[dic objectForKey:@"value"];
                if ([str_tmp isEqualToString:str_value2]) {
                    str_detail_value=[dic objectForKey:@"label"];
                }
                
            }
            cell.textLabel.text=str_label;
            cell.detailTextLabel.text=str_detail_value;
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        }
        else if ([str_type isEqualToString:@"html"]) {
            NSString *str_label=[dic_tmp objectForKey:@"label"];
            cell.textLabel.text=str_label;
            cell.detailTextLabel.textColor=[UIColor blueColor];
            cell.detailTextLabel.text=@"请点击查看";
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.detailTextLabel.backgroundColor=[UIColor clearColor];
            cell.accessibilityHint=@"html";
            cell.accessibilityValue=[dic_tmp objectForKey:@"value"];
        }
        else {
            cell.textLabel.text=@"";
        }
       
        
    }
    [cell.contentView addSubview:leftView];
    [cell.contentView addSubview:rightView];
    [cell.contentView sendSubviewToBack:leftView];
    [cell.contentView sendSubviewToBack:rightView];
    return  cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor clearColor];
    CGRect view_title;
    view_title=CGRectMake(0, 0, self.view.frame.size.width, 30);
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    lbl_sectionTitle.textAlignment=NSTextAlignmentLeft;
    lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    NSDictionary *dic_group=[arr_groupList objectAtIndex:section];
    NSString *str_label=[dic_group objectForKey:@"label"];
    if (str_label!=nil) {
        lbl_sectionTitle.text=[NSString stringWithFormat:@"     %@",str_label];
    }
    else {
        lbl_sectionTitle.text=@"请稍后,正在加载中...";
    }
    [view addSubview:lbl_sectionTitle];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
    NSDictionary  *dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
    NSObject *obj_value=[dic_tmp objectForKey:@"value"];
    NSString *str_value=@"";
    if (obj_value!=[NSNull null]) {
        str_value=(NSString*)obj_value;
    }
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [str_value sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(tableView.frame.size.width, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    return size.height+20;
}
*/

-(void)tableView:(UITableView *)tb didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tb cellForRowAtIndexPath:indexPath];
    if ([cell isMemberOfClass:[PrintFileNavCell class]]) {
        PrintFileNavCell *cell_nav=(PrintFileNavCell*)cell;
        NSArray *tmp_Files=cell_nav.file_data;
        NSArray *tmp_Title=cell_nav.file_title;
        PrintFileDetail *viewController=[[PrintFileDetail alloc]init];
        viewController.arr_data=tmp_Files;
        viewController.arr_title=tmp_Title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([cell.accessibilityHint isEqualToString:@"html"]) {
        NewsDetailVc *vc=[[NewsDetailVc alloc]init];
        vc.str_value=cell.accessibilityValue;
        vc.str_title2=cell.textLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//去掉hidden属性的UI数据
-(NSMutableDictionary*)DispalyUIAdvance:(NSDictionary*)dic_control{
    NSMutableDictionary *dic_my_ctl=[dic_control mutableCopy];
    for (int i=0;i<[dic_my_ctl count];i++) {
        NSString *str_index=[NSString stringWithFormat:@"%d",i];
        NSMutableArray *arr_my_ctl=[dic_my_ctl objectForKey:str_index];
        for (int j=0;j<[arr_my_ctl count];j++) {
            NSDictionary *dic_sub_ctl=[arr_my_ctl objectAtIndex:j];
            NSString *str_sub_type=[dic_sub_ctl objectForKey:@"type"];
            if ([str_sub_type isEqualToString:@"hidden"]) {
                [arr_my_ctl removeObject:dic_sub_ctl];
            }
            else if ([str_sub_type isEqualToString:@"tableView"]) {
                NSArray *arr_tabledata=[dic_sub_ctl objectForKey:@"tableData"];
                NSUInteger i_count=[arr_tabledata count];
                [arr_my_ctl removeAllObjects];
                for (int l=0;l<i_count;l++) {
                    [arr_my_ctl addObject:dic_sub_ctl];
                }
                for (int l=0;l<i_count;l++) {
                    NSDictionary *dic_tmp_ctl=[arr_my_ctl objectAtIndex:l];
                    [dic_tmp_ctl setValue:[arr_tabledata objectAtIndex:l] forKey:@"tableDataCotent"];
                }
            }
        }
    }
    return dic_my_ctl;
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
