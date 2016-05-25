//
//  NewsManagementViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/3/9.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsManagementViewController.h"
#import "NewsFocusViewController.h"
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


@interface NewsManagementViewController ()<UITextFieldDelegate>

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

@end

@implementation NewsManagementViewController {
    DataBase *db;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"公告";
    
    UIButton *btn_focus=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [btn_focus setTitle:@"关注列表" forState:UIControlStateNormal];
    [btn_focus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_focus addTarget:self action:@selector(FocusNews:) forControlEvents:UIControlEventTouchUpInside];
  //  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_focus];
    
    
    
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setTitle:@"  " forState:UIControlStateNormal];
    [btn_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_back setTintColor:[UIColor whiteColor]];
    [btn_back setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(BackToAppCenter:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_back];
    
    _i_pageIndex=1;
    _i_classId=0;
    
    _arr_NewsList=[[NSMutableArray alloc]init];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    [self buildView];
    
    [self NewsListCount];
    
    _news_param=[NSMutableDictionary dictionary];
    _news_param[@"pageIndex"]=@"1";
    _news_param[@"classId"]=@"0";
    [self NewsList:_news_param];
    
    
    
    
    
    
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
        NSLog(@"获取新闻列表失败");
    }];
    
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

-(void)buildView {
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.005, self.view.frame.size.height*0.13, self.view.frame.size.width*0.99, self.view.frame.size.height*0.7) style:UITableViewStylePlain];
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.backgroundColor=[UIColor whiteColor];
    
    _tableView.dataSource=self;
    
    _tableView.delegate=self;
    
    if (iPhone4_4s || iPhone5_5s) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.023, self.view.frame.size.width/4, self.view.frame.size.height/16)];
    }
    else if (iPhone6) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.015, self.view.frame.size.width/4, self.view.frame.size.height/16)];
    }
    else if (iPhone6_plus) {
        _btn_Select=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/32, self.view.frame.size.height*0.013, self.view.frame.size.width/4, self.view.frame.size.height/16)];
    }
    
    [_btn_Select setTitle:@"类别" forState:UIControlStateNormal];
    [_btn_Select setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_Select setBackgroundColor:[UIColor colorWithRed:80.0/255.0f green:124.0f/255.0f blue:236.0f/255.0f alpha:1]];
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
    _btn_Select.layer.cornerRadius=18.0f;
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
    
    /*
    _txt_Search.layer.borderWidth=1;
    _txt_Search.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    */
    _searchBar.layer.cornerRadius=18.0f;
    _searchBar.placeholder=@"  请输入搜索关键字";
    for (UIView *view in _searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count>0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            UITextField *txt_Field=[view.subviews objectAtIndex:0];
            txt_Field.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
            txt_Field.layer.cornerRadius=15.0f;
            break;
        }
    }
   // _searchBar.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    //[_searchBar setTextColor:[UIColor blackColor]];
    
    
    [self.view addSubview:_btn_Select];
    [self.view addSubview:_tableView];
    [self.view addSubview:_searchBar];
   // [self.view addSubview:btn_previous];
   // [self.view addSubview:btn_next];
   // [self.view addSubview:_lbl_label];
   // [self.view addSubview:_txt_pages];
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    _arr_News=[NSMutableArray arrayWithCapacity:2];
    
    
    _arr_Focus=[NSMutableArray arrayWithCapacity:0];
}

-(void)FocusNews:(UIButton*)Btn {
    NewsFocusViewController *focusViewController=[[NewsFocusViewController alloc]init];
    [self.navigationController pushViewController:focusViewController animated:YES];
    
}

-(void)BackToAppCenter:(UIButton*)Btn {
   
    [self.delegate ClearNewsRedDot];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma tableView必备方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_arr_NewsList!=nil) {
        return _arr_NewsList.count;
    }
    else {
        return 2;
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsManagementTableViewCell *cell;
    if (iPhone6 || iPhone6_plus)
    {
         cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width/32 titleY:0.0f titleW:15*self.view.frame.size.width/16 titleH:50.0f DepartX:self.view.frame.size.width/32 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width/2 TimeY:60.0f TimeW:self.view.frame.size.width/3 TimeH:40.0f canScroll:YES];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:110 titleX:self.view.frame.size.width/32 titleY:0.0f titleW:15*self.view.frame.size.width/16 titleH:50.0f DepartX:self.view.frame.size.width/32 DepartY:60.0f DepartW:3*self.view.frame.size.width/8 DepartH:40.0f TimeX:self.view.frame.size.width*0.4 TimeY:60.0f TimeW:self.view.frame.size.width*0.5 TimeH:40.0f canScroll:YES];
    }
    
   
    cell.delegate=self;
    cell.myTag=indexPath.row;
    if (_arr_NewsList.count==0) {
        cell.lbl_Title.text=[NSString stringWithFormat:@"%@|%ld",@"国家发展改革委关于放开部分建设项目服务收费标准有关问题的通知",(long)indexPath.row];
        cell.lbl_department.text=@"综合管理部 张三";
        cell.lbl_time.text=@"2016-01-26 16:45";
    }
    else {
        NSDictionary *dic_content=[_arr_NewsList objectAtIndex:indexPath.row];
        cell.lbl_Title.text=[dic_content objectForKey:@"title"];
        cell.lbl_department.text=[dic_content objectForKey:@"operatorName"];
        cell.lbl_time.text=[dic_content objectForKey:@"startDate"];
        NSObject *obj=[dic_content objectForKey:@"id"];
        if (obj!=nil) {
            NSNumber *num_index=(NSNumber*)obj;
            NSInteger i_index=[num_index integerValue];
            cell.tag=i_index;
        }
    }
    
    /*
    if (_b_hasnews==NO) {
        if (indexPath.section==0 && indexPath.row==1) {
            cell.backgroundColor=[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
        }
    }
    */
    
    return cell;
    
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
    return 110;
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
    
    
    NewsDisplayViewController *news_controller=[[NewsDisplayViewController alloc]init];
    news_controller.news_index=cell.tag;
    news_controller.str_label=cell.lbl_Title.text;
    news_controller.str_depart=cell.lbl_department.text;
    news_controller.delegate=self;
    news_controller.userInfo=_userInfo;
    [self.navigationController pushViewController:news_controller animated:YES];
    
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
    [_txt_pages resignFirstResponder];
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


@end
