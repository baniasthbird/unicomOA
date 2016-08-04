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
#import "ShenPiQueryLogVC.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "ShenPiResultCell.h"

@interface FinishVc ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

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
    
    UIActivityIndicatorView *indicator;
    
    NSArray *arr_ShenPiQueryList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"已办审批";
    
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"审批记录" style:UIBarButtonItemStyleDone target:self action:@selector(Submit:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
   // self.navigationItem.rightBarButtonItem=barButtonItem2;
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    //侧滑返回
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    
    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
    _baseFunc=[[BaseFunction alloc]init];
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    indicator=[self AddLoop];
    
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    dic_param[@"processInstID"]=_str_processInstID;
    [self PrePareData:dic_param];
    
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    _refreshControl=[[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [tableView addSubview:_refreshControl];
    
    [self.view addSubview:tableView];
    
    [indicator startAnimating];
    [self.view addSubview:indicator];
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)PrePareData:(NSMutableDictionary*)param {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        __block NSString *str_ip=@"";
        __block NSString *str_port=@"";
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
            [_refreshControl endRefreshing];
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic_exp=[JSON objectForKey:@"exception"];
            if (dic_exp!=nil) {
                [indicator stopAnimating];
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
                        [indicator stopAnimating];
                        NSLog(@"获取界面成功!");
                        arr_groupList=[dic_result objectForKey:@"groupList"];
                        arr_ctlList=[dic_result objectForKey:@"ctlList"];
                        dic_ctl=[self manageData:arr_groupList ctlList:arr_ctlList];
                        dic_m_ctl=[self DispalyUIAdvance:dic_ctl];
                        str_url_postdata=[dic_result objectForKey:@"url"];
                        
                        [self PrePareQueryLog:param ip:str_ip port:str_port];
                      //  [tableView reloadData];
                    }
                }
                else {
                    NSString *str_success=[JSON objectForKey:@"success"];
                    BOOL b_success=[str_success boolValue];
                    if (b_success==YES) {
                        [indicator stopAnimating];
                        NSLog(@"获取界面成功!");
                        arr_groupList=[JSON objectForKey:@"groupList"];
                        arr_ctlList=[JSON objectForKey:@"ctlList"];
                        dic_ctl=[self manageData:arr_groupList ctlList:arr_ctlList];
                        dic_m_ctl=[self DispalyUIAdvance:dic_ctl];
                        str_url_postdata=[JSON objectForKey:@"url"];
                         [self PrePareQueryLog:param ip:str_ip port:str_port];
                      //  [tableView reloadData];
                    }
                    else {
                        [indicator stopAnimating];
                        [_refreshControl endRefreshing];
                        NSString *str_msg=[_baseFunc GetValueFromDic:JSON key:@"msg"];
                        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str_msg cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                            
                        }];
                        [alert showLXAlertView];
                        [self.navigationController popViewControllerAnimated:NO];
                        
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [_refreshControl endRefreshing];
            [indicator stopAnimating];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"无法连接到服务器" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
        }];
    }
    else {
        [_refreshControl endRefreshing];
        [indicator stopAnimating];
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    
}


-(void)PrePareQueryLog:(NSMutableDictionary*)param ip:(NSString*)str_ip port:(NSString*)str_port {
   // NSString *str_connection=[self GetConnectionStatus];
   // if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
    //    NSString *str_ip=@"";
    //    NSString *str_port=@"";
    //    NSMutableArray *t_array=[db fetchIPAddress];
   //     if (t_array.count==1) {
   //         NSArray *arr_ip=[t_array objectAtIndex:0];
   //         str_ip=[arr_ip objectAtIndex:0];
   //         str_port=[arr_ip objectAtIndex:1];
   //     }
        
        
        NSString *str_urldata=[db fetchInterface:@"TaskLog"];
        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
        str_urldata= [str_urldata stringByTrimmingCharactersInSet:whitespace];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success=[JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                [indicator stopAnimating];
                arr_ShenPiQueryList=[JSON objectForKey:@"list"];
                [tableView reloadData];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            [_refreshControl endRefreshing];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"无法连接到服务器" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
        }];
    
    /*
    }
    else {
        [indicator stopAnimating];
        [_refreshControl endRefreshing];
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    */
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
    ShenPiQueryLogVC *vc=[[ShenPiQueryLogVC alloc]init];
    vc.str_processInstID=_str_processInstID;
    vc.str_titleName=_str_title;
    [self.navigationController pushViewController:vc animated:NO];
    
}

