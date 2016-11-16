//
//  SysMsgViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/29.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SysMsgViewController.h"
#import "AFNetworking.h"
#import "DataBase.h"
#import "LXAlertView.h"
#import "SysMsgSubVc.h"
#import "SysMsgResultVc.h"
#import "SysMsgTableViewCell.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "SysMsgDisplayController.h"
#import "XSpotLight.h"

@interface SysMsgViewController()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,XSpotLightDelegate,SysMsgDisplayDelegate>

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property NSInteger i_pageIndex;

@property (strong,nonatomic) NSMutableArray *arr_SysMsgList;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@property (nonatomic,strong) SysMsgResultVc *resultViewController;

@property (strong,nonatomic) UISearchController *searchcontroller;

@property NSInteger i_pageTotal;

@end

@implementation SysMsgViewController {
    DataBase *db;
    //搜索后得到的数组
    NSMutableArray *arr_searchList;
    
    NSMutableArray *arr_tmpList;
    
    NSInteger selectedIndex;
    
    NSString *selected_title;
    
     UIActivityIndicatorView *indicator;
    
    CGFloat h_height;
    
    NSString *str_username;
}


-(void)viewDidLoad {
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

    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setTitle:@"  " forState:UIControlStateNormal];
    [btn_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_back setTintColor:[UIColor whiteColor]];
    [btn_back setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(BackToAppCenter:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_back];
    
    _baseFunc=[[BaseFunction alloc]init];
    
    _i_pageIndex=1;
    
    str_username=[[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    _arr_SysMsgList=[[NSMutableArray alloc]init];
    
    arr_searchList=[[NSMutableArray alloc]init];
    
    arr_tmpList=[[NSMutableArray alloc]init];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];
    
    [self buildView];
    
    XSpotLight *SpotLight=[[XSpotLight alloc]init];
    SpotLight.messageArray=@[@"修改系统消息列表及内容页面"];
    // SpotLight.rectArray=@[[NSValue valueWithCGRect:CGRectMake(i_x, i_y, 50, 500)]];
    SpotLight.rectArray=@[[NSValue valueWithCGRect:CGRectMake(0, 0,Width , Height)]];
    SpotLight.delegate=self;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
            [self presentViewController:SpotLight animated:NO completion:^{
        
            }];
    }

    

    
}

