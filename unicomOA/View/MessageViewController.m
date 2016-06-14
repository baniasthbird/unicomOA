//
//  MessageViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MessageViewController.h"
#import "RemindViewController.h"
#import "RemindCell.h"
#import "NewsManagementTableViewCell.h"
#import "NewsDisplayViewController.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "YBMonitorNetWorkState.h"
#import "LXAlertView.h"


@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,NewsTapDelegate,YBMonitorNetWorkStateDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property  NSInteger count;

@property NSInteger i_doc_num;

@property NSInteger i_flow_num;

@property NSInteger i_msg_num;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSArray *arr_NewsList;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@end

@implementation MessageViewController {
    DataBase *db;
    UIActivityIndicatorView *indicator;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息";
        NSDictionary * dict=@{
                              NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
        self.navigationController.navigationBar.titleTextAttributes=dict;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title = @"消息";

    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;

    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    
    _refreshControl=[[UIRefreshControl alloc] init];
    
    //设置refreshControl的属性
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];
    
    
    [self.view addSubview:_tableView];
    
   
    
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];
    
    indicator=[self AddLoop];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    NSMutableDictionary *news_param=[NSMutableDictionary dictionary];
    news_param[@"pageIndex"]=@"1";
    news_param[@"classId"]=@"0";
    [self NewsList:news_param];
    [self NewsCount];
   
    //}
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}

//获得最新消息
-(void)NewsCount {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        NSString *str_taskCount= [db fetchInterface:@"TaskCount"];
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        
        NSString *str_url1=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_taskCount];
        [_session POST:str_url1 parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [indicator stopAnimating];
            NSLog(@"请求未读消息成功:%@",responseObject);
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            int i_success=[str_success intValue];
            if (i_success==1) {
                 [self.refreshControl endRefreshing];
                NSString *str_docnum= [JSON objectForKey:@"docNum"];
                NSString *str_flownum= [JSON objectForKey:@"flowNum"];
                NSString *str_msgnum= [JSON objectForKey:@"msgNum"];
                _i_doc_num=[str_docnum intValue];
                _i_flow_num=[str_flownum intValue];
                _i_msg_num=[str_msgnum intValue];
                // _count=_i_doc_num+_i_flow_num+_i_msg_num;
                NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self.refreshControl endRefreshing];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"网络连接连接失败" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
            NSLog(@"请求失败");
        }];
    }
    else {
        
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            NSLog(@"网络连接断了");
        }];
        [alert showLXAlertView];
    }
    
}