-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}

#pragma mark tableView方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([arr_groupList count]==0) {
        return 1;
    }
    else {
        return [arr_groupList count]+1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dic_ctl count]==0) {
        return 1;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)section];
        if (section<[dic_m_ctl count]) {
            NSArray *arr_ctl= [dic_m_ctl objectForKey:str_index];
            NSInteger i_count=0;
            for (int i=0;i<[arr_ctl count];i++) {
                NSDictionary *dic_tmp=[arr_ctl objectAtIndex:i];
                NSString *str_type= [dic_tmp objectForKey:@"type"];
                if (![str_type isEqualToString:@"hidden"]) {
                    i_count=i_count+1;
                }
                /*
                 else if ([str_type isEqualToString:@"tableView"]) {
                 NSArray *arr_list=[dic_tmp objectForKey:@"tableData"];
                 i_count=i_count+[arr_list count];
                 }
                 */
            }
            return i_count;
        }
        else {
            return  [arr_ShenPiQueryList count];
        }
        
    }
}

-(UITableViewCell*)tableView:(UITableView *)tb cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=@"cellId";
    UITableViewCell *cell=[tb dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row%2==0) {
        cell.textLabel.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
        cell.detailTextLabel.backgroundColor=[UIColor whiteColor];
    }
    else {
        cell.textLabel.backgroundColor=[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
        cell.detailTextLabel.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    }
    
    /*
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
        else {
            leftView.backgroundColor=[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
            rightView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
        }
        [cell.contentView addSubview:leftView];
        [cell.contentView addSubview:rightView];
        [cell.contentView sendSubviewToBack:leftView];
        [cell.contentView sendSubviewToBack:rightView];

    }
   */
    
    
    if ([dic_ctl count]==0) {
        cell.textLabel.text=@"";
        return cell;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
        if (indexPath.section<[dic_m_ctl count]) {
            NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
            NSDictionary  *dic_tmp;
            if (indexPath.row<[arr_tmp count]) {
                dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
            }
            else {
                int i=0;
                i=i+1;
            }
            NSString *str_type=[dic_tmp objectForKey:@"type"];
            if ([str_type isEqualToString:@"text"] || [str_type isEqualToString:@"int"] || [str_type isEqualToString:@"date"] || [str_type isEqualToString:@"textarea"]|| [str_type isEqualToString:@"datetime"] || [str_type isEqualToString:@"FLOAT"]) {
                NSString *str_label=[dic_tmp objectForKey:@"label"];
                NSString *str_value=[_baseFunc GetValueFromDic:dic_tmp key:@"value"];
                cell.textLabel.text=str_label;
                cell.textLabel.numberOfLines=0;
                cell.detailTextLabel.text=str_value;
                cell.detailTextLabel.numberOfLines=0;
                cell.textLabel.backgroundColor=[UIColor clearColor];
                cell.detailTextLabel.backgroundColor=[UIColor clearColor];
                
                return cell;
            }
            else if ([str_type isEqualToString:@"tableView"]) {
                NSArray *arr_title=[dic_tmp objectForKey:@"tableTitle"];
                NSArray *arr_data=[dic_tmp objectForKey:@"tableData"];
                if ([arr_data count]>0) {
                    NSString *str_index=[dic_tmp objectForKey:@"tableIndex"];
                    NSObject *obj_tableData=[arr_data objectAtIndex:[str_index integerValue]];
                    if (obj_tableData!=[NSNull null]) {
                        NSArray *arr_tableData=(NSArray*)obj_tableData;
                        if ([arr_tableData count]>0) {
                            NSObject *obj_titlename=[arr_tableData objectAtIndex:0];
                            NSString *str_titlename=@"";
                            if (obj_titlename!=[NSNull null]) {
                                str_titlename=(NSString*)obj_titlename;
                            }
                            NSObject *obj_title=[arr_tableData objectAtIndex:1];
                            NSString *str_title=@"";
                            if (obj_title!=[NSNull null]) {
                                str_title=(NSString*)obj_title;
                            }
                            NSObject *obj_label=[dic_tmp objectForKey:@"label"];
                            NSString *str_label=@"";
                            if (obj_label!=[NSNull null]) {
                                str_label=(NSString*)obj_label;
                            }
                            PrintFileNavCell *cell=[PrintFileNavCell cellWithTable:tb withTitle:str_title withTileName:str_index withLabel:str_label atIndexPath:indexPath];
                            cell.file_data=arr_tableData;
                            cell.file_title=arr_title;
                            cell.str_label=str_label;
                            return cell;
                        }
                    }
                }
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
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.textColor=[UIColor blueColor];
            }
            else {
                cell.textLabel.text=@"";
            }

        }
        else {
            NSDictionary *dic_tmp=[arr_ShenPiQueryList objectAtIndex:indexPath.row];
            NSString *str_name=[dic_tmp objectForKey:@"name"];
            NSObject *obj_content=[dic_tmp objectForKey:@"content"];
            NSString *str_content=@"";
            if (obj_content!=[NSNull null]) {
                str_content=(NSString*)obj_content;
            }
            NSString *str_decision=[dic_tmp objectForKey:@"decision"];
            NSString *str_date=[dic_tmp objectForKey:@"endTime"];
            NSArray *arr_date=[str_date componentsSeparatedByString:@"."];
            str_date=[arr_date objectAtIndex:0];
            NSString *str_activename=[dic_tmp objectForKey:@"activityName"];
            NSString *str_status=@"";
            str_status=str_decision;
            ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withContent:str_content withName:str_name withStatus:str_status withTime:str_date ActivityName:str_activename atIndex:indexPath];
            return cell;
            
        }
        
        
    }
    
    return  cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    view.backgroundColor=[UIColor clearColor];
    CGRect view_title;
    view_title=CGRectMake(0, 0, self.view.frame.size.width, 30);
    UILabel *lbl_sectionTitle=[[UILabel alloc]initWithFrame:view_title];
    lbl_sectionTitle.textAlignment=NSTextAlignmentCenter;
    lbl_sectionTitle.font=[UIFont boldSystemFontOfSize:17];
    lbl_sectionTitle.backgroundColor=[UIColor whiteColor];
    if (arr_groupList==nil) {
        lbl_sectionTitle.text=@"请稍后,正在加载中...";
    }
    else {
        if (section<[arr_groupList count]) {
            NSDictionary *dic_group=[arr_groupList objectAtIndex:section];
            NSString *str_label=[dic_group objectForKey:@"label"];
            if (str_label!=nil) {
                lbl_sectionTitle.text=[NSString stringWithFormat:@"%@",str_label];
            }
            else {
                lbl_sectionTitle.text=@"请稍后,正在加载中...";
            }
        }
        else {
            lbl_sectionTitle.text=@"审批记录";
        }
 
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
        NSString *str_title=cell_nav.str_label;
        PrintFileDetail *viewController=[[PrintFileDetail alloc]init];
        viewController.arr_data=tmp_Files;
        viewController.arr_title=tmp_Title;
        viewController.str_title=str_title;
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else if ([cell.accessibilityHint isEqualToString:@"html"]) {
        NewsDetailVc *vc=[[NewsDetailVc alloc]init];
        vc.str_value=cell.accessibilityValue;
        vc.str_title2=cell.textLabel.text;
        [self.navigationController pushViewController:vc animated:NO];
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
                [arr_my_ctl removeObjectAtIndex:j];
                NSUInteger i_count=[arr_tabledata count];
                if (i_count>0) {
                    for (int l=0;l<i_count;l++) {
                        /*
                         NSMutableArray *arr_data=[[arr_tabledata objectAtIndex:l] mutableCopy];
                         [dic_sub_ctl setValue:arr_data forKey:@"tableDataContent"];
                         */
                        NSString *str_index=[NSString stringWithFormat:@"%d",l];
                        NSDictionary *dic_tmp=[dic_sub_ctl mutableCopy];
                        [dic_tmp setValue:str_index forKey:@"tableIndex"];
                        [arr_my_ctl insertObject:dic_tmp atIndex:j+l];
                    }
                    j=j+(int)i_count;
                }
            }
        }
    }
    return dic_my_ctl;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
    if (indexPath.section<[dic_m_ctl count]) {
        NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
        if (indexPath.row<[arr_tmp count]) {
            NSDictionary  *dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
            NSString *str_type=[dic_tmp objectForKey:@"type"];
            if ([str_type isEqualToString:@"textarea"]) {
                //if (b_readonly==YES) {
                NSObject *obj_label=[dic_tmp objectForKey:@"label"];
                NSString *str_label=@"";
                if (obj_label!=[NSNull null]) {
                    str_label=(NSString*)obj_label;
                }
                NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                NSString *str_value=@"";
                if (obj_value!=[NSNull null]) {
                    str_value=(NSString*)obj_value;
                }
                if (![str_value isEqualToString:@""] || ![str_label isEqualToString:@""]) {
                    CGFloat rowHeightValue=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width*0.4 title:str_value font:[UIFont systemFontOfSize:14]];
                    CGFloat rowHeightLabel=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width*0.1 title:str_label font:[UIFont systemFontOfSize:14]];
                    if (rowHeightLabel>rowHeightValue)
                    {
                        if (rowHeightLabel>34) {
                            return  rowHeightLabel+10;
                        }
                        else {
                            return 44;
                        }
                    }
                    else {
                        if (rowHeightValue>34) {
                            return rowHeightValue+10;
                        }
                        else {
                            return  44;
                        }
                        
                    }
                    
                    
                }
                else {
                    return  44;
                    
                }
            }
            else if ([str_type isEqualToString:@"text"]){
                NSObject *obj_label=[dic_tmp objectForKey:@"label"];
                NSString *str_label=@"";
                if (obj_label!=[NSNull null]) {
                    str_label=(NSString*)obj_label;
                }
                NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                NSString *str_value=@"";
                if (obj_value!=[NSNull null]) {
                    str_value=(NSString*)obj_value;
                }
                if (![str_value isEqualToString:@""] || ![str_label isEqualToString:@""]) {
                    CGFloat rowHeightValue=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width*0.4 title:str_value font:[UIFont systemFontOfSize:14]];
                    CGFloat rowHeightLabel=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width*0.1 title:str_label font:[UIFont systemFontOfSize:14]];
                    if (rowHeightLabel>rowHeightValue)
                    {
                        if (rowHeightLabel>34) {
                            return rowHeightLabel+10;
                        }
                        else {
                            return  44;
                        }
                    }
                    else {
                        if (rowHeightValue>34) {
                            return rowHeightValue+10;
                        }
                        else {
                            return 44;
                        }
                    }
                }
                else {
                    return 44;
                }
                
            }
            else {
                return 44;
            }
            
        }
        else {
            return  44;
        }

    }
    else {
        return 80;
    }
    
}


//添加菊花等待图标
-(UIActivityIndicatorView*)AddLoop {
    //初始化:
    UIActivityIndicatorView *l_indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    l_indicator.tag = 103;
    
    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    l_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    
    //设置背景色
    l_indicator.backgroundColor = [UIColor blackColor];
    
    //设置背景透明
    l_indicator.alpha = 0.5;
    
    //设置背景为圆角矩形
    l_indicator.layer.cornerRadius = 6;
    l_indicator.layer.masksToBounds = YES;
    //设置显示位置
    [l_indicator setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    return l_indicator;
}


-(void)handleRefresh:(id)paramSender {
    // 模拟2秒后刷新数据
    int64_t delayInSeconds = 2.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
        dic_param[@"processInstID"]=_str_processInstID;
        [self PrePareData:dic_param];
        //tableview中插入一条数据
        //[self NewsList:_news_param];
        
    });
    
    
}


// 什么时候调用，每次触发手势之前都会询问下代理方法，是否触发
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1)
    {
        return NO;
    }
    
    return YES;
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer*)sender {
    
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
