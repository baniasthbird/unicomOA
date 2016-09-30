//
//  NewsSubVC.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/4.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsSubVC.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "NewsManagementTableViewCell.h"
#import "BaseFunction.h"
#import "NewsDisplayViewController.h"
#import "NewsTableViewResultController.h"

@interface NewsSubVC () <UITableViewDelegate, UITableViewDataSource,NewsTapDelegate,FocusNewsPassDelegate,UISearchBarDelegate,UISearchResultsUpdating>

@property (strong,nonatomic) UISearchController *searchcontroller;

@property (strong,nonatomic) NewsTableViewResultController *resultViewController;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSMutableArray *arr_NewsList;

@property (strong,nonatomic) NSMutableArray *searchArray;  //搜索数据

//新闻数量多的时候的索引
@property NSInteger i_pageIndex;

//新闻分类的索引
@property NSInteger i_classId;

@property NSInteger i_pageTotal;

//用来区分是新闻还是公告
@property NSInteger i_type;

@property (nonatomic,strong) BaseFunction *baseFunc;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@end

@implementation NewsSubVC {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   // self.view.backgroundColor = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
    self.view.backgroundColor=[UIColor clearColor];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];
    
   

    _i_pageIndex=1;
    
    selectedIndex=-1;
    b_ReplaceDataSource=NO;
    
    _arr_NewsList=[[NSMutableArray alloc]init];
    
     arr_searchList=[[NSMutableArray alloc]init];
    
    NSString *str_classId= [_news_param objectForKey:@"classId"];
    NSString *str_type=[_news_param objectForKey:@"type"];
    
    if (str_classId!=nil) {
        _i_classId=[str_classId integerValue];
    }
    else {
        _i_classId=-1;
    }
    
    if (str_type!=nil) {
        _i_type=[str_type integerValue];
    }
    else {
        _i_type=-1;
    }
    
    
     _baseFunc=[[BaseFunction alloc]init];
    
    self.resultViewController=[[NewsTableViewResultController alloc]initWithStyle:UITableViewStylePlain];
    self.resultViewController.view.frame= CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
       // self.resultViewController.tableView.delegate=self;
    
    // [self.navigationController addChildViewController:self.resultViewController];
    
    self.searchcontroller=[[UISearchController alloc] initWithSearchResultsController:self.resultViewController];
    
    
    self.searchcontroller.searchResultsUpdater=self;
    
    self.searchcontroller.searchBar.delegate=self;
    
    //[self.searchcontroller.searchBar sizeToFit];
    
    self.searchcontroller.searchBar.placeholder=@"搜索新闻标题";
    
    self.searchcontroller.dimsBackgroundDuringPresentation = YES;            //是否添加半透明覆盖层
    
    self.searchcontroller.hidesNavigationBarDuringPresentation = NO;     //是否隐藏导航栏
    
    
    
    [[[[self.searchcontroller.searchBar.subviews objectAtIndex:0] subviews]objectAtIndex:0]removeFromSuperview];
    
    [self.searchcontroller.searchBar setFrame:CGRectMake(self.searchcontroller.searchBar.frame.origin.x, self.searchcontroller.searchBar.frame.origin.y, self.view.frame.size.width,40)];
    
    self.searchcontroller.searchBar.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    
    
    self.tableView.tableHeaderView=self.searchcontroller.searchBar;
    
    //设置refreshControl的属性
    _refreshControl=[[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];

    
    
    [self NewsList:_news_param];
    
    [self.view addSubview:self.tableView];
    
    indicator=[self AddLoop];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
  //  self.definesPresentationContext = YES;
}


