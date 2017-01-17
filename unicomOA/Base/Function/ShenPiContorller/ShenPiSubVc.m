//
//  ShenPiSubVc.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/5.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ShenPiSubVc.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "MyShenPiCell.h"
#import "UnFinishVc.h"
#import "FinishVc.h"
#import "LeftMenuViewNew.h"
//#import "MenuView2.h"


@interface ShenPiSubVc ()<UITableViewDelegate,UITableViewDataSource,UnFinishVcDelegate,LeftMenuViewNewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property NSInteger i_page_Total;

@property NSInteger i_pageIndex;

@property (nonatomic,strong) NSMutableArray *arr_MyShenPi;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) LeftMenuViewNew *menuView;

//@property (nonatomic,strong) MenuView2 *menu2;

@end

@implementation ShenPiSubVc {
    DataBase *db;
    //获取我的审批列表，包括已办与待办
    NSMutableArray *arr_MyReview;
    //待办请求参数字典
    NSMutableDictionary *dic_param;
    
    //展现待办流程数据的url
    NSMutableDictionary *dic_url;
    
    UIActivityIndicatorView *indicator;
    
    NSMutableArray *arr_menuItem;
    
    NSString *str_cell_hint;
    
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 160) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    dic_param=[NSMutableDictionary dictionary];
    dic_url=[NSMutableDictionary dictionary];
    
    arr_MyReview=[[NSMutableArray alloc]init];
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];

    
    dic_param[@"pageIndex"]=@"1";
    dic_param[@"sys"]=[NSString stringWithFormat:@"%ld",(long)_i_Class];
   
    //设置refreshControl的属性
    _refreshControl=[[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];
    self.tableView.backgroundColor=[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
    
    if (_b_isDaiBan==YES) {
        [self PrePareData:dic_param interface:@"UnFinishTaskShenPiList"];
    }
    else {
        [self PrePareData:dic_param interface:@"FinishTaskShenPiList"];
    }

    str_cell_hint=@"all";
    [self.view addSubview:_tableView];
    
    indicator=[self AddLoop];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_arr_MyShenPi count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        if (iPhone4_4s || iPhone5_5s)
            return 10;
        else if (iPhone6)
            return 10;
        else
            return 20;
    }
    else {
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (iPhone4_4s || iPhone5_5s)
        return 10;
    else if (iPhone6)
        return 10;
    else
        return 20;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPad) {
        return [self cellHeightForShenPi:indexPath.section  otherFont:20 ];
        
    }
    else {
        return [self cellHeightForShenPi:indexPath.section  otherFont:14 ];
    }
    
}


