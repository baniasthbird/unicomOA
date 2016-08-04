//
//  NewsManagementViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/3/9.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsManagementViewController.h"
#import "NIDropDown.h"
#import "NewsManagementTableViewCell.h"
#import "QuartzCore/QuartzCore.h"
#import "NewsDisplayViewController.h"
#import "UIView+Frame.h"
#import "WZLBadgeImport.h"
#import "UIImageButton.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "NewsSubVC.h"



@interface NewsManagementViewController ()

@property (strong,nonatomic) NSMutableArray *arr_News;

@property (strong,nonatomic) NSMutableArray *arr_Focus;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSMutableArray *arr_NewsList;

@property (nonatomic,strong) UILabel *lbl_label;

@property (nonatomic,strong) UITextField *txt_pages;

//公告数量总计
@property NSInteger i_newsList;

//新闻数量多的时候的索引
@property NSInteger i_pageIndex;

//新闻分类的索引
@property NSInteger i_classId;

@property NSInteger i_pageTotal;

@property (nonatomic,strong) NSMutableDictionary *news_param;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

//@property (strong, nonatomic) FDSlideBar *slideBar;

@end

@implementation NewsManagementViewController {
    DataBase *db;
    //搜索后得到的数组
    NSMutableArray *arr_searchList;
    
    NSMutableArray *arr_tmpList;
    
   // UIActivityIndicatorView *indicator;
    
    NSInteger selectedIndex;
    
    NSString *selected_title;
    
    BOOL b_ReplaceDataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=_str_title;
    
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }

    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIButton *btn_focus=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [btn_focus setTitle:@"关注列表" forState:UIControlStateNormal];
    [btn_focus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_focus addTarget:self action:@selector(FocusNews:) forControlEvents:UIControlEventTouchUpInside];
  //  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_focus];
    
    selectedIndex=-1;
    b_ReplaceDataSource=NO;
    
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setTitle:@"  " forState:UIControlStateNormal];
    [btn_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_back setTintColor:[UIColor whiteColor]];
    [btn_back setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(BackToAppCenter:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_back];
    
    //self.view.userInteractionEnabled = YES;
    
    //UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    //[self.view addGestureRecognizer:singleTap];
    
    _baseFunc=[[BaseFunction alloc]init];
    _i_pageIndex=1;
    _i_classId=0;
    
    _arr_NewsList=[[NSMutableArray alloc]init];
    
    arr_searchList=[[NSMutableArray alloc]init];
    
    arr_tmpList=[[NSMutableArray alloc]init];
    
   // indicator=[self AddLoop];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];
    
    [self buildView:_b_isNews];
    
    [self NewsListCount];
    
    _news_param=[NSMutableDictionary dictionary];
    _news_param[@"pageIndex"]=@"1";
    _news_param[@"classId"]=@"0";
    [self NewsList:_news_param];
    
 //   [indicator startAnimating];
 //   [self.view addSubview:indicator];

    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//获得新闻数量
-(void)NewsListCount {
    NSString *str_newsListCount= [db fetchInterface:@"NewsListCount"];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_newsListCount];
    [_session POST:str_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *str_success= [JSON objectForKey:@"success"];
        BOOL b_success=[str_success intValue];
        if (b_success==YES) {
             NSLog(@"获取新闻数量统计成功");
            NSString *str_num=[JSON objectForKey:@"num"];
            _i_newsList=[str_num integerValue];
            NSInteger i_page=_i_newsList/10+1;
            _lbl_label.text=[NSString stringWithFormat:@"/%ld",(long)i_page];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取新闻数量统计失败");
    }];

}

//获得最新新闻
//0525 筛选在下拉刷新后有问题，逻辑需重新梳理
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
            
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==1) {
           //     [indicator stopAnimating];
                NSLog(@"获取新闻列表成功:%@",responseObject);
                NSObject *obj=[JSON objectForKey:@"totalPage"];
                NSNumber *l_totalPage=(NSNumber*)obj;
                _i_pageTotal=[l_totalPage integerValue];
                NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc]init];
                NSString *str_totalPage=[numberFormatter stringFromNumber:l_totalPage];
                _lbl_label.text=[NSString stringWithFormat:@"/%@",str_totalPage];
                NSArray *arr_tmp=[JSON objectForKey:@"list"];
                for (int i=0;i<[arr_tmp count];i++) {
                    [_arr_NewsList addObject:[arr_tmp objectAtIndex:i]];
                }
                [self.tableView reloadData];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //   [indicator stopAnimating];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
        }];

    }
    else {
     //   [indicator stopAnimating];
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)buildDataSource {
    
}

