//
//  UnFinishVc.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/27.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "UnFinishVc.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "PrintFileNavCell.h"
#import "PrintFileDetail.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "TableViewCell.h"
#import "PrintApplicationDetailCell.h"
#import "ListFileController.h"
#import "NewsDetailVc.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "ShenPiQueryLogVC.h"
#import "ListCell.h"
#import "ShenPiResultCell.h"


@interface UnFinishVc ()<UITableViewDataSource,UITableViewDelegate,ListFileControllerDelegate,PrintApplicationDetailCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) UIRefreshControl *refreshControl;


@end

@implementation UnFinishVc {
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
    
    NSMutableDictionary *dic_bkvalue;
    
    NSString *str_selected;
    
    NSString *str_ip;
    NSString *str_port;
    
    UIActivityIndicatorView *indicator;
    
    NSArray *arr_ShenPiQueryList;
    
    BOOL b_Table;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"待办审批";
    
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"审批记录" style:UIBarButtonItemStyleDone target:self action:@selector(QueryLog:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(Submit:)];
    [barButtonItem3 setTitleTextAttributes:dict forState:UIControlStateNormal];
    //self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:barButtonItem3,barButtonItem2, nil];
    //self.navigationItem.rightBarButtonItem=barButtonItem2;
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    //侧滑返回
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    
    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    panGesture.delegate = self; // 设置手势代理，拦截手势触发
    [self.view addGestureRecognizer:panGesture];
    
    // 一定要禁止系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    b_Table=NO;
    
    indicator=[self AddLoop];
    // Do any additional setup after loading the view.
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    dic_param[@"processInstID"]=_str_processInstID;
    dic_param[@"activityDefID"]=_str_activityDefID;
    dic_param[@"workItemID"]=_str_workItemID;
    [self PrePareData:dic_param];
    
    dic_bkvalue=[NSMutableDictionary dictionary];
    
    tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60) style:UITableViewStyleGrouped];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MovePreviousVc:(UIButton*)sender {
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)PrePareData:(NSMutableDictionary*)param {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
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
            NSLog(@"返回成功%@",responseObject);
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
                        [_refreshControl endRefreshing];
                        [indicator stopAnimating];
                        NSLog(@"获取界面成功!");
                        arr_groupList=[dic_result objectForKey:@"groupList"];
                        arr_ctlList=[dic_result objectForKey:@"ctlList"];
                        dic_ctl=[self manageData:arr_groupList ctlList:arr_ctlList];
                        str_url_postdata=[dic_result objectForKey:@"url"];
                        dic_m_ctl=[self DispalyUIAdvance:dic_ctl];
                        NSMutableDictionary *dic_querylog=[NSMutableDictionary dictionary];
                        dic_querylog[@"processInstID"]=_str_processInstID;
                        [self PrePareQueryLog:dic_querylog ip:str_ip port:str_port];
                       // dic_querylog[@"processInstI"]
                       // [tableView reloadData];
                    }
                }
                else {
                    NSString *str_success=[JSON objectForKey:@"success"];
                    BOOL b_success=[str_success boolValue];
                    if (b_success==YES) {
                        [indicator stopAnimating];
                        [_refreshControl endRefreshing];
                        NSLog(@"获取界面成功!");
                        arr_groupList=[JSON objectForKey:@"groupList"];
                        arr_ctlList=[JSON objectForKey:@"ctlList"];
                        dic_ctl=[self manageData:arr_groupList ctlList:arr_ctlList];
                        str_url_postdata=[JSON objectForKey:@"url"];
                        dic_m_ctl=[self DispalyUIAdvance:dic_ctl];
                        NSMutableDictionary *dic_querylog=[NSMutableDictionary dictionary];
                        dic_querylog[@"processInstID"]=_str_processInstID;
                        [self PrePareQueryLog:dic_querylog ip:str_ip port:str_port];

                       // [tableView reloadData];
                    }
                    else {
                        [indicator stopAnimating];
                        [_refreshControl endRefreshing];
                        NSObject *obj_msg= [JSON objectForKey:@"msg"];
                        NSString *str_msg=@"";
                        if (obj_msg!=[NSNull null]) {
                            str_msg=(NSString*)obj_msg;
                        }
                        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str_msg cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                            
                        }];
                        [alert showLXAlertView];
                        if (f_v<9.0) {
                            self.navigationController.delegate=nil;
                        }
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            [_refreshControl endRefreshing];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"无法连接到服务器" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
            NSString *str_error=[NSString stringWithFormat:@"%@",error];
            NSLog(@"%@%@",@"问题是",str_error);
        }];
    }
    else {
        [indicator stopAnimating];
        [_refreshControl endRefreshing];
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    
}