-(CGFloat)cellHeightForShenPi:(NSInteger)i_index otherFont:(CGFloat)i_otherFont {
    NSMutableDictionary *dic_tmp=[NSMutableDictionary dictionary];
    // if ([_str_searchKeyword2 isEqualToString:@"全部"] && [_str_searchKeyword1 isEqualToString:@"全部"]) {
    dic_tmp=[_arr_MyShenPi objectAtIndex:i_index];
    // }
    /*
     else if ([_str_searchKeyword2 isEqualToString:@"全部"]) {
     dic_tmp=[_arr_SearchResult objectAtIndex:i_index];
     }
     */
    //流程标题
    NSString *str_title=[dic_tmp objectForKey:@"processInstName"];
    
    str_title=[NSString stringWithFormat:@"%@%@",@"标题:",str_title];
    CGFloat i_width= [UILabel getWidthWithTitle:str_title font:[UIFont systemFontOfSize:i_otherFont]];
    CGFloat f_linenum=i_width/(Width-160);
    NSInteger i_linenum=0;
    if (f_linenum<1) {
        i_linenum=1;
    }
    else {
        i_linenum=(NSInteger)f_linenum+1;
    }
    
    if (iPad) {
        if  (i_linenum==1) {
            return 100;
        }
        else {
            return  100+35*(i_linenum-1);
        }
    }
    else {
        if  (i_linenum==1) {
            return 70;
        }
        else {
            return  70+23*(i_linenum-1);
        }
        
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // NSString *ID=@"cell";
    NSString *ID=[NSString stringWithFormat:@"Cell%ld%ld",(long)[indexPath section],(long)[indexPath row]];
    MyShenPiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[self CreateCell:tableView indexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyShenPiCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic_tmp=cell.dic_task;
    NSString *str_url=@"";
    if ([cell.lbl_status.text isEqualToString:@"待办"]) {
        NSString *str_key=[dic_tmp objectForKey:@"processDefName"];
        str_url=[dic_url objectForKey:str_key];
        NSString *str_processInstID=[dic_tmp objectForKey:@"processInstID"];
        NSString *str_activityDefID=[dic_tmp objectForKey:@"activityDefID"];
        NSString *str_workItemID=[dic_tmp objectForKey:@"workItemID"];
        NSString *str_processTitle=[dic_tmp objectForKey:@"processInstName"];
        UnFinishVc *vc=[[UnFinishVc alloc]init];
        vc.str_url=str_url;
        vc.str_processInstID=str_processInstID;
        vc.str_activityDefID=str_activityDefID;
        vc.str_workItemID=str_workItemID;
        vc.str_title=str_processTitle;
        vc.delegate=self;
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if ([cell.lbl_status.text isEqualToString:@"已办"]) {
        NSString *str_key=[dic_tmp objectForKey:@"processDefName"];
        NSString *str_processTitle=[dic_tmp objectForKey:@"processInstName"];
        str_url=[dic_url objectForKey:str_key];
        NSString *str_processInstID=[dic_tmp objectForKey:@"processInstId"];
        FinishVc *vc=[[FinishVc alloc]init];
        vc.str_url=str_url;
        vc.str_processInstID=str_processInstID;
        vc.str_title=str_processTitle;
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [self.navigationController pushViewController:vc animated:NO];
        
    }
}

-(MyShenPiCell*)CreateCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    NSDictionary *dic_task;
    //if ([_str_searchKeyword2 isEqualToString:@"全部"] && [_str_searchKeyword1 isEqualToString:@"全部"]) {
    dic_task=[_arr_MyShenPi objectAtIndex:indexPath.section];
    // }
    /*
     else if ([_str_searchKeyword2 isEqualToString:@"全部"]) {
     dic_task=[_arr_SearchResult objectAtIndex:indexPath.section];
     }
     */
    //流程类别
    NSString *str_categroy=[dic_task objectForKey:@"processChName"];
    //流程标题
    NSString *str_title=[dic_task objectForKey:@"processInstName"];
    
    NSString *str_endTime=[dic_task objectForKey:@"endTime"];
    NSString *str_status=@"";
    if (str_endTime!=nil) {
        str_status=@"已办";
    }
    else {
        str_status=@"待办";
    }
    //当前节点名称
    //NSString *str_node=[dic_task objectForKey:@"workItemName"];
    //时间
    NSString *str_startTime=[dic_task objectForKey:@"startTime"];
    NSArray *arr_time=[str_startTime componentsSeparatedByString:@"."];
    NSString *str_time=[arr_time objectAtIndex:0];
    
    CGFloat h_height=[self cellHeightForShenPi:indexPath.section otherFont:14];
    
    //MyShenPiCell *cell=[MyShenPiCell cellWithTable:tableView withTitle:str_title withStatus:@"待办" category:str_categroy withTime:str_startTime];
    // cell.dic_task=dic_task;
    MyShenPiCell *cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withCellHeight:h_height withName:str_title withCategroy:str_categroy withStatus:str_status withTitle:str_title withTime:str_time atIndex:indexPath];
    cell.dic_task=dic_task;
    return cell;
}

-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}


