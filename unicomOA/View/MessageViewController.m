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
#import "MyShenPiViewController.h"
#import "FunctionViewController.h"


@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,NewsTapDelegate,YBMonitorNetWorkStateDelegate,RemindCellDelegate,MyShenPiViewControllerDelegate>

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
    CGFloat i_totalHeight;
    NSInteger selectedIndex;
    
    NSString *selected_title;
    
    BOOL b_ReplaceDataSource;
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

    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }

    
    self.navigationController.navigationBar.titleTextAttributes=dict;

    selectedIndex=-1;
    b_ReplaceDataSource=NO;
    
    _baseFunc=[[BaseFunction alloc]init];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
   

    
    i_totalHeight=0;
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
        __block NSString *str_ip=@"";
        __block NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        
        NSString *str_url1=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_taskCount];
        [_session POST:str_url1 parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
            NSLog(@"请求未读消息成功:%@",responseObject);
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL i_success=[str_success boolValue];
            if (i_success==YES) {
                 [self.refreshControl endRefreshing];
                NSString *str_docnum= [JSON objectForKey:@"docNum"];
                NSString *str_flownum= [JSON objectForKey:@"flowNum"];
                NSString *str_msgnum= [JSON objectForKey:@"msgNum"];
                _i_doc_num=[str_docnum intValue];
                _i_flow_num=[str_flownum intValue];
                _i_msg_num=[str_msgnum intValue];
                [indicator stopAnimating];
                NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                /*
                //0715 zr 接口不完善前临时添加
                NSString *str_UnFinish=[db fetchInterface:@"UnFinishTaskShenPiList"];
                __block NSString *str_url2=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_UnFinish];
                __block NSMutableDictionary *dic_param1=[NSMutableDictionary dictionary];
                dic_param1[@"pageIndex"]=@"1";
                [_session POST:str_url2 parameters:dic_param1 progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSString *str_success= [JSON objectForKey:@"success"];
                    BOOL b_success=[str_success boolValue];
                    if (b_success==YES) {
                        __block NSString *str_totalPage=[JSON objectForKey:@"totalPage"];
                        dic_param1[@"pageIndex"]=str_totalPage;
                        [_session POST:str_url2 parameters:dic_param1 progress:^(NSProgress * _Nonnull uploadProgress) {
                            
                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                            NSString *str_success= [JSON objectForKey:@"success"];
                            BOOL b_success=[str_success boolValue];
                            if (b_success==YES) {
                                NSArray *arr_TaskList=[JSON objectForKey:@"taskList"];
                                NSInteger i_page=[str_totalPage integerValue];
                                _i_flow_num=(i_page-1)*10+[arr_TaskList count];
                                 [indicator stopAnimating];
                                NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0];
                                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];

                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                        }];

                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                }];
                // _count=_i_doc_num+_i_flow_num+_i_msg_num;
                */
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
                  //  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                     [self.tableView reloadData];
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
    return 11;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 70;
    }
    else {
        if ([_arr_NewsList count]==0) {
            return 110;
        }
        else  {
            
            
            CGFloat h_height=0;
            if (iPhone6_plus) {
                h_height=[self cellHeightForNews:indexPath.section-1 titleFont:17 otherFont:14];
            }
            else if (iPad) {
                h_height=[self cellHeightForNews:indexPath.section-1 titleFont:24 otherFont:18];
            }
            else {
                 h_height=[self cellHeightForNews:indexPath.section-1 titleFont:17 otherFont:11];
            }
            
            return h_height;
            
        }
        
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 30;
    }
    else {
        if (!iPad) {
            return 6;
        }
        else {
            return 9;
        }
        
    }
}