-(void)BackToAppCenter:(UIButton*)Btn {
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)buildView {
    
    //设置refreshControl的属性
    _refreshControl=[[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 80) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    self.resultViewController = [[SysMsgResultVc alloc] initWithStyle:UITableViewStylePlain];
    self.resultViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.searchcontroller=[[UISearchController alloc] initWithSearchResultsController:self.resultViewController];
    
    self.searchcontroller.searchResultsUpdater=self;
    
    self.searchcontroller.searchBar.delegate=self;
    
    self.searchcontroller.searchBar.placeholder=@"搜索消息发送人";
    
    self.searchcontroller.dimsBackgroundDuringPresentation=YES;        //是否添加半透明覆盖层
    
    self.searchcontroller.hidesNavigationBarDuringPresentation =NO;     //是否隐藏导航栏
    
    [[[[self.searchcontroller.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    
    [self.searchcontroller.searchBar setFrame:CGRectMake(self.searchcontroller.searchBar.frame.origin.x, self.searchcontroller.searchBar.frame.origin.y, self.view.frame.size.width, 40)];
    
    self.searchcontroller.searchBar.backgroundColor=[UIColor colorWithRed:231/255.0f green:231/255.0f blue:231/255.0f alpha:1];
    
    self.tableView.tableHeaderView=self.searchcontroller.searchBar;

    [self.tableView addSubview:_refreshControl];
    
    self.view.backgroundColor=[UIColor colorWithRed:246/255.0f green:249/255.0f blue:254/255.0f alpha:1];
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"pageIndex"]=@"1";
    [self SysMsgList:param];
    
    [self.view addSubview:self.tableView];
    
    
    indicator =[_baseFunc AddLoop];
    
    [indicator startAnimating];
    [self.view addSubview:indicator];
 //   [self setUpAllViewController];

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
                NSMutableArray *arr_read=[db fetchAllSysMsg:str_username];
                if (arr_tmp!=nil && arr_read!=nil) {
                    for (int i=0;i<[arr_tmp count];i++) {
                        BOOL b_read=NO;
                        NSDictionary *dic_tmp=[arr_tmp objectAtIndex:i];
                        NSString *str_msgType1= [dic_tmp objectForKey:@"msgType"];
                        NSString *str_sendEmpname1 = [dic_tmp objectForKey:@"sendEmpname"];
                        NSString *str_title1 = [dic_tmp objectForKey:@"title"];
                        NSString *str_sendTime1 = [dic_tmp objectForKey:@"sendTime"];
                        NSNumber *num_id1=[dic_tmp objectForKey:@"id"];
                        NSString *str_id1=num_id1.description;
                        for (int j=0; j<[arr_read  count]; j++) {
                            NSDictionary *dic_read=[arr_read objectAtIndex:j];
                            NSString *str_msgType2= [dic_read objectForKey:@"msgType"];
                            NSString *str_sendEmpname2 = [dic_read objectForKey:@"sendEmpname"];
                            NSString *str_title2 = [dic_read objectForKey:@"title"];
                            NSString *str_sendTime2 = [dic_read objectForKey:@"sendTime"];
                            NSNumber *num_id2=[dic_read objectForKey:@"id"];
                            NSString *str_id2=num_id2.description;
                            //如果找到就为已读
                            if ([str_msgType1 isEqualToString:str_msgType2] && [str_sendEmpname1 isEqualToString:str_sendEmpname2] && [str_title1 isEqualToString:str_title2] && [str_sendTime1 isEqualToString:str_sendTime2] && [str_id1 isEqualToString:str_id2]) {
                                b_read=YES;
                                break;
                            }
                        }
                        NSMutableDictionary *dic_SysMsg=[[NSMutableDictionary alloc]initWithDictionary:dic_tmp];
                        if (b_read==NO) {
                            [dic_SysMsg setObject:@"0" forKey:@"isRead"];
                        }
                        else if (b_read==YES) {
                            [dic_SysMsg setObject:@"1" forKey:@"isRead"];
                        }
                        if ([_arr_SysMsgList count]>0) {
                            if (![_arr_SysMsgList containsObject:dic_SysMsg]) {
                                [_arr_SysMsgList addObject:dic_SysMsg];
                            }
                        }
                        else {
                            [_arr_SysMsgList addObject:dic_SysMsg];
                        }
                    }
                }
                /*
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
                */
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
        return 85;
        /*
        if (iPhone6_plus) {
            h_height=[_baseFunc cellHeightForNews:indexPath.row titleFont:17 otherFont:14 array:_arr_SysMsgList keywordtitle:@"title" keywordName:@"sendEmpname" keywordTime:@"sendTime"];
        }
        else if (iPad) {
            h_height=[_baseFunc cellHeightForNews:indexPath.row titleFont:27 otherFont:20 array:_arr_SysMsgList keywordtitle:@"title" keywordName:@"sendEmpname" keywordTime:@"sendTime"] ;
        }
        else {
            h_height=[_baseFunc cellHeightForNews:indexPath.row titleFont:17 otherFont:11 array:_arr_SysMsgList keywordtitle:@"title" keywordName:@"sendEmpname" keywordTime:@"sendTime"];
        }
        
        return h_height;
         */
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_arr_SysMsgList count]!=0) {
        NSDictionary *dic_content=[_arr_SysMsgList objectAtIndex:indexPath.row];
        SysMsgTableViewCell *cell=[self buildCell:dic_content indexPath:indexPath tableview:tableView];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
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


-(SysMsgTableViewCell*)buildCell:(NSDictionary*)dic_content indexPath:(NSIndexPath*)indexPath tableview:(UITableView*)tableView {
    NSString *str_category=[_baseFunc GetValueFromDic:dic_content key:@"msgType"];
    NSString *str_title=[_baseFunc GetValueFromDic:dic_content key:@"title"];
    NSString *str_sendempname =[_baseFunc GetValueFromDic:dic_content key:@"sendEmpname"];
    NSString *str_time =[_baseFunc GetValueFromDic:dic_content key:@"sendTime"];
    NSString *str_isRead = [_baseFunc GetValueFromDic:dic_content key:@"isRead"];
    NSArray *arr_time=[str_time componentsSeparatedByString:@" "];
    NSString *str_time2=[arr_time objectAtIndex:0];
    CGFloat i_titleFont=0;
    CGFloat i_otherFont=0;
    if (iPhone6_plus) {
        i_titleFont=17;
        i_otherFont=14;
    }
    else if (iPad) {
        i_titleFont=24;
        i_otherFont=18;
    }
    else if(iPhone6) {
        i_titleFont=17;
        i_otherFont=12;
    }
    else if (iPhone5_5s) {
        i_titleFont=15;
        i_otherFont=12;
    }
    
    BOOL b_Read=NO;
    if ([str_isRead isEqualToString:@"0"] || str_isRead==nil) {
        b_Read=NO;
    }
    else {
        b_Read=YES;
    }

    SysMsgTableViewCell *cell;
   
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str_title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str_title length])];
    
    NSString *str_depart=[NSString stringWithFormat:@"%@ %@",str_sendempname,str_time2];
   // cell=[SysMsgTableViewCell cellWithTable:tableView withCellHeight:h_height withTitle:attributedString withCategory:str_category withSendName:str_depart titleFont:i_titleFont otherFont:i_otherFont];
    cell=[SysMsgTableViewCell cellWithTable:tableView withTitle:attributedString withCategory:str_category withSendName:str_sendempname withTime:str_time2 isRead:b_Read titleFont:i_titleFont otherFont:i_otherFont];
    NSString *str_id=[_baseFunc GetValueFromDic:dic_content key:@"id"];
    cell.tag=[str_id integerValue];
    //如果在一个页面，就不触发这个
    cell.lbl_Title.textColor=[UIColor blackColor];
    if ([str_title isEqualToString:selected_title]) {
      //  cell.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    }
    NSObject *obj=[dic_content objectForKey:@"id"];
    if (obj!=nil) {
        NSNumber *num_index=(NSNumber*)obj;
        NSInteger i_index=[num_index integerValue];
        cell.tag=i_index;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
    if ([_arr_SysMsgList count]!=0) {
        NSDictionary *dic_content=[_arr_SysMsgList objectAtIndex:indexPath.row];
        NSMutableDictionary *dic_read=[[NSMutableDictionary alloc]initWithDictionary:dic_content];
        [dic_read setObject:str_username forKey:@"receiveName"];
        [db addSingleSysMsg:dic_read];
    }
    SysMsgTableViewCell *cell=(SysMsgTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.lbl_Title.textColor=[UIColor colorWithRed:131/255.0f green:131/255.0f blue:131/255.0f alpha:1];
    NSInteger cellTag= cell.tag;
    if (cellTag!=0) {
        /*
        NSMutableDictionary *param=[NSMutableDictionary dictionary];
        param[@"id"]=[NSString stringWithFormat:@"%ld",(long)cellTag];
        [self SysMessageContent:param];
        */
        SysMsgDisplayController *vc=[[SysMsgDisplayController alloc]init];
        vc.delegate=self;
        vc.i_id=cellTag;
        vc.str_title=@"系统消息内容";
        vc.str_time=cell.lbl_time.text;
        vc.str_category=cell.lbl_Category.text;
        vc.str_SysMsg_Title=cell.lbl_Title.text;
        vc.str_sendName=cell.lbl_sendName.text;
        vc.usrInfo=_userInfo;
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [self.navigationController pushViewController:vc animated:NO];
        
    }
}

#pragma mark -search bar delegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [indicator stopAnimating];
    [searchBar resignFirstResponder];
    
}

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
        for (int i=0;i<[_arr_SysMsgList count];i++) {
            NSDictionary *dic_tmp=[_arr_SysMsgList objectAtIndex:i];
            NSString *str_sendEmpname=[dic_tmp objectForKey:@"sendEmpname"];
            NSRange foundObj=[str_sendEmpname rangeOfString:searchtext options:NSCaseInsensitiveSearch];
            if (foundObj.length>0) {
                [arr_searchList addObject:dic_tmp];
            }
        }
        
        _resultViewController.dataArray=arr_searchList;
        _resultViewController.nav=self.navigationController;
        
        [_resultViewController.tableView reloadData];
        [indicator stopAnimating];
        
    }
    
    
}

/*
-(void)setUpAllViewController {
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

    NSMutableDictionary *sysmsg_param1=[NSMutableDictionary dictionary];
    SysMsgSubVc *SysMsgVc1=[[SysMsgSubVc alloc]init];
    SysMsgVc1.title=@"全部";
    sysmsg_param1[@"pageIndex"]=@"1";
    SysMsgVc1.sysmsg_param=sysmsg_param1;
    
    [self addChildViewController:SysMsgVc1];
}
*/


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height=scrollView.frame.size.height;
    CGFloat contentYoffset=scrollView.contentOffset.y;
    CGFloat distanceFromBottom=scrollView.contentSize.height-contentYoffset;
    //NSLog(@"height:%f contentYoffset:%f frame.y:%f",height,contentYoffset,scrollView.frame.origin.y);
    if (distanceFromBottom<height) {
        if (_i_pageIndex<_i_pageTotal) {
            _i_pageIndex=_i_pageIndex+1;
            NSMutableDictionary *param=[NSMutableDictionary dictionary];
            param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
            [self SysMsgList:param];
        }
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
       // [self SysMsgList:_news_param];
    });
}