-(void)buildView:(BOOL)b_isNews {
    
    if (iPad) {
          _tableView=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.005, 95, self.view.frame.size.width*0.99, 880) style:UITableViewStylePlain];
    }
    else {
         _tableView=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.005, 46, self.view.frame.size.width*0.99, self.view.frame.size.height*0.755) style:UITableViewStylePlain];
    }
   
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.backgroundColor=[UIColor clearColor];
    
    _tableView.dataSource=self;
    
    _tableView.delegate=self;
    
    //设置refreshControl的属性
    _refreshControl=[[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];

    
    if (iPhone4_4s || iPhone5_5s) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.027, self.view.frame.size.width*0.25, self.view.frame.size.height*0.05)];
        _btn_Select.layer.cornerRadius=self.view.frame.size.height*0.025;
    }
    else if (iPhone6) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.033, self.view.frame.size.height*0.0208, self.view.frame.size.width*0.21, self.view.frame.size.height*0.0475)];
        _btn_Select.layer.cornerRadius=self.view.frame.size.height*0.02375;
    }
    else if (iPhone6_plus) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.026, self.view.frame.size.width*0.2, self.view.frame.size.height*0.038)];
        _btn_Select.layer.cornerRadius=self.view.frame.size.height*0.019;
    }
    else if (iPad) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(24, 40, 153.6, 28)];
        _btn_Select.layer.cornerRadius=14;
    }
    
    [_btn_Select setTitle:@"类别" forState:UIControlStateNormal];
    if (iPad) {
        _btn_Select.titleLabel.font=[UIFont systemFontOfSize:22];
    }
    else {
        _btn_Select.titleLabel.font=[UIFont systemFontOfSize:12.5];
    }
    
    [_btn_Select setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_Select setBackgroundColor:[UIColor colorWithRed:80.0/255.0f green:124.0f/255.0f blue:236.0f/255.0f alpha:1]];
    UIImageView *img_view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_arrow"]];
  //  [img_view setFrame:CGRectMake(_btn_Select.frame.size.width*0.87, _btn_Select.frame.size.height*0.5-img_view.size.height/2, img_view.size.width, img_view.size.height)];
    [_btn_Select addSubview:img_view];
    if (iPhone5_5s || iPhone4_4s) {
        _btn_Select.titleLabel.font=[UIFont systemFontOfSize:15];
    }
    
    
    UIButton *btn_previous=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.15, self.view.frame.size.height-150,self.view.frame.size.width*0.2, 25)];
    [btn_previous setTitle:@"上一页" forState:UIControlStateNormal];
    [btn_previous setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //btn_previous.layer.borderWidth=1;
    [btn_previous addTarget:self action:@selector(Previous:) forControlEvents:UIControlEventTouchUpInside];
    //[btn_previous setBackgroundColor:[UIColor yellowColor]];
    
    UIButton *btn_next=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.65, self.view.frame.size.height-150, self.view.frame.size.width*0.2, 25)];
    [btn_next setTitle:@"下一页" forState:UIControlStateNormal];
     [btn_next setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // btn_previous.layer.borderWidth=1;
    [btn_next addTarget:self action:@selector(Next:) forControlEvents:UIControlEventTouchUpInside];
    //[btn_next setBackgroundColor:[UIColor lightGrayColor]];

    _lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5,self.view.frame.size.height-150 , self.view.frame.size.width*0.1, 25)];
    _lbl_label.font=[UIFont systemFontOfSize:10];
    
    
    _txt_pages=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.45,self.view.frame.size.height-150,self.view.frame.size.width*0.05, 25)];
    _txt_pages.placeholder=@"1";
    _txt_pages.delegate=self;
    _txt_pages.keyboardType=UIKeyboardTypePhonePad;
    _txt_pages.font=[UIFont systemFontOfSize:10];
    /*
    _btn_Select.layer.borderWidth=1;
    _btn_Select.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    */
 //   _btn_Select.layer.cornerRadius=18.0f;
    [_btn_Select addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPhone4_4s || iPhone5_5s) {
       _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width/16.0, self.view.frame.size.height*0.023, 2*self.view.frame.size.width/3, self.view.frame.size.height/16)];
    }
    else if (iPhone6) {
        _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width/16.0, self.view.frame.size.height*0.015, 2*self.view.frame.size.width/3, self.view.frame.size.height/16)];
    }
    else if (iPhone6_plus) {
         _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(5*self.view.frame.size.width/16.0, self.view.frame.size.height*0.013, 2*self.view.frame.size.width/3, self.view.frame.size.height/16)];
    }
    else if (iPad) {
          _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(200, 6, 512, 100)];
    }
    
    /*
    _txt_Search.layer.borderWidth=1;
    _txt_Search.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    */
    _searchBar.layer.cornerRadius=18.0f;
    _searchBar.placeholder=@"  请输入搜索关键字";
    _searchBar.delegate=self;
    for (UIView *view in _searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count>0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            UITextField *txt_Field=[view.subviews objectAtIndex:0];
            txt_Field.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
            txt_Field.layer.cornerRadius=15.0f;
            if (iPad) {
                txt_Field.font=[UIFont systemFontOfSize:22];
               
            }
            break;
        }
    }
   // _searchBar.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //[_searchBar setTextColor:[UIColor blackColor]];
    
    
 //   [self.view addSubview:_btn_Select];
  //  [self setupSlideBar];
   // [self.view addSubview:_tableView];
    
    [self setUpAllViewController:b_isNews];
    
 //   [self.view addSubview:_searchBar];
   // [self.view addSubview:btn_previous];
   // [self.view addSubview:btn_next];
   // [self.view addSubview:_lbl_label];
   // [self.view addSubview:_txt_pages];
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
   // self.definesPresentationContext = YES;
    
    _arr_News=[NSMutableArray arrayWithCapacity:2];
    
    
    _arr_Focus=[NSMutableArray arrayWithCapacity:0];
}

