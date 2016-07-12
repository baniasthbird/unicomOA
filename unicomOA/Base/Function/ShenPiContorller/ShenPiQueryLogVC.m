//
//  ShenPiQueryLogVC.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/29.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ShenPiQueryLogVC.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "ShenPiResultCell.h"

@interface ShenPiQueryLogVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *arr_ShenPiQueryList;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@end

@implementation ShenPiQueryLogVC {
    DataBase *db;
    
    UIActivityIndicatorView *indicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"审批记录";
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
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
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(FinishMission:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barButtonItem2;

    db=[DataBase sharedinstanceDB];
    
    indicator=[self AddLoop];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];

    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    dic_param[@"processInstID"]=_str_processInstID;
    [self PrePareData:dic_param];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height-80) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _refreshControl=[[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [_tableView addSubview:_refreshControl];

    

    [self.view addSubview:_tableView];
    
    [indicator startAnimating];
    [self.view addSubview:indicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)FinishMission:(UIButton*)sender {
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3]  animated:YES];
}

-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}

-(void)PrePareData:(NSMutableDictionary*)param {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        
        
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
                _arr_ShenPiQueryList=[JSON objectForKey:@"list"];
                [self.tableView reloadData];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            [_refreshControl endRefreshing];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"无法连接到服务器" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_arr_ShenPiQueryList!=nil) {
        return [_arr_ShenPiQueryList count];
    }
    else {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.detailTextLabel.textColor=[UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic_tmp=[_arr_ShenPiQueryList objectAtIndex:indexPath.section];
    
   

    
    if (dic_tmp!=nil) {
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
        //ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withImage:@"headLogo.png" withName:str_name withStatus:str_status withTime:str_date ActivityName:str_activename atIndex:indexPath];
        ShenPiResultCell *cell=[ShenPiResultCell cellWithTable:tableView withContent:str_content withName:str_name withStatus:str_status withTime:str_date ActivityName:str_activename atIndex:indexPath];
        return cell;
    }
    else {
        return cell;
    }
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *lbl_title=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.05, 5, [UIScreen mainScreen].bounds.size.width*0.9, 30)];
    lbl_title.textColor=[UIColor blackColor];
    lbl_title.font=[UIFont systemFontOfSize:16];
    lbl_title.numberOfLines=0;
    lbl_title.text=_str_titleName;
    [lbl_title sizeToFit];
    CGFloat h_height=lbl_title.frame.size.height+40;
    return h_height;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