//获得最新新闻
-(void)NewsList:(NSMutableDictionary*)param {
    
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        NSString *str_newsList= [db fetchInterface:@"NewsList"];
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        
        
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_newsList];
        
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"获取新闻列表成功:%@",responseObject);
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            int i_success=[str_success intValue];
            if (i_success==1) {
                _arr_NewsList=[JSON objectForKey:@"list"];
                if ([_arr_NewsList count]>0) {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    // [self.tableView reloadData];
                }
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    }
    else {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else {
        if (iPhone6 || iPhone6_plus) {
            return 5;
        }
        else {
            return 3;
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 50;
    }
    else {
        if ([_arr_NewsList count]==0) {
            return 110;
        }
        else {
            CGFloat h_height=[self cellHeightForNews:indexPath.row];
            return h_height;
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==1) {
        return 30;
    }
    else {
        return 0;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 30;
    }
    else {
        return 0;
    }
}


-(CGFloat)cellHeightForNews:(NSInteger)i_index {
    NSDictionary *dic_content=[_arr_NewsList objectAtIndex:i_index];
    NSString *str_category=[dic_content objectForKey:@"classname"];
    CGFloat h_category=[UILabel_LabelHeightAndWidth getHeightByWidth:15*self.view.frame.size.width/16 title:str_category font:[UIFont systemFontOfSize:14]];
   
    CGFloat h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:15*self.view.frame.size.width/16 title:[dic_content objectForKey:@"title"] font:[UIFont systemFontOfSize:24]];
    
    NSString *str_department = [dic_content objectForKey:@"operatorName"];
    CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:14]];
    CGFloat h_depart=[UILabel_LabelHeightAndWidth getHeightByWidth:w_depart title:str_department font:[UIFont systemFontOfSize:14]];
    CGFloat h_height=h_category+h_Title+h_depart;
    return  h_height+15;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
        if (indexPath.section==0) {
            RemindCell *r_cell=[RemindCell cellWithTable:tableView DocNum:_i_doc_num FlowNum:_i_flow_num MsgNum:_i_msg_num];
            return r_cell;
        }
        else  {
            if ([_arr_NewsList count]==0) {
                static NSString *identifier=@"Cell";
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell==nil) {
                    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    cell.textLabel.text=@"aaa";
                }
                return cell;
            }
            else {
                NewsManagementTableViewCell *cell;
                
                /*
                if (iPhone6 || iPhone6_plus)
                {
                    cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width/32 titleY:0.0f titleW:15*self.view.frame.size.width/16 titleH:50.0f DepartX:self.view.frame.size.width/32 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width/2 TimeY:60.0f TimeW:self.view.frame.size.width/3 TimeH:40.0f canScroll:NO];
                }
                else if (iPhone5_5s || iPhone4_4s) {
                    cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width/32 titleY:0.0f titleW:15*self.view.frame.size.width/16 titleH:50.0f DepartX:self.view.frame.size.width/32 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width*0.4 TimeY:60.0f TimeW:self.view.frame.size.width*0.5 TimeH:40.0f canScroll:NO];
                }
                */
                NSDictionary *dic_content=[_arr_NewsList objectAtIndex:indexPath.row];
                cell.delegate=self;
                cell.myTag=indexPath.row;
                NSString *str_category=[dic_content objectForKey:@"classname"];
                CGFloat h_category=[UILabel_LabelHeightAndWidth getHeightByWidth:15*self.view.frame.size.width/16 title:str_category font:[UIFont systemFontOfSize:14]];
                NSString *str_title=[dic_content objectForKey:@"title"];
                CGFloat h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:15*self.view.frame.size.width/16 title:[dic_content objectForKey:@"title"] font:[UIFont systemFontOfSize:24]];
                
                NSString *str_department = [dic_content objectForKey:@"operatorName"];
                CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:14]];
                CGFloat h_depart=[UILabel_LabelHeightAndWidth getHeightByWidth:w_depart title:str_department font:[UIFont systemFontOfSize:14]];
                NSString *str_time =[dic_content objectForKey:@"startDate"];
                CGFloat h_height=h_category+h_Title+h_depart+15;
                cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:h_height withCategoryHeight:h_category withTitleHeight:h_Title withButtonHeight:h_depart withTitle:str_title withCategory:str_category withDepart:str_department withTime:str_time canScroll:NO];
                cell.delegate=self;
                cell.str_title=str_title;
                cell.str_department=str_department;

                NSObject *obj=[dic_content objectForKey:@"id"];
                if (obj!=nil) {
                    NSNumber *num_index=(NSNumber*)obj;
                    NSInteger i_index=[num_index integerValue];
                    cell.tag=i_index;
                }
               // NewsListCell *cell=[NewsListCell cellWithTable:tableView dic:dic_content cellHeight:_i_Height];
               // return cell;
                return cell;
                
            }
        }
    
    

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frameRect = CGRectMake(0, 0, self.view.frame.size.width, 40);
    
    UIView *view = [[UIView alloc] initWithFrame:frameRect];
    
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newsbodcast.png"]];
    
    [img setFrame:CGRectMake(20, 7, 20, 20)];
    
    [view addSubview:img];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(80, 0, self.view.frame.size.width-80, 37)];
    
    label.textAlignment=NSTextAlignmentLeft;
    
   
    
    CGFloat i_Float=0;
    if (iPhone4_4s || iPhone5_5s) {
        i_Float=16;
    }
    else {
        i_Float=20;
    }
    
    label.font=[UIFont systemFontOfSize:i_Float];
    
   // label.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    
    if (section==1) {
        label.text=@"新闻公告";
        label.textColor=[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1];
    }
    
    [view addSubview:label];
   
    return view;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view_end=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view_end.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    if (section==0) {
        return view_end;
    }
    else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            /*
            RemindViewController *viewController=[[RemindViewController alloc]init];
            viewController.userInfo=_userInfo;
            //传入各个新闻的数量 zr 0504
            viewController.i_index1=_i_flow_num;
            viewController.i_index2=_i_doc_num;
            viewController.i_index3=_i_msg_num;
            [self.navigationController pushViewController:viewController animated:YES];
             */
        }
    }
    else if (indexPath.section==1) {
        //目前详细信息接口未接入，稍后再试
        
    }
}





//点击新闻事件
-(void)tapCell:(NewsManagementTableViewCell *)cell atIndex:(NSInteger)index {
    NewsDisplayViewController *news_controller=[[NewsDisplayViewController alloc]init];
    news_controller.news_index=cell.tag;
    news_controller.str_label=cell.str_title;
    news_controller.str_depart=cell.str_department;
    news_controller.userInfo=_userInfo;
    [self.navigationController pushViewController:news_controller animated:YES];
}

-(void)sideslipCellRemoveCell:(NewsManagementTableViewCell *)cell atIndex:(NSInteger)index {
    
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
        //停止刷新
       
        //tableview中插入一条数据
        NSMutableDictionary *news_param=[NSMutableDictionary dictionary];
        news_param[@"pageIndex"]=@"1";
        news_param[@"classId"]=@"0";
        [self NewsList:news_param];
        [self NewsCount];

        
    });
    
    
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