-(void)FocusNews:(UIButton*)Btn {
  //  NewsFocusViewController *focusViewController=[[NewsFocusViewController alloc]init];
   // [self.navigationController pushViewController:focusViewController animated:YES];
    
}

-(void)BackToAppCenter:(UIButton*)Btn {
   
    //[self.delegate ClearNewsRedDot];
    [self.navigationController popViewControllerAnimated:NO];
}


-(CGFloat)cellHeightForNews:(NSInteger)i_index titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont {
    NSDictionary *dic_content=[_arr_NewsList objectAtIndex:i_index];
    
    CGFloat h_Title;
    if (iPad) {
        h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:[dic_content objectForKey:@"title"] font:[UIFont systemFontOfSize:i_titleFont]];
    }
    else {
        h_Title=[UILabel_LabelHeightAndWidth getHeightByWidth:[UIScreen mainScreen].bounds.size.width-30 title:[dic_content objectForKey:@"title"] font:[UIFont systemFontOfSize:i_titleFont]];
    }
    
    NSString *str_department = [dic_content objectForKey:@"operatorName"];
    CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:i_otherFont]];
    CGFloat h_depart=[UILabel_LabelHeightAndWidth getHeightByWidth:w_depart title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
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

}


#pragma tableView必备方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_arr_NewsList count]>0 && _arr_NewsList!=nil) {
        return _arr_NewsList.count;
    }
    else {
        return 0;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
   
    if ([_arr_NewsList count]!=0) {
        NSDictionary *dic_content=[_arr_NewsList objectAtIndex:indexPath.row];
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
    else {
        static NSString *identifier=@"Cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.text=@"";
        }
        return cell;
        
    }
    
    /*
    if (_b_hasnews==NO) {
        if (indexPath.section==0 && indexPath.row==1) {
            cell.backgroundColor=[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
        }
    }
    */
    
    
    /*
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    return cell;
     */
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
      return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)selectClicked:(UIButton*)sender {
    NSArray *arr=[[NSArray alloc]init];
    arr=[NSArray arrayWithObjects:@"全部",@"公司通知",@"部门通知",@"内部新闻",@"外部新闻",@"规章制度",nil];
    NSArray *arrImage=[[NSArray alloc]init];
    arrImage=[NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"apple.png"],nil];
    if (dropDown==nil) {
        CGFloat f=240;
        dropDown =[[NIDropDown alloc] showDropDown:sender :&f :arr :arrImage :@"down"];
        dropDown.delegate=self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

-(void)rel {
    dropDown=nil;
}

-(void)niDropDownDelegateMethod:(NIDropDown *)sender index:(NSInteger)i_index{
    
    _news_param[@"pageIndex"]=@"1";
    _i_classId=i_index;
    _news_param[@"classId"]=[NSString stringWithFormat:@"%ld",(long)i_index];
    [_arr_NewsList removeAllObjects];
    _i_pageIndex=0;
    [self NewsList:_news_param];
    [self rel];
    NSLog(@"%@",_btn_Select.titleLabel.text);
}

-(void)sideslipCellRemoveCell:(NewsManagementTableViewCell *)cell atIndex:(NSInteger)index {
    
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
    news_controller.userInfo=_userInfo;
    cell.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    selectedIndex=index;
    selected_title=cell.str_title;
    [self.navigationController pushViewController:news_controller animated:NO];
    
}

-(void)passFocusValue:(NSString *)str_title {
    if (str_title!=nil) {
        [_arr_Focus addObject:str_title];
    }
    NSLog(@"传值成功");
}


-(void)Previous:(UIButton*)btn {
    if (_i_pageIndex>1) {
        _i_pageIndex=_i_pageIndex-1;
        _news_param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
        _news_param[@"classId"]=[NSString stringWithFormat:@"%ld",(long)_i_classId];
        [self NewsList:_news_param];
        self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
    }
}

-(void)Next:(UIButton*)btn {
    if (_i_pageIndex<_i_pageTotal) {
        _i_pageIndex=_i_pageIndex+1;
        _news_param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
        _news_param[@"classId"]=[NSString stringWithFormat:@"%ld",(long)_i_classId];
        [self NewsList:_news_param];
        self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
    }

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


-(IBAction)textFieldDidEndEditing:(UITextField *)textField {
    NSString *str_text=_txt_pages.text;
    NSInteger i_text=[str_text integerValue];
    if (i_text>_i_pageTotal) {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"输入页数超过范围" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            _txt_pages.text=@"1";
        }];
        [alert showLXAlertView];
    }
    else {
        _i_pageIndex=[str_text integerValue];
        _news_param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
        _news_param[@"classId"]=[NSString stringWithFormat:@"%ld",(long)_i_classId];
        [self NewsList:_news_param];
    }

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
            _news_param[@"classId"]=[NSString stringWithFormat:@"%ld",(long)_i_classId];
            [self NewsList:_news_param];
           // self.txt_pages.text=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
        }
    }
}