//整理数据
-(void)PrePareData:(NSMutableDictionary*)param interface:(NSString*)str_interface{
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
        NSString *str_urldata=[db fetchInterface:str_interface];
        NSCharacterSet *whitespace = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
        str_urldata= [str_urldata stringByTrimmingCharactersInSet:whitespace];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.refreshControl endRefreshing];
            [indicator stopAnimating];
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                [indicator stopAnimating];
                NSLog(@"获取审批列表成功");
                NSString *str_listname=@"";
                if ([str_interface isEqualToString:@"UnFinishTaskShenPiList"]) {
                    str_listname=@"taskList";
                    NSMutableDictionary *dic_tmpMap =[JSON objectForKey:@"urlMap"];
                    NSArray *arr_tmpMapKey=dic_tmpMap.allKeys;
                    NSArray *arr_tmpMapValue=dic_tmpMap.allValues;
                    for (int i=0;i<[dic_tmpMap count];i++) {
                        NSString *str_Mapkey=[arr_tmpMapKey objectAtIndex:i];
                        NSString *str_Mapvalue=[arr_tmpMapValue objectAtIndex:i];
                        NSString *str_tmp=[dic_url objectForKey:str_Mapkey];
                        if (str_tmp==nil) {
                            [dic_url setObject:str_Mapvalue forKey:str_Mapkey];
                        }
                    }
                    NSArray *arr_tmp_menuItem=[JSON objectForKey:@"MenuItem"];
                    if (arr_tmp_menuItem!=nil) {
                        arr_menuItem=[[NSMutableArray alloc]initWithArray:arr_tmp_menuItem];
                        NSNumber *i_count=[JSON objectForKey:@"count"];
                        NSString *str_count=[NSString stringWithFormat:@"%@",i_count];
                        NSDictionary *dic_all=[NSDictionary dictionaryWithObjectsAndKeys:@"all",@"label",str_count,@"num", nil];
                        [arr_menuItem insertObject:dic_all atIndex:0];
                        if(_i_Class==5) {
                            self.menuView = [[LeftMenuViewNew ShareManager:arr_menuItem] initWithContainerViewController:self];
                            self.menuView.arr_menus=arr_menuItem;
                            self.menuView.menuViewDelegate = self;
                            
                            [self.navigationController.view addSubview:self.menuView];
                        }
                    }
                    else {
                        if (_i_Class==5) {
                            
                        }
                    }
                    
                    NSLog(@"设置设置");
                }
                else if ([str_interface isEqualToString:@"FinishTaskShenPiList"]) {
                    str_listname=@"list";
                    NSMutableDictionary *dic_tmpMap =[JSON objectForKey:@"urlMap"];
                    NSArray *arr_tmpMapKey=dic_tmpMap.allKeys;
                    NSArray *arr_tmpMapValue=dic_tmpMap.allValues;
                    for (int i=0;i<[dic_tmpMap count];i++) {
                        NSString *str_Mapkey=[arr_tmpMapKey objectAtIndex:i];
                        NSString *str_Mapvalue=[arr_tmpMapValue objectAtIndex:i];
                        NSString *str_tmp=[dic_url objectForKey:str_Mapkey];
                        if (str_tmp==nil) {
                            [dic_url setObject:str_Mapvalue forKey:str_Mapkey];
                        }
                    }
                }
                NSArray *arr_list=[JSON objectForKey:str_listname];
                if ([arr_list count]==0) {
                    [arr_MyReview removeAllObjects];
                }
                else {
                    if ([arr_MyReview count]>0) {
                        for (int i=0;i<[arr_list count];i++) {
                            NSDictionary *dic_tmp=[arr_list objectAtIndex:i];
                            if (![arr_MyReview containsObject:dic_tmp]) {
                                [arr_MyReview addObject:dic_tmp];
                            }
                        }
                    }
                    else {
                        [arr_MyReview addObjectsFromArray:arr_list];
                    }
                }
                
                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:NO];
                NSArray* sortedArray = [arr_list sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                arr_MyReview=[[NSMutableArray alloc]initWithArray:sortedArray];
                
                NSString *str_totalPage=[JSON objectForKey:@"totalPage"];
                _i_page_Total=[str_totalPage integerValue];
                               // if ([_str_searchKeyword2 isEqualToString:@"全部"] && [_str_searchKeyword1 isEqualToString:@"全部"]) {
                _arr_MyShenPi=[arr_MyReview mutableCopy];
                // }
                /*
                 else if ([_str_searchKeyword2 isEqualToString:@"全部"]) {
                 _arr_SearchResult=[arr_MyReview mutableCopy];
                 }
                 */
                [self.tableView reloadData];
                // [self.tableView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            //停止刷新
            [self.refreshControl endRefreshing];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"无法连接到服务器" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
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


-(void)handleRefresh:(id)paramSender {
    // 模拟2秒后刷新数据
    int64_t delayInSeconds = 2.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [arr_MyReview removeAllObjects];
        if (_b_isDaiBan==YES) {
            if ([str_cell_hint isEqualToString:@"all"]) {
                dic_param[@"pageIndex"]=@"1";
                dic_param[@"sys"]=[NSString stringWithFormat:@"%ld",(long)_i_Class];
                [self PrePareData:dic_param interface:@"UnFinishTaskShenPiList"];
            }
            else {
                NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:str_cell_hint,@"processDefnames",@"1",@"pageIndex",nil];
                [self LoadSubData:str_cell_hint param:param];
            }
        }
        else {
            dic_param[@"pageIndex"]=@"1";
            dic_param[@"sys"]=[NSString stringWithFormat:@"%ld",(long)_i_Class];
            [self PrePareData:dic_param interface:@"FinishTaskShenPiList"];
        }
        [indicator stopAnimating];
        //tableview中插入一条数据
        //[self NewsList:_news_param];
        
    });
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