-(void)dealloc {
    self.tableView.delegate=nil;
    self.tableView.dataSource=nil;
}

-(void)XSpotLightClicked:(NSInteger)index {
    
}

-(void)RefreshTable {
    NSMutableArray *arr_read=[db fetchAllSysMsg:str_username];
    for (int i=0; i<[_arr_SysMsgList count]; i++) {
        BOOL b_read=NO;
        NSMutableDictionary *dic_tmp=[_arr_SysMsgList objectAtIndex:i];
        NSString *str_msgType1= [dic_tmp objectForKey:@"msgType"];
        NSString *str_sendEmpname1 = [dic_tmp objectForKey:@"sendEmpname"];
        NSString *str_title1 = [dic_tmp objectForKey:@"title"];
        NSString *str_sendTime1 = [dic_tmp objectForKey:@"sendTime"];
        NSNumber *num_id1=[dic_tmp objectForKey:@"id"];
        NSString *str_id1=num_id1.description;
        for (int j=0; j<[arr_read  count]; j++) {
            NSDictionary *dic_read=[arr_read objectAtIndex:j];
            NSString *str_msgType2= [dic_read objectForKey:@"msgType"];
            NSString *str_sendEmpname2 = [dic_read objectForKey:@"sendEmpname"];
            NSString *str_title2 = [dic_read objectForKey:@"title"];
            NSString *str_sendTime2 = [dic_read objectForKey:@"sendTime"];
            NSString *str_id2=[dic_read objectForKey:@"id"];
            
            //如果找到就为已读
            if ([str_msgType1 isEqualToString:str_msgType2] && [str_sendEmpname1 isEqualToString:str_sendEmpname2] && [str_title1 isEqualToString:str_title2] && [str_sendTime1 isEqualToString:str_sendTime2] && [str_id1 isEqualToString:str_id2]) {
                b_read=YES;
                break;
            }
        }
       // NSMutableDictionary *dic_SysMsg=[[NSMutableDictionary alloc]initWithDictionary:dic_tmp];
        if (b_read==NO) {
            [dic_tmp setObject:@"0" forKey:@"isRead"];
        }
        else if (b_read==YES) {
            [dic_tmp setObject:@"1" forKey:@"isRead"];
        }

    }
    [self.tableView reloadData];
}

@end