-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   // NSMutableArray *arr_tmpList=[[NSMutableArray alloc]init];
    [arr_tmpList removeAllObjects];
    [arr_searchList removeAllObjects];
    [searchBar resignFirstResponder];
    if (![searchBar.text isEqualToString:@""]) {
        NSString *str_content=searchBar.text;
        for (int i=0;i<[_arr_NewsList count];i++) {
            NSDictionary *dic_tmp=[_arr_NewsList objectAtIndex:i];
            NSString *str_title=[dic_tmp objectForKey:@"title"];
            NSRange foundObj=[str_title rangeOfString:str_content options:NSCaseInsensitiveSearch];
            if (foundObj.length>0) {
                [arr_searchList addObject:dic_tmp];
            }
        }
        if ([arr_searchList count]>0) {
            
            arr_tmpList=[_arr_NewsList mutableCopy];
            [_arr_NewsList removeAllObjects];
            _arr_NewsList=[arr_searchList mutableCopy];
        }
        else {
            arr_tmpList=[_arr_NewsList mutableCopy];
            [_arr_NewsList removeAllObjects];
            
        }
        [self.tableView reloadData];
    }
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        _arr_NewsList=[arr_tmpList mutableCopy];
        [self.tableView reloadData];
    }
}


-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
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
        [self.refreshControl endRefreshing];
        //tableview中插入一条数据
        [self NewsList:_news_param];
    });
    
    
}