//组织数据，去掉hidden
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

//根据js ajax规范，修改key值，调整.为/
-(NSString*)modifykey:(NSString*)str_key {
    NSString *str_return=[str_key stringByReplacingOccurrencesOfString:@"." withString:@"/"];
    return str_return;
}

-(void)QueryLog:(UIButton*)sender {
    ShenPiQueryLogVC *vc=[[ShenPiQueryLogVC alloc]init];
    vc.str_processInstID=_str_processInstID;
    vc.str_titleName=_str_title;
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:vc animated:NO];
}


-(void)Submit:(UIButton*)sender {
    //提交申请
    // NSMutableDictionary *dic_submit=[[NSMutableDictionary alloc]init];
    if (str_url_postdata!=nil) {
       
      
        
        NSString *str_urldata=str_url_postdata;
        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
        str_urldata= [str_urldata stringByTrimmingCharactersInSet:whitespace];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        for (int i=0;i<[arr_ctlList count];i++) {
            NSDictionary *dic=[arr_ctlList objectAtIndex:i];
            NSString *str_label=[dic objectForKey:@"label"];
            NSString *str_key=[dic objectForKey:@"key"];
            str_key=[self modifykey:str_key];
            NSObject *obj_value=[dic objectForKey:@"value"];
            NSString *str_value=@"";
            if (obj_value!=[NSNull null]) {
                str_value=(NSString*)obj_value;
            }
            NSString *str_groupKey=[dic objectForKey:@"groupKey"];
            if ([str_groupKey isEqualToString:@"audit"]) {
                NSString *str_type=[dic objectForKey:@"type"];
                if ([str_type isEqualToString:@"list"]) {
                    //必填必填项
                    NSString *str_required= [dic objectForKey:@"required"];
                    BOOL b_required=[str_required boolValue];
                    if (b_required==YES) {
                        if ([str_value isEqualToString:@""] || [str_value isEqualToString:@"0"])
                        {
                            NSString *str_msg=[NSString stringWithFormat:@"%@%@",@"请先完成审批:",str_label];
                            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str_msg cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                                
                            }];
                            [alert showLXAlertView];
                            return;
                        }
                    }
                    //必填处理决策信息
                    NSString *str_key=[dic objectForKey:@"key"];
                    NSRange range=[str_key rangeOfString:@"decision"];
                    if (range.length>0) {
                        if ([str_value isEqualToString:@""] || [str_value isEqualToString:@"0"])
                        {
                            NSString *str_msg=[NSString stringWithFormat:@"%@%@",@"请先完成审批:",str_label];
                            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str_msg cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                                
                            }];
                            [alert showLXAlertView];
                            return;
                        }
                    }
                    
                }
            }
            param[str_key]=str_value;
        }
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success=[JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"提交成功！" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                    
                }];
                [alert showLXAlertView];
                /*
                UINavigationController *nav1=[self.parentViewController.parentViewController.childViewControllers objectAtIndex:0];
                MessageViewController *message_vc=(MessageViewController*)[nav1.childViewControllers objectAtIndex:0];
                [message_vc FlowNum_Minus];
                
                UINavigationController *nav2=[self.parentViewController.parentViewController.childViewControllers objectAtIndex:2];
                FunctionViewController *func_vc=(FunctionViewController*)[nav2.childViewControllers objectAtIndex:0];
                [func_vc Badge_Minus];
                */
                 [_delegate RefreshUnFinishView];
                if (f_v<9.0) {
                    self.navigationController.delegate=nil;
                }
                [self.navigationController popViewControllerAnimated:YES];
               

            }
            else {
                NSString *str_msg=[JSON objectForKey:@"message"];
                if (str_msg==nil) {
                    str_msg=@"";
                }
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str_msg cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                    
                }];
                [alert showLXAlertView];
            }
        
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *str_error=[NSString stringWithFormat:@"%@",error];
            NSLog(@"%@%@",@"问题是",str_error);
        }];
       
    }
   
    
}