-(CGFloat)cellHeightForNews:(NSInteger)i_index titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont {
  //  @try {
        if (i_index<[_arr_NewsList count]) {
            NSDictionary *dic_content=[_arr_NewsList objectAtIndex:i_index];
             CGFloat h_Title;
            NSString *str_title=[_baseFunc GetValueFromDic:dic_content key:@"title"];
            if (i_index<4) {
                if (iPad) {
                    h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                }
                else {
                    h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width-80 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                }
            }
            else {
                if (iPad) {
                    h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                }
                else {
                    h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width-30 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                }

            }
           
            
            
            NSString *str_department = [dic_content objectForKey:@"operatorName"];
          //  CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:i_otherFont]];
            CGFloat h_depart=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
            CGFloat h_height=h_Title+h_depart;
            if (iPad) {
                if (h_Title>60) {
                    return 88+h_depart;
                }
                else {
                    return h_height+30;
                }
            }
            else {
                if (h_Title>45) {
                    return 71+h_depart;
                }
                else {
                    return h_height+30;
                }
            }
           // return  h_height+30;
        }
        else {
            return 60;
            
        }

 //   } @catch (NSException *exception) {
   //     NSLog(@"Caught %@%@", [exception name], [exception reason]);
    
  //  } @finally {
  //      return 0;
 //   }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
  //  @try {
        if (indexPath.section==0) {
            RemindCell *r_cell=[RemindCell cellWithTable:tableView DocNum:_i_doc_num FlowNum:_i_flow_num MsgNum:_i_msg_num];
            r_cell.delegate=self;
            r_cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return r_cell;
        }
        else  {
            if ([_arr_NewsList count]==0) {
                static NSString *identifier=@"Cell";
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell==nil) {
                    cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    cell.textLabel.text=@"";
                }
                return cell;
            }
            else {
                
                if (indexPath.section-1<[_arr_NewsList count]) {
                    NewsManagementTableViewCell *cell;
                    NSDictionary *dic_content=[_arr_NewsList objectAtIndex:indexPath.section-1];
                   // NSString *str_category=[dic_content objectForKey:@"classname"];
                    NSString *str_category=[_baseFunc GetValueFromDic:dic_content key:@"classname"];
                    
                    CGFloat i_titleFont=0;
                    CGFloat i_otherFont=0;
                    if (iPhone6_plus) {
                        i_titleFont=16;
                        i_otherFont=11;
                    }
                    else if (iPad) {
                        i_titleFont=24;
                        i_otherFont=18;
                    }
                    else {
                        i_titleFont=16;
                        i_otherFont=11;
                    }
                    //  CGFloat h_category=[UILabel_LabelHeighndWidth getHeightByWidth:15*self.view.frame.size.width/16 title:str_category font:[UIFont systemFontOfSize:i_otherFont]];
                    NSString *str_title=[_baseFunc GetValueFromDic:dic_content key:@"title"];
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str_title];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    [paragraphStyle setLineSpacing:5];
                    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str_title length])];
                    
                    CGFloat h_Title;
                    if (iPad) {
                        h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                    }
                    else {
                        h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width-30 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                    }
                    NSString *str_department =[_baseFunc GetValueFromDic:dic_content key:@"operationDeptName"];
                   // CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:i_otherFont]];
                    CGFloat h_depart=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
                    NSString *str_time =[_baseFunc GetValueFromDic:dic_content key:@"startDate"];
                    NSArray *arr_time=[str_time componentsSeparatedByString:@" "];
                    NSString *str_time2=[arr_time objectAtIndex:0];
                    NSString *str_depart=[NSString stringWithFormat:@"%@ %@",str_department,str_time2];
                    //CGFloat h_height=h_Title+h_depart+30;
                    CGFloat h_height=[self cellHeightForNews:indexPath.section-1 titleFont:i_titleFont otherFont:i_otherFont];
                    if (indexPath.section<4) {
                        cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:h_height withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withCategory:str_category withDepart:str_depart titleFont:i_titleFont otherFont:i_otherFont canScroll:NO withImage:@"hot.png"];
                    }
                    else {
                         cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:h_height withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withCategory:str_category withDepart:str_depart titleFont:i_titleFont otherFont:i_otherFont canScroll:NO withImage:nil];
                    }
                    cell.delegate=self;
                    cell.str_title=str_title;
                    cell.str_department=str_department;
                    cell.myTag=indexPath.section-1;
                    
                    
                    if ([str_title isEqualToString:selected_title]) {
                        //if (b_ReplaceDataSource==YES) {
                        cell.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
                        // }
                        
                    }
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleGray;
                    
                    NSObject *obj=[dic_content objectForKey:@"id"];
                    if (obj!=nil) {
                        NSNumber *num_index=(NSNumber*)obj;
                        NSInteger i_index=[num_index integerValue];
                        cell.tag=i_index;
                    }
                    
                    return cell;
                    
                }
                else {
                    static NSString *identifier=@"Cell";
                    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
                    if (cell==nil) {
                        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        cell.textLabel.text=@"";
                    }
                    return cell;
                    
                }
                //  return cell;
                
            }
        }
  //  } @catch (NSException *exception) {
  //      NSLog(@"Caught %@%@", [exception name], [exception reason]);
  //  } @finally {
        
  //  }
    
    

}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section==0) {
        CGRect frameRect = CGRectMake(0, 0, self.view.frame.size.width, 40);
        
        UIView *view = [[UIView alloc] initWithFrame:frameRect];
        
        UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newsbodcast.png"]];
        
        [img setFrame:CGRectMake(20, 5, 20, 20)];
        
       // [view addSubview:img];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.view.frame.size.width-80, 30)];
        
        label.textAlignment=NSTextAlignmentLeft;
        
        
        
        CGFloat i_Float=0;
        if (iPhone4_4s || iPhone5_5s) {
            i_Float=16;
        }
        else {
            i_Float=16;
        }
        
        label.font=[UIFont systemFontOfSize:i_Float];
        
        // label.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
        
        
        label.text=@"新闻公告";
        label.textColor=[UIColor blackColor];
        
        
        [view addSubview:label];
        view.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
        
        return view;
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
    if (selectedIndex!=-1 && selectedIndex!=index) {
      //  NSIndexPath *selectIndexPath=[NSIndexPath indexPathForRow:selectedIndex inSection:1];
        b_ReplaceDataSource=NO;
      //  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selectIndexPath,nil]  withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
    }
    cell.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    selectedIndex=index;
    NewsDisplayViewController *news_controller=[[NewsDisplayViewController alloc]init];
    news_controller.news_index=cell.tag;
    news_controller.str_label=cell.str_title;
    news_controller.str_depart=cell.str_department;
    news_controller.userInfo=_userInfo;
    news_controller.b_News=YES;
    selected_title=cell.str_title;
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    b_ReplaceDataSource=YES;
}

-(NSString*)GetValueFromDic:(NSDictionary*)dic_tmp key:(NSString*)str_key {
    NSObject *obj_tmp=[dic_tmp objectForKey:str_key];
    NSString *str_tmp=@"";
    if (obj_tmp!=[NSNull null]) {
        str_tmp=(NSString*)obj_tmp;
    }
    return str_tmp;
}

-(void)PassNavToShenPi {
    NSLog(@"单击事件");
    MyShenPiViewController *viewController=[[MyShenPiViewController alloc] init];
    viewController.userInfo=_userInfo;
    viewController.delegate=self;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)RefreshBadgeNumber {
    [self RefreshFlowNum];
    
    UINavigationController *nav1=[self.parentViewController.parentViewController.childViewControllers objectAtIndex:2];
    FunctionViewController *func_vc=(FunctionViewController*)[nav1.childViewControllers objectAtIndex:0];
    [func_vc RefreshNum];
}

-(void)RefreshFlowNum {
    NSMutableDictionary *dic_param1=[NSMutableDictionary dictionary];
    dic_param1[@"pageIndex"]=@"1";
    [self RefreshBadge:dic_param1];
}

-(void)RefreshBadge:(NSMutableDictionary*)param {
    [self NewsCount];
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