/*
// Set up a slideBar and add it into view
- (void)setupSlideBar {
    FDSlideBar *sliderBar = [[FDSlideBar alloc] init];
    sliderBar.backgroundColor = [UIColor colorWithRed: 82/ 255.0 green:126/ 255.0 blue:237/ 255.0 alpha:1.0];
    
    // Init the titles of all the item
    sliderBar.itemsTitle = @[@"全部", @"公司通知", @"部门通知", @"内部新闻", @"外部新闻", @"规章制度"];
    
    // Set some style to the slideBar
    sliderBar.itemColor = [UIColor whiteColor];
    sliderBar.itemSelectedColor = [UIColor orangeColor];
    sliderBar.sliderColor = [UIColor orangeColor];
    
    // Add the callback with the action that any item be selected
    [sliderBar slideBarItemSelectedCallback:^(NSUInteger idx) {
        
    }];
    [self.view addSubview:sliderBar];
    _slideBar = sliderBar;
}
*/

- (void)setUpAllViewController:(BOOL)b_isNews {
    
    self.isfullScreen=YES;
    self.isShowUnderLine=YES;
    self.bgColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    self.norColor=[UIColor blackColor];
    self.selColor=[UIColor colorWithRed:73/255.0f green:118/255.0f blue:231/255.0f alpha:1];
    self.underLineColor=[UIColor colorWithRed:73/255.0f green:118/255.0f blue:231/255.0f alpha:1];
    
    if (iPhone5_5s) {
        self.titleFont=[UIFont systemFontOfSize:14];
    }
    else if (iPhone6) {
        self.titleFont=[UIFont systemFontOfSize:16];
    }
    else if (iPhone6_plus) {
        self.titleFont=[UIFont systemFontOfSize:18];
    }
    else if (iPad) {
        self.titleFont=[UIFont systemFontOfSize:18];
    }
    
    NSMutableDictionary *news_param1=[NSMutableDictionary dictionary];
    NSMutableDictionary *news_param2=[NSMutableDictionary dictionary];
    NSMutableDictionary *news_param3=[NSMutableDictionary dictionary];
    NSMutableDictionary *news_param4=[NSMutableDictionary dictionary];
    NSMutableDictionary *news_param5=[NSMutableDictionary dictionary];
    NSMutableDictionary *news_param6=[NSMutableDictionary dictionary];
    
    NewsSubVC *wordVc1 = [[NewsSubVC alloc] init];
    wordVc1.title = @"全部";
    news_param1[@"pageIndex"]=@"1";
    news_param1[@"classId"]=@"0";
    news_param1[@"type"]=@"2";
    wordVc1.b_News=YES;
    wordVc1.news_param=news_param1;
   
    
    
    NewsSubVC *wordVc2 = [[NewsSubVC alloc] init];
    wordVc2.title = @"公司通知";
    news_param2[@"pageIndex"]=@"1";
    news_param2[@"classId"]=@"1";
    news_param2[@"type"]=@"1";
    wordVc2.b_News=YES;
    wordVc2.news_param=news_param2;
    
    
    NewsSubVC *wordVc3 = [[NewsSubVC alloc] init];
    wordVc3.title = @"部门通知";
    news_param3[@"pageIndex"]=@"1";
    news_param3[@"classId"]=@"2";
    news_param3[@"type"]=@"1";
    wordVc3.b_News=YES;
    wordVc3.news_param=news_param3;
   
    
    NewsSubVC *wordVc4 = [[NewsSubVC alloc] init];
    wordVc4.title = @"内部新闻";
    news_param4[@"pageIndex"]=@"1";
    news_param4[@"classId"]=@"3";
    news_param4[@"type"]=@"2";
    wordVc4.b_News=YES;
    wordVc4.news_param=news_param4;
    
    
    NewsSubVC *wordVc5 = [[NewsSubVC alloc] init];
    wordVc5.title = @"外部新闻";
    news_param5[@"pageIndex"]=@"1";
    news_param5[@"classId"]=@"4";
    news_param5[@"type"]=@"2";
    wordVc5.b_News=YES;
    wordVc5.news_param=news_param5;
   
    
    NewsSubVC *wordVc6 = [[NewsSubVC alloc] init];
    wordVc6.title = @"规章制度";
    news_param6[@"pageIndex"]=@"1";
    wordVc6.b_News=NO;
    wordVc6.news_param=news_param6;
   
    if (b_isNews==YES) {
        [self addChildViewController:wordVc1];
        [self addChildViewController:wordVc4];
        [self addChildViewController:wordVc5];
    }
    else {
        [self addChildViewController:wordVc2];
        [self addChildViewController:wordVc3];
        [self addChildViewController:wordVc6];
    }
    
    
    
}


@end
