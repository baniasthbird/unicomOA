//
//  SysMsgSubVc.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/29.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SysMsgSubVc.h"
#import "AFNetworking.h"
#import "DataBase.h"
#import "LXAlertView.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "BaseFunction.h"
#import "SysMsgResultVc.h"
#import "NewsManagementTableViewCell.h"

@interface SysMsgSubVc() <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,NewsTapDelegate>

@property (strong,nonatomic) UISearchController *searchcontroller;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSMutableArray *arr_SysMsgList;

@property (strong,nonatomic) NSMutableArray *searchArray;  //搜索数据

@property NSInteger i_pageIndex;

@property (nonatomic,strong) BaseFunction *baseFunc;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@property (nonatomic,strong) SysMsgResultVc *resultViewController;

@property NSInteger i_pageTotal;

@end

@implementation SysMsgSubVc {
    DataBase *db;
    
    UIActivityIndicatorView *indicator;
    
    BOOL b_ReplaceDataSource;
    
    NSInteger selectedIndex;
    
    NSString *selected_title;
    
    //搜索后得到的数组
    NSMutableArray *arr_searchList;
    
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 150) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.tableView numberOfRowsInSection:0]>0) {
        // [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.tableView setContentOffset:CGPointMake(0, 40)];
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.view.backgroundColor=[UIColor clearColor];
    
    db = [DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];

    _i_pageIndex=1;
    
    selectedIndex=-1;
    
    _arr_SysMsgList=[[NSMutableArray alloc]init];
    
    arr_searchList=[[NSMutableArray alloc]init];
    
    _baseFunc=[[BaseFunction alloc]init];
    
    self.resultViewController = [[SysMsgResultVc alloc] initWithStyle:UITableViewStylePlain];
    self.resultViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.searchcontroller=[[UISearchController alloc] initWithSearchResultsController:self.resultViewController];
    
    self.searchcontroller.searchResultsUpdater=self;
    
    self.searchcontroller.searchBar.delegate=self;
    
    self.searchcontroller.searchBar.placeholder=@"搜索消息";
    
    self.searchcontroller.dimsBackgroundDuringPresentation=YES;        //是否添加半透明覆盖层
    
    self.searchcontroller.hidesNavigationBarDuringPresentation =NO;     //是否隐藏导航栏
    
    [[[[self.searchcontroller.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    
    [self.searchcontroller.searchBar setFrame:CGRectMake(self.searchcontroller.searchBar.frame.origin.x, self.searchcontroller.searchBar.frame.origin.y, self.view.frame.size.width, 40)];
    
    self.searchcontroller.searchBar.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    
    self.tableView.tableHeaderView=self.searchcontroller.searchBar;
    
    //设置refreshControl的属性
    _refreshControl=[[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];
    
    [self SysMsgList:_sysmsg_param];
    
    [self.view addSubview:self.tableView];
    

    indicator =[_baseFunc AddLoop];
    
    [indicator startAnimating];
    [self.view addSubview:indicator];
}

-(void)handleRefresh:(id)paramSender {
    // 模拟2秒后刷新数据
    int64_t delayInSeconds = 2.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //停止刷新
        [self.refreshControl endRefreshing];
        //tableview中插入一条数据
      //  [self NewsList:_news_param];
    });
}

-(void)SysMsgList:(NSMutableDictionary*)param {
    NSString *str_connection=[_baseFunc GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        NSString *str_msgList=[db fetchInterface:@"UnreadMessage"];
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        __block NSString *str_index=[param objectForKey:@"pageIndex"];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_msgList];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSInteger i_index=[str_index integerValue];
             i_index=i_index+1;
            NSString *str_success=[JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                [indicator stopAnimating];
                [_refreshControl endRefreshing];
                NSLog(@"获取未读消息列表成功");
                NSObject *obj=[JSON objectForKey:@"totalPage"];
                NSNumber *l_totalPage=(NSNumber*)obj;
                _i_pageTotal=[l_totalPage integerValue];
                NSArray *arr_tmp=[JSON objectForKey:@"list"];
                if ([_arr_SysMsgList count]>0) {
                    for (int i=0;i<[arr_tmp count];i++) {
                        NSDictionary *dic_tmp=[arr_tmp objectAtIndex:i];
                        if (![_arr_SysMsgList containsObject:dic_tmp]) {
                            [_arr_SysMsgList addObject:dic_tmp];
                        }
                    }
                }
                else {
                    [_arr_SysMsgList addObjectsFromArray:arr_tmp];
                }
                
                [self.tableView reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新完成
                    [self.tableView setContentOffset:CGPointMake(0, 40)];
                });

                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
        }];
    }
    else {
        [indicator stopAnimating];
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_arr_SysMsgList count]>0 && _arr_SysMsgList!= nil) {
        return _arr_SysMsgList.count;
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_arr_SysMsgList count]==0) {
        return 120;
    }
    else {
        CGFloat h_heihgt=0;
        if (iPhone6_plus) {
            h_heihgt=[_baseFunc cellHeightForNews:indexPath.row titleFont:17 otherFont:14 array:_arr_SysMsgList keywordtitle:@"title" keywordName:@"sendEmpname" keywordTime:@"sendTime" ];
        }
        else if (iPad) {
            h_heihgt=[_baseFunc cellHeightForNews:indexPath.row titleFont:27 otherFont:20 array:_arr_SysMsgList keywordtitle:@"title" keywordName:@"sendEmpname" keywordTime:@"sendTime"];
        }
        else {
            h_heihgt=[_baseFunc cellHeightForNews:indexPath.row titleFont:17 otherFont:11 array:_arr_SysMsgList keywordtitle:@"title" keywordName:@"sendEmpname" keywordTime:@"sendTime"];
        }
        
        return h_heihgt;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_arr_SysMsgList count]!=0) {
        NSDictionary *dic_content=[_arr_SysMsgList objectAtIndex:indexPath.row];
        NewsManagementTableViewCell *cell=[self buildCell:dic_content indexPath:indexPath tableview:tableView];
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
    
}