#pragma mark tableView方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([arr_groupList count]==0) {
        return 1;
    }
    else {
        return [arr_groupList count]+2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dic_ctl count]==0) {
        return 1;
    }
    else {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)section];
        if (section<[arr_groupList count]-1) {
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
        else if (section==[arr_groupList count]-1) {
            return [arr_ShenPiQueryList count];
        }
        else if (section==[arr_groupList count]) {
            str_index=[NSString stringWithFormat:@"%ld",section-1];
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
        else  {
            return 1;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tb cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=[NSString stringWithFormat:@"%@%ld%ld",@"cellID",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell=[tb cellForRowAtIndexPath:indexPath];
   // UITableViewCell *cell=[tb dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.textAlignment=NSTextAlignmentRight;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([dic_ctl count]==0) {
        cell.textLabel.text=@"";
        return cell;
    }
    else {
        NSString *str_index=@"";
        if (indexPath.section<[arr_groupList count]-1 || indexPath.section==[arr_groupList count]) {
            if (indexPath.section<[arr_groupList count]-1) {
                str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
            }
            else if (indexPath.section==[arr_groupList count]) {
                str_index=[NSString stringWithFormat:@"%ld",indexPath.section-1];
            }
            NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
            NSDictionary  *dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
            NSString *str_type=[dic_tmp objectForKey:@"type"];
            if ([str_type isEqualToString:@"text"] || [str_type isEqualToString:@"int"] || [str_type isEqualToString:@"date"] || [str_type isEqualToString:@"datetime"] || [str_type isEqualToString:@"FLOAT"]) {
                //    NSString *str_readonly= [dic_tmp objectForKey:@"readonly"];
                //   BOOL b_readonly=[str_readonly boolValue];
                //if (b_readonly==YES) {
                NSString *str_label=[dic_tmp objectForKey:@"label"];
                NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                NSString *str_value=@"";
                if (obj_value!=[NSNull null]) {
                    str_value=(NSString*)obj_value;
                }
                if ([str_value isEqualToString:@"null"]) {
                    str_value=@"";
                }
                cell.textLabel.text=str_label;
                cell.textLabel.numberOfLines=0;
                cell.detailTextLabel.text=str_value;
                cell.detailTextLabel.numberOfLines=0;
                CGFloat w_value=[UILabel_LabelHeightAndWidth getWidthWithTitle:str_value font:cell.detailTextLabel.font];
                if (w_value>[UIScreen mainScreen].bounds.size.width) {
                    int i=0;
                    i=i+1;
                }
                return cell;
                //   }
                //   else {
                
                //  }
            }
            else if ([str_type isEqualToString:@"textarea"]) {
                NSString *str_readonly= [dic_tmp objectForKey:@"readonly"];
                BOOL b_readonly=[str_readonly boolValue];
                NSString *str_groupKey=[dic_tmp objectForKey:@"groupKey"];
                if ([str_groupKey isEqualToString:@"audit"]) {
                    if (b_readonly==YES) {
                        NSString *str_label=[dic_tmp objectForKey:@"label"];
                        NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                        NSString *str_value=@"";
                        if (obj_value!=[NSNull null]) {
                            str_value=(NSString*)obj_value;
                        }
                        cell.textLabel.text=str_label;
                        cell.textLabel.numberOfLines=0;
                        cell.detailTextLabel.text=str_value;
                        cell.detailTextLabel.numberOfLines=0;
                        return cell;
                    }
                    else {
                        NSString *str_label=[dic_tmp objectForKey:@"label"];
                        NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                        NSString *str_value=@"";
                        if (obj_value!=[NSNull null]) {
                            str_value=(NSString*)obj_value;
                        }
                        NSString *str_placeholder=@"";
                        if ([str_value isEqualToString:@""]) {
                            str_placeholder= [NSString stringWithFormat:@"%@%@",@"请输入",str_label];
                        }
                        else {
                            str_placeholder=@"";
                        }
                        PrintApplicationDetailCell *cell=[PrintApplicationDetailCell cellWithTable:tableView withName:str_label withPlaceHolder:str_placeholder withText:str_value atIndexPath:indexPath atHeight:180];
                        cell.i_indexPath=indexPath;
                        cell.delegate=self;
                        cell.accessibilityHint=@"textArea";
                        return cell;
                    }
                    
                }
                else {
                    NSString *str_label=[dic_tmp objectForKey:@"label"];
                    NSObject *obj_value=[dic_tmp objectForKey:@"value"];
                    NSString *str_value=@"";
                    if (obj_value!=[NSNull null]) {
                        str_value=(NSString*)obj_value;
                    }
                    cell.textLabel.text=str_label;
                    cell.textLabel.numberOfLines=0;
                    cell.detailTextLabel.text=str_value;
                    cell.detailTextLabel.numberOfLines=0;
                    return cell;
                    
                    
                }
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
                NSString *str_detail_value=str_value;
                for (int l=0;l<[arr_listData count];l++) {
                    NSDictionary *dic= [arr_listData objectAtIndex:l];
                    NSString *str_tmp=[dic objectForKey:@"value"];
                    if ([str_tmp isEqualToString:str_value]) {
                         str_detail_value=[dic objectForKey:@"label"];
                        break;
                    }
                }
                BOOL b_multi=NO;
                NSString *str_groupKey=[dic_tmp objectForKey:@"groupKey"];
                if ([str_groupKey isEqualToString:@"audit"]) {
                    if (cell.accessibilityElements.count>0) {
                        cell.accessibilityHint=@"canPopList";
                        NSString *str_multiselect=[dic_tmp objectForKey:@"multiSelect"];
                        b_multi=[str_multiselect boolValue];
                    }
                    if ([dic_bkvalue count]!=0) {
                        NSDictionary *dic_bkvalue_tmp=[dic_bkvalue objectForKey:str_label];
                        if (dic_tmp!=nil) {
                            NSString *str_text=[dic_bkvalue_tmp objectForKey:@"text"];
                            NSString *str_value=[dic_bkvalue_tmp objectForKey:@"value"];
                            str_detail_value=str_text;
                            [dic_tmp setValue:str_value forKey:@"value"];
                            
                        }
                        else {
                            str_detail_value=@"请点击选择";
                        }
                        
                    }
                    else {
                        str_detail_value=@"请点击选择";
                    }
                    
                    ListCell *cell=[ListCell cellWithTable:tb withLabel:str_label withDetailLabel:str_detail_value index:indexPath listData:arr_listData mutiSelect:b_multi];
                    
                    return cell;
                    
                }
                else {
                    cell.textLabel.text=str_label;
                    cell.detailTextLabel.text=str_detail_value;
                    [dic_tmp setValue:str_detail_value forKey:@"value"];
                    
                    
                }
                
                
                /*
                 cell.textLabel.text=str_label;
                 cell.accessibilityElements=[dic_tmp objectForKey:@"listData"];
                 NSString *str_groupKey=[dic_tmp objectForKey:@"groupKey"];
                 if ([str_groupKey isEqualToString:@"audit"]) {
                 if (cell.accessibilityElements.count>0) {
                 cell.accessibilityHint=@"canPopList";
                 NSString *str_multiselect=[dic_tmp objectForKey:@"multiSelect"];
                 BOOL b_mutil=[str_multiselect boolValue];
                 if (b_mutil==YES) {
                 cell.accessibilityIdentifier=@"YES";
                 }
                 else {
                 cell.accessibilityIdentifier=@"NO";
                 }
                 
                 if ([dic_bkvalue count]!=0) {
                 NSDictionary *dic_bkvalue_tmp=[dic_bkvalue objectForKey:str_label];
                 
                 if (dic_tmp!=nil) {
                 NSString *str_text=[dic_bkvalue_tmp objectForKey:@"text"];
                 NSString *str_value=[dic_bkvalue_tmp objectForKey:@"value"];
                 cell.detailTextLabel.text=str_text;
                 [dic_tmp setValue:str_value forKey:@"value"];
                 }
                 else {
                 cell.detailTextLabel.text=@"请点击选择";
                 }
                 }
                 else {
                 cell.detailTextLabel.text=@"请点击选择";
                 }
                 cell.detailTextLabel.backgroundColor=[UIColor colorWithRed:69/255.0f green:115/255.0f blue:230/255.0f alpha:1];
                 cell.detailTextLabel.textColor=[UIColor whiteColor];
                 
                 }
                 else {
                 cell.detailTextLabel.text=str_detail_value;
                 [dic_tmp setValue:str_detail_value forKey:@"value"];
                 
                 }
                 
                 }
                 else {
                 
                 }
                 return cell;
                 */
            }
            else if ([str_type isEqualToString:@"html"]) {
                NSString *str_label=[dic_tmp objectForKey:@"label"];
                cell.textLabel.text=str_label;
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
        else if (indexPath.section==[arr_groupList count]-1) {
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
            cell.layer.borderWidth=1;
            cell.layer.borderColor=[[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1] CGColor];
            return cell;

        }
        else  {
            UIButton *btn;
            if (iPad) {
                btn=[[UIButton alloc]initWithFrame:CGRectMake(57, 7, [UIScreen mainScreen].bounds.size.width-114, 40)];
            }
            else {
                btn=[[UIButton alloc]initWithFrame:CGRectMake(25, 7, [UIScreen mainScreen].bounds.size.width-50, 40)];
            }
            btn.layer.cornerRadius=20;
            btn.backgroundColor=[UIColor colorWithRed:90/255.0f green:134/255.0f blue:243/255.0f alpha:1];
            [btn setTitle:@"提    交" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:21];
            [btn addTarget:self action:@selector(Submit:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            cell.layer.borderColor=[[UIColor clearColor] CGColor];
            cell.layer.borderWidth=0;
            
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
    if (arr_groupList!=nil) {
        if (section<[arr_groupList count]-1 || section==[arr_groupList count]) {
            NSInteger i_index=-1;
            if (section<[arr_groupList count]-1) {
                i_index=section;
            }
            else if (section==[arr_groupList count]) {
                i_index=[arr_groupList count]-1;
            }
            NSDictionary *dic_group=[arr_groupList objectAtIndex:i_index];
            NSString *str_label=[dic_group objectForKey:@"label"];
            if (str_label!=nil) {
                lbl_sectionTitle.text=[NSString stringWithFormat:@"%@",str_label];
            }
            else {
                lbl_sectionTitle.text=@"请稍后,正在加载中...";
            }
            
            
            [view addSubview:lbl_sectionTitle];
            return view;
            
        }
        else if (section==[arr_groupList count]-1) {
            lbl_sectionTitle.text=@"审批记录";
            [view addSubview:lbl_sectionTitle];
            return view;
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section<[arr_groupList count]+1) {
        return 30;
    }
    else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tb heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (self.selectedRowIndexPath==nil) {
        NSString *str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
        NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
        NSDictionary  *dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
        NSString *str_type=[dic_tmp objectForKey:@"type"];
        if ([str_type isEqualToString:@"textarea"]) {
            NSObject *obj_value=[dic_tmp objectForKey:@"value"];
            NSString *str_value=@"";
            if (obj_value!=[NSNull null]) {
                str_value=(NSString*)obj_value;
            }
            if (![str_value isEqualToString:@""]) {
                CGFloat h_value=[UILabel_LabelHeightAndWidth getHeightByWidth:15*[UIScreen mainScreen].bounds.size.width/16 title:str_value font:[UIFont systemFontOfSize:14]];
                return h_value;
            }
            else {
                return 60;
            }
        }
        else {
            return 44;
        }
    }
    else {
        return 44;
    }
     */
    if (indexPath.section<[arr_groupList count]-1 || indexPath.section==[arr_groupList count]) {
        NSString *str_index=@"";
        if (indexPath.section<[arr_groupList count]) {
            str_index=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
        }
        else if (indexPath.section==[arr_groupList count]) {
            str_index=[NSString stringWithFormat:@"%ld",indexPath.section-1];
        }
        NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
        if (indexPath.row<[arr_tmp count]) {
            NSDictionary  *dic_tmp=[arr_tmp objectAtIndex:indexPath.row];
            NSString *str_type=[dic_tmp objectForKey:@"type"];
            // NSString *str_readonly=[dic_tmp objectForKey:@"readonly"];
            NSString *str_groupKey=[dic_tmp objectForKey:@"groupKey"];
            //    BOOL b_readonly=[str_readonly boolValue];
            if ([str_type isEqualToString:@"textarea"]) {
                if (![str_groupKey isEqualToString:@"audit"]) {
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
                                return  rowHeightLabel+20;
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
                        return 180;
                    }
                    
                }
                else {
                    return  180;
                    
                }
            }
            else if (![str_type isEqualToString:@"html"]) {
                //下午完善
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
                    CGFloat rowHeightLabel=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width*0.2 title:str_label font:[UIFont systemFontOfSize:14]];
                    if (rowHeightLabel>rowHeightValue) {
                        if (rowHeightLabel<34) {
                            return 44;
                        }
                        else {
                            return rowHeightLabel+20;
                        }
                    }
                    else {
                        if (rowHeightValue<34) {
                            return 44;
                        }
                        else {
                            return rowHeightValue+20;
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
    else if (indexPath.section==[arr_groupList count]-1) {
        return 80;
    }
    else {
        return 54;
    }
    
    
}

-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}

-(void)tableView:(UITableView *)tb didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tb cellForRowAtIndexPath:indexPath];
    if ([cell isMemberOfClass:[PrintFileNavCell class]]) {
        PrintFileNavCell *cell_nav=(PrintFileNavCell*)cell;
        NSArray *tmp_Files=cell_nav.file_data;
        NSArray *tmp_Title=cell_nav.file_title;
        NSString *str_label=cell_nav.str_label;
        PrintFileDetail *viewController=[[PrintFileDetail alloc]init];
        viewController.arr_data=tmp_Files;
        viewController.arr_title=tmp_Title;
        viewController.str_title=str_label;
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([cell.accessibilityHint isEqualToString:@"canPopList"]) {
        NSArray *arr_value=cell.accessibilityElements;
        NSString *str_title=cell.textLabel.text;
        ListFileController *vc=[[ListFileController alloc]init];
        vc.arr_value=arr_value;
        vc.str_title=str_title;
        vc.indexPath=indexPath;
        if ([cell.accessibilityIdentifier isEqualToString:@"YES"]) {
            vc.mutliselect=YES;
        }
        else if ([cell.accessibilityIdentifier isEqualToString:@"NO"]) {
            vc.mutliselect=NO;
        }
        
        vc.delegate=self;
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([cell.accessibilityHint isEqualToString:@"html"]) {
        NewsDetailVc *vc=[[NewsDetailVc alloc]init];
        vc.str_value=cell.accessibilityValue;
        vc.str_title2=cell.textLabel.text;
        vc.str_ip=str_ip;
        vc.str_port=str_port;
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
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
            NSMutableDictionary *dic_sub_ctl=[arr_my_ctl objectAtIndex:j];
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



-(void)sendBackValue:(NSMutableDictionary *)dic_backvalue indexPath:(NSIndexPath *)i_indexPath title:(NSString *)str_title{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:i_indexPath];
    if (cell!=nil) {
        if ([dic_backvalue count]!=0) {
            NSString *str_title=[dic_backvalue objectForKey:@"title"];
            [dic_bkvalue setObject:dic_backvalue forKey:str_title];
          //  [dic_bkvalue addEntriesFromDictionary:dic_backvalue];
            /*
            NSString *str_text=[dic_backvalue objectForKey:@"label"];
            NSString *str_value=[dic_backvalue objectForKey:@"value"];
            NSInteger i_value=[str_value integerValue];
            cell.textLabel.text=str_title;
            cell.detailTextLabel.text=str_text;
            cell.tag=i_value;
             */
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:i_indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
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
        dic_param[@"activityDefID"]=_str_activityDefID;
        dic_param[@"workItemID"]=_str_workItemID;
        [self PrePareData:dic_param];
        //tableview中插入一条数据
        //[self NewsList:_news_param];
        
    });
}


-(void)sendCellValue:(NSString *)str_text indexPath:(NSIndexPath *)i_indexPath {
    NSString *str_index=[NSString stringWithFormat:@"%ld",(long)i_indexPath.section];
    NSInteger i_dic_count=[dic_m_ctl count];
    NSArray *arr_tmp=  [dic_m_ctl objectForKey:str_index];
    if (arr_tmp==nil) {
        str_index=[NSString stringWithFormat:@"%ld",(long)i_dic_count-1];
        arr_tmp=  [dic_m_ctl objectForKey:str_index];
    }
    NSDictionary  *dic_tmp=[arr_tmp objectAtIndex:i_indexPath.row];
    [dic_tmp setValue:str_text forKey:@"value"];
}


-(void)PrePareQueryLog:(NSMutableDictionary*)param ip:(NSString*)str_data_ip port:(NSString*)str_data_port {
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
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_data_ip,str_data_port,str_urldata];
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




-(void)handleNavigationTransition:(UIGestureRecognizer *)sender {
    
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