-(void)RefreshUnFinishView {
    [arr_MyReview removeAllObjects];
    _i_pageIndex=1;
    if ([str_cell_hint isEqualToString:@"all"]) {
        dic_param[@"pageIndex"]=@"1";
        dic_param[@"sys"]=[NSString stringWithFormat:@"%ld",(long)_i_Class];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self PrePareData:dic_param interface:@"UnFinishTaskShenPiList"];
    }
    else {
        NSMutableDictionary *dic_sub_param=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"pageIndex",str_cell_hint,@"processDefnames", nil];
        [self LoadSubData:str_cell_hint param:dic_sub_param];
    }
    
    
    
    
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height=scrollView.frame.size.height;
    CGFloat contentYoffset=scrollView.contentOffset.y;
    CGFloat distanceFromBottom=scrollView.contentSize.height-contentYoffset;
    //NSLog(@"height:%f contentYoffset:%f frame.y:%f",height,contentYoffset,scrollView.frame.origin.y);
    if (distanceFromBottom<height) {
        if (_i_pageIndex<_i_page_Total) {
            _i_pageIndex=_i_pageIndex+1;
            dic_param[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
            dic_param[@"sys"]=[NSString stringWithFormat:@"%ld",(long)_i_Class];
            if (_b_isDaiBan==NO) {
                [self PrePareData:dic_param interface:@"FinishTaskShenPiList"];
            }
            else {
                if ([str_cell_hint isEqualToString:@"all"]) {
                    [self PrePareData:dic_param interface:@"UnFinishTaskShenPiList"];
                }
                else {
                    NSString *str_pageIndex=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex];
                    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:str_cell_hint,@"processDefnames",str_pageIndex,@"pageIndex",nil];
                    [self LoadSubData:str_cell_hint param:param];
                }
            }

        }
    }
}

//根据左侧菜单点击结果，筛选细分
-(void)LoadSubData:(NSString*)str_hint param:(NSMutableDictionary*)dic_sub_param {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]) {
        if (_b_isDaiBan==YES && _i_Class==5) {
            NSString *str_ip=@"";
            NSString *str_port=@"";
            NSMutableArray *t_array=[db fetchIPAddress];
            if (t_array.count==1) {
                NSArray *arr_ip=[t_array objectAtIndex:0];
                str_ip=[arr_ip objectAtIndex:0];
                str_port=[arr_ip objectAtIndex:1];
            }
            NSString *str_urldata=@"/default/com.hnsi.erp.mobile.oa.TaskAuditSearch.pendingListByDef.biz.ext";
           
            NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
                        [_session POST:str_url parameters:dic_sub_param progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [indicator stopAnimating];
                NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSString *str_success= [JSON objectForKey:@"success"];
                BOOL b_success=[str_success boolValue];
                if (b_success==YES) {
                        NSLog(@"测试测试");
                        NSMutableDictionary *dic_tmpMap =[JSON objectForKey:@"urlMap"];
                        NSMutableArray *arr_list=[JSON objectForKey:@"taskList"];
                        if ([arr_list count]==0) {
                            [arr_MyReview removeAllObjects];
                        }
                        else {
                            if ([arr_MyReview count]>0) {
                                for (int i=0;i<[arr_list count];i++) {
                                    NSDictionary *dic_tmp=[arr_list objectAtIndex:i];
                                    if (![arr_MyReview containsObject:dic_tmp]) {
                                        [arr_MyReview addObject:dic_tmp];
                                    }
                                }
                            }
                            else {
                                [arr_MyReview addObjectsFromArray:arr_list];
                            }
                        }
                        
                        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:NO];
                        NSArray* sortedArray = [arr_list sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                        arr_MyReview=[[NSMutableArray alloc]initWithArray:sortedArray];
                        [dic_url removeAllObjects];
                        dic_url=dic_tmpMap;
                        NSString *str_totalPage=[JSON objectForKey:@"totalPage"];
                        _i_page_Total=[str_totalPage integerValue];
                        _arr_MyShenPi=[arr_MyReview mutableCopy];
                    [self.tableView reloadData];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    }
}



-(void)LeftMenuViewActionIndex:(NSString *)vType {
    [self.menuView closeLeftView];
    str_cell_hint=vType;
    [indicator startAnimating];
    if ([str_cell_hint isEqualToString:@"all"]) {
        [self PrePareData:dic_param interface:@"UnFinishTaskShenPiList"];
    }
    else {
        NSString *str_title= [db fetchShiWu:vType];
        super.title=str_title;
        NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:str_cell_hint,@"processDefnames",@"1",@"pageIndex",nil];
        [self LoadSubData:vType param:param];
    }

}
/*
-(NSComparisonResult)startTimeCompare:(NSDictionary*)otherObject {
    
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