-(NewsManagementTableViewCell*)buildCell:(NSDictionary*)dic_content indexPath:(NSIndexPath*)indexPath tableview:(UITableView*)tableView {
    NSString *str_category=[_baseFunc GetValueFromDic:dic_content key:@"msgType"];
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
    //  CGFloat h_category=[UILabel_LabelHeightAndWidth getHeightByWidth:15*self.view.frame.size.width/16 title:str_category font:[UIFont systemFontOfSize:i_otherFont]];
    NewsManagementTableViewCell *cell;
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
    
    NSString *str_sendempname =[_baseFunc GetValueFromDic:dic_content key:@"sendEmpname"];
    // CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:i_otherFont]];
    CGFloat h_depart=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width title:str_sendempname font:[UIFont systemFontOfSize:i_otherFont]];
    NSString *str_time =[_baseFunc GetValueFromDic:dic_content key:@"sendTime"];
    NSArray *arr_time=[str_time componentsSeparatedByString:@" "];
    NSString *str_time2=[arr_time objectAtIndex:0];
    NSString *str_depart=[NSString stringWithFormat:@"%@ %@",str_sendempname,str_time2];
    //CGFloat h_height=h_Title+h_depart+20;
  //  CGFloat h_height=[self cellHeightForNews:indexPath.row titleFont:i_titleFont otherFont:i_otherFont];
    CGFloat h_height=[_baseFunc cellHeightForNews:indexPath.row titleFont:17 otherFont:14 array:_arr_SysMsgList keywordtitle:@"title" keywordName:@"sendEmpname" keywordTime:@"sendTime"];
    cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:h_height withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withCategory:str_category withDepart:str_depart titleFont:i_titleFont otherFont:i_otherFont canScroll:NO withImage:nil];
    cell.delegate=self;
    cell.str_title=str_title;
    cell.str_department=str_sendempname;
    cell.myTag=indexPath.row;
    cell.str_operator=[dic_content objectForKey:@"sendEmpname"];
    //如果在一个页面，就不触发这个
    
    if ([str_title isEqualToString:selected_title]) {
        //  cell.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
        if (b_ReplaceDataSource==YES) {
            cell.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
        }
        
    }
    NSObject *obj=[dic_content objectForKey:@"id"];
    if (obj!=nil) {
        NSNumber *num_index=(NSNumber*)obj;
        NSInteger i_index=[num_index integerValue];
        cell.tag=i_index;
    }
    return cell;

}

@end