-(CGFloat)cellHeightForNews:(NSInteger)i_index titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont {
    NSDictionary *dic_content=[_arr_NewsList objectAtIndex:i_index];
    
    CGFloat h_Title;
    if (iPad) {
        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:[dic_content objectForKey:@"title"] font:[UIFont systemFontOfSize:i_titleFont]];
    }
    else {
        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-30 title:[dic_content objectForKey:@"title"] font:[UIFont systemFontOfSize:i_titleFont]];
    }
    
    NSString *str_department = [dic_content objectForKey:@"operatorName"];
    CGFloat h_depart=0;
    CGFloat h_height=0;
    if (str_department!=nil) {
        CGFloat w_depart=[UILabel getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:i_otherFont]];
        h_depart=[UILabel getHeightByWidth:w_depart title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
        h_height=h_Title+h_depart;
    }
    else {
        CGFloat w_depart=[UILabel getWidthWithTitle:[dic_content objectForKey:@"operationTime"] font:[UIFont systemFontOfSize:i_otherFont]];
        str_department=[dic_content objectForKey:@"operationTime"];
        h_depart=[UILabel getHeightByWidth:w_depart title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
        h_height=h_Title+h_depart;
    }
    
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
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_arr_NewsList count]>0 && _arr_NewsList!=nil) {
        return _arr_NewsList.count;
    }
    else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_arr_NewsList count]==0) {
        return 110;
    }
    else {
        CGFloat h_height=0;
        if (iPhone6_plus) {
            h_height=[self cellHeightForNews:indexPath.row titleFont:17 otherFont:14];
        }
        else if (iPad) {
            h_height=[self cellHeightForNews:indexPath.row titleFont:27.4 otherFont:20];
        }
        else {
            h_height=[self cellHeightForNews:indexPath.row titleFont:17 otherFont:11];
        }
        
        return h_height;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 组%zd 行%zd", self.title ,indexPath.section, indexPath.row];
    return cell;
     */
    
    /*
     if (iPhone6 || iPhone6_plus)
     {
     cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width/32 titleY:0.0f titleW:15*self.view.frame.size.width/16 titleH:50.0f DepartX:self.view.frame.size.width/32 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width/2 TimeY:60.0f TimeW:self.view.frame.size.width/3 TimeH:40.0f canScroll:NO];
     }
     else if (iPhone5_5s || iPhone4_4s) {
     cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width/32 titleY:0.0f titleW:15*self.view.frame.size.width/16 titleH:50.0f DepartX:self.view.frame.size.width/32 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width*0.4 TimeY:60.0f TimeW:self.view.frame.size.width*0.5 TimeH:40.0f canScroll:NO];
     }
     */
    
    if ([_arr_NewsList count]!=0) {
        NSDictionary *dic_content=[_arr_NewsList objectAtIndex:indexPath.row];
        if (_b_News==YES) {
            NewsManagementTableViewCell *cell=[self buildNewsCell:dic_content indexPath:indexPath tableview:tableView];
            return cell;
        }
        else {
            NewsManagementTableViewCell *cell=[self buildRulesCell:dic_content indexPath:indexPath tableview:tableView];
            return cell;
        }
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


-(NewsManagementTableViewCell*)buildNewsCell:(NSDictionary*)dic_content indexPath:(NSIndexPath*)indexPath tableview:(UITableView*)tableView{
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
    //  CGFloat h_category=[UILabel_LabelHeightAndWidth getHeightByWidth:15*self.view.frame.size.width/16 title:str_category font:[UIFont systemFontOfSize:i_otherFont]];
    NewsManagementTableViewCell *cell;
    NSString *str_title=[_baseFunc GetValueFromDic:dic_content key:@"title"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str_title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str_title length])];
    
    CGFloat h_Title;
    if (iPad) {
        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
    }
    else {
        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-30 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
    }
    
    NSString *str_department =[_baseFunc GetValueFromDic:dic_content key:@"operationDeptName"];
    // CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:i_otherFont]];
    CGFloat h_depart=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
    NSString *str_time =[_baseFunc GetValueFromDic:dic_content key:@"startDate"];
    NSArray *arr_time=[str_time componentsSeparatedByString:@" "];
    NSString *str_time2=[arr_time objectAtIndex:0];
    NSString *str_depart=[NSString stringWithFormat:@"%@ %@",str_department,str_time2];
    //CGFloat h_height=h_Title+h_depart+20;
    CGFloat h_height=[self cellHeightForNews:indexPath.row titleFont:i_titleFont otherFont:i_otherFont];
    cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:h_height withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withCategory:str_category withDepart:str_depart titleFont:i_titleFont otherFont:i_otherFont canScroll:NO withImage:nil];
    cell.delegate=self;
    cell.str_title=str_title;
    cell.str_department=str_department;
    cell.myTag=indexPath.row;
    cell.str_operator=[dic_content objectForKey:@"operatorName"];
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

-(NewsManagementTableViewCell*)buildRulesCell:(NSDictionary*)dic_content indexPath:(NSIndexPath*)indexPath tableview:(UITableView*)tableView
{
    NSString *str_category=@"规章制度";
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
        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
    }
    else {
        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-30 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
    }
    
    NSString *str_department =[_baseFunc GetValueFromDic:dic_content key:@"operationTime"];
    // CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:i_otherFont]];
    CGFloat h_depart=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
    NSString *str_time =[_baseFunc GetValueFromDic:dic_content key:@"operationTime"];
    NSArray *arr_time=[str_time componentsSeparatedByString:@" "];
    NSString *str_time2=[arr_time objectAtIndex:0];
    //CGFloat h_height=h_Title+h_depart+20;
    CGFloat h_height=[self cellHeightForNews:indexPath.row titleFont:i_titleFont otherFont:i_otherFont];
    cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:h_height withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withCategory:str_category withDepart:str_time2 titleFont:i_titleFont otherFont:i_otherFont canScroll:NO withImage:nil];
    cell.delegate=self;
    cell.str_title=str_title;
    cell.str_department=str_department;
    cell.myTag=indexPath.row;
    cell.str_operator=[dic_content objectForKey:@"operatorName"];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic=arr_searchList[indexPath.row];
    NewsDisplayViewController *vc=[[NewsDisplayViewController alloc]init];
    NSString *str_id=[dic objectForKey:@"id"];
    vc.news_index=[str_id integerValue];
    vc.str_label=[dic objectForKey:@"title"];
    
    [self.navigationController pushViewController:vc animated:YES];
 
}
*/

//获得最新新闻
//0525 筛选在下拉刷新后有问题，逻辑需重新梳理
-(void)NewsList:(NSMutableDictionary*)param {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        NSString *str_newsList= [db fetchInterface:@"NewsList"];
        if (_b_News==NO) {
            str_newsList=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.RulesSearch.list.biz.ext";
        }
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        __block NSString *str_index=[param objectForKey:@"pageIndex"];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_newsList];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSInteger i_index=[str_index integerValue];
            i_index=i_index+1;
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                [indicator stopAnimating];
                [_refreshControl endRefreshing];
                NSLog(@"获取新闻列表成功:%@",responseObject);
                NSObject *obj=[JSON objectForKey:@"totalPage"];
                NSNumber *l_totalPage=(NSNumber*)obj;
                _i_pageTotal=[l_totalPage integerValue];
               // NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc]init];
                //NSString *str_totalPage=[numberFormatter stringFromNumber:l_totalPage];
              //  _lbl_label.text=[NSString stringWithFormat:@"/%@",str_totalPage];
                NSArray *arr_tmp=[JSON objectForKey:@"list"];
                if ([_arr_NewsList count]>0) {
                    for (int i=0;i<[arr_tmp count];i++) {
                        NSDictionary *dic_tmp=[arr_tmp objectAtIndex:i];
                        if (![_arr_NewsList containsObject:dic_tmp]) {
                            [_arr_NewsList addObject:dic_tmp];
                        }
                    }
                }
                else {
                     [_arr_NewsList addObjectsFromArray:arr_tmp];
                }
               

                [self.tableView reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新完成
                    //  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
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




#pragma mark 可重构代码

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


-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    b_ReplaceDataSource=YES;
    CGFloat height=scrollView.frame.size.height;
    CGFloat contentYoffset=scrollView.contentOffset.y;
    CGFloat distanceFromBottom=scrollView.contentSize.height-contentYoffset;
    //NSLog(@"height:%f contentYoffset:%f frame.y:%f",height,contentYoffset,scrollView.frame.origin.y);
    if (distanceFromBottom<height) {
        //  NSLog((@"end of table"));
        if (_i_pageIndex<_i_pageTotal) {
            _i_pageIndex=_i_pageIndex+1;
            _news_param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
            if (_i_classId!=-1 && _i_type!=-1) {
                _news_param[@"classId"]=[NSString stringWithFormat:@"%ld",(long)_i_classId];
                _news_param[@"type"]=[NSString stringWithFormat:@"%ld",(long)_i_type];
            }
            
            [self NewsList:_news_param];
            // self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
        }
    }
}

-(void)tapCell:(NewsManagementTableViewCell *)cell atIndex:(NSInteger)index {
#pragma mark 红点通知消除
    //if (_b_hasnews==NO) {
    /*
     if (cell.backgroundColor!=[UIColor clearColor])
     {
     NSString *str_badgevalue= [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue;
     int i_badgevalue=[str_badgevalue intValue];
     i_badgevalue=i_badgevalue-1;
     [self.tabBarController.tabBar.items objectAtIndex:2].badgeValue=[NSString stringWithFormat:@"%d",i_badgevalue];
     cell.backgroundColor=[UIColor clearColor];
     
     }
     */
    // }
    
    if (selectedIndex!=-1 && index!=selectedIndex) {
        NSIndexPath *selectIndexPath=[NSIndexPath indexPathForRow:selectedIndex inSection:0];
        b_ReplaceDataSource=NO;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selectIndexPath,nil]  withRowAnimation:UITableViewRowAnimationNone];
    }
    NewsDisplayViewController *news_controller=[[NewsDisplayViewController alloc]init];
    news_controller.news_index=cell.tag;
    news_controller.str_label=cell.str_title;
    news_controller.str_depart=cell.str_department;
    news_controller.str_time=cell.str_time;
    news_controller.str_operator=cell.str_operator;
    news_controller.delegate=self;
    news_controller.b_News=_b_News;
    //news_controller.userInfo=_userInfo;
    cell.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    selectedIndex=index;
    selected_title=cell.str_title;
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:news_controller animated:NO];
    
}

-(void)sideslipCellRemoveCell:(NewsManagementTableViewCell *)cell atIndex:(NSInteger)index {
    
}

-(void)passFocusValue:(NSString *)str_title {
    
}


#pragma mark -search bar delegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [indicator stopAnimating];
    [searchBar resignFirstResponder];
    
}

#pragma mark- UISearchResultUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
   
    [arr_searchList removeAllObjects];
    /*
    if (self.searchArray!=nil) {
        [self.searchArray removeAllObjects];
    }
     */
    //筛选条件
    NSString *searchtext=searchController.searchBar.text;
    if (![searchtext isEqualToString:@""]) {
        [indicator startAnimating];
        for (int i=0;i<[_arr_NewsList count];i++) {
            NSDictionary *dic_tmp=[_arr_NewsList objectAtIndex:i];
            NSString *str_title=[dic_tmp objectForKey:@"title"];
            NSRange foundObj=[str_title rangeOfString:searchtext options:NSCaseInsensitiveSearch];
            if (foundObj.length>0) {
                [arr_searchList addObject:dic_tmp];
            }
        }
        
        _resultViewController.dataArray=arr_searchList;
        _resultViewController.nav=self.navigationController;
        _resultViewController.b_news=_b_News;
        
        [_resultViewController.tableView reloadData];
        [indicator stopAnimating];

    }
    
    
}


-(void)handleRefresh:(id)paramSender {
    // 模拟2秒后刷新数据
    int64_t delayInSeconds = 2.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //停止刷新
        [self.refreshControl endRefreshing];
        //tableview中插入一条数据
        [self NewsList:_news_param];
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
