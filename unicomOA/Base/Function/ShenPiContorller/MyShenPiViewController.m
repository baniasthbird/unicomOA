//
//  MyShenPiViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "MyShenPiViewController.h"
#import "UIView+SDAutoLayout.h"
#import "MCMenuButton.h"
#import "MCPopMenuViewController.h"
#import "MyShenPiCell.h"
#import "CarService.h"
#import "PrintService.h"
#import "CarShenPiDetail.h"
#import "PrintShenPiDetail.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "UnFinishVc.h"
#import "FinishVc.h"


@interface MyShenPiViewController()<UITableViewDelegate,UITableViewDataSource,UnFinishVcDelegate>

/**
 *  头部筛选模块
 */
@property (nonatomic,strong,nonnull)UIView *topView;
@property (nonatomic,strong,nonnull)MCMenuButton *levelButton;
@property (nonatomic,strong,nonnull)MCMenuButton *groupButton;

@property (nonatomic,strong,nonnull)NSArray *leftArray;
@property (nonatomic,strong,nonnull)NSArray *rightArray;

//菜单图片
@property (nonatomic,strong,nonnull) NSArray *leftImgArray;
@property (nonatomic,strong,nonnull) NSArray *rightImgArray;

//菜单颜色
@property (nonatomic,strong,nonnull) NSArray *leftArrayColor;
@property (nonatomic,strong,nonnull) NSArray *rightArrayColor;

@property (nonatomic,strong) UITableView *tableView;

@property NSInteger i_sectionClicked;

//审批状态搜索关键字
@property (nonatomic,strong) NSString *str_searchKeyword1;

//审批类型搜索关键字
@property (nonatomic,strong) NSString *str_searchKeyword2;


@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

//待办流程总页数
@property NSInteger i_page_Total1;

@property NSInteger i_page_Total2;
//待办流程当前页
@property NSInteger i_pageIndex1;
//已办流程当前页
@property NSInteger i_pageIndex2;
@end

@implementation MyShenPiViewController {
    DataBase *db;
    //获取我的审批列表，包括已办与待办
    NSMutableArray *arr_MyReview;
    //待办请求参数字典
    NSMutableDictionary *dic_param1;
    //已办请求参数字典
    NSMutableDictionary *dic_param2;
    //展现待办流程数据的url
    NSMutableDictionary *dic_url1;
    //展现已办流程数据的url
    NSMutableDictionary *dic_url2;
    
   UIActivityIndicatorView *indicator;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的审批";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    

    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _arr_SearchResult=[[NSMutableArray alloc]init];
    dic_param1=[NSMutableDictionary dictionary];
    dic_param2=[NSMutableDictionary dictionary];
   
    indicator=[self AddLoop];
    arr_MyReview=[[NSMutableArray alloc]init];
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];
    
    _i_sectionClicked=-1;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-150) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled=YES;
    _tableView.backgroundColor=[UIColor clearColor];
    
    //设置refreshControl的属性
    _refreshControl=[[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];

    
    
    [self.view addSubview:_tableView];
    
    dic_url1=[NSMutableDictionary dictionary];
    dic_url2=[NSMutableDictionary dictionary];
   
    _i_pageIndex1=1;
    _i_pageIndex2=1;
    dic_param1[@"pageIndex"]=@"1";
    //dic_param2[@"pageIndex"]=@"1";
    [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];
    //[self PrePareData:dic_param2 interface:@"FinishTaskShenPiList"];
    
    self.leftArray=@[@"全部",@"已办",@"待办"];
    //self.rightArray=@[@"全部",@"复印",@"预约用车",@"信息发布"];
    self.rightArray=@[];
    
    self.leftImgArray=@[@" ",@"mission_done.png",@"mission_unfinished.png"];
   // self.rightImgArray=@[@" ",@"printmission.png",@"carmission.png"];
    
    self.leftArrayColor=@[[UIColor blackColor],[UIColor colorWithRed:25/255.0f green:189/255.0f blue:144/255.0f alpha:1],[UIColor colorWithRed:246/255.0f green:88/255.0f blue:87/255.0f alpha:1]];
    self.rightArrayColor=@[[UIColor blackColor],[UIColor colorWithRed:246/255.0f green:88/255.0f blue:87/255.0f alpha:1],[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1],[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1]];

    
    _str_searchKeyword1=@"待办";
    _str_searchKeyword2=@"全部";
    
    [self setupTopView];
    
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
}

-(void)MovePreviousVc:(UIButton*)sender {
    [_delegate RefreshBadgeNumber];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  设置头部
 */
- (void)setupTopView
{
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topView];
    self.topView.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(44)
    .topSpaceToView(self.view,0);
    
    CGFloat w_left= [UIScreen mainScreen].bounds.size.width;
    int i_left=(int)w_left/4;
    self.levelButton = [[MCMenuButton alloc] initWithTitle:@"状态"];
    [self.levelButton setArrowDirectionDown];
    [self.topView addSubview:self.levelButton];
    self.levelButton.sd_layout
    .leftSpaceToView(self.topView,i_left)
    .topSpaceToView(self.topView,5)
    .bottomSpaceToView(self.topView,5)
    .widthRatioToView(self.topView,0.5);
    self.levelButton.layer.cornerRadius=17.0f;
    self.levelButton.layer.borderWidth=1;
    [self.levelButton.layer setMasksToBounds:YES];
    self.levelButton.layer.borderColor=[[UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1] CGColor];
   
    
    self.groupButton = [[MCMenuButton alloc] initWithTitle:@"类型"];
   // [self.topView addSubview:self.groupButton];
    self.groupButton.sd_layout
    .leftSpaceToView(self.levelButton,-30)
    .topSpaceToView(self.topView,5)
    .bottomSpaceToView(self.topView,5)
    .widthRatioToView(self.topView,0.4);
    self.groupButton.layer.cornerRadius=20.0f;
    self.groupButton.layer.borderWidth=1;
    [self.groupButton.layer setMasksToBounds:YES];
    self.groupButton.layer.borderColor=[[UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1] CGColor];
    
    self.levelButton.backgroundColor=[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1];
    [self.levelButton setTitleColor:[UIColor whiteColor]];
    
    self.groupButton.backgroundColor=[UIColor whiteColor];
    [self.groupButton setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1]];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.topView addSubview:lineView];
    lineView.sd_layout.leftSpaceToView(self.topView,0).rightSpaceToView(self.topView,0).bottomEqualToView(self.topView).heightIs(0.5);
    
    
    
    __weak typeof(self) weakSelf = self;
    //点击等级
    self.levelButton.clickedBlock = ^(id data){
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        //[weakSelf.levelButton setArrowDirectionUp];

        
        weakSelf.levelButton.backgroundColor=[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1];
        [weakSelf.levelButton setTitleColor:[UIColor whiteColor]];
        
        weakSelf.groupButton.backgroundColor=[UIColor whiteColor];
        [weakSelf.groupButton setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1]];
        
        for (int i = 0 ; i < self.leftArray.count ; i++ ) {
            
            MCPopMenuItem *item = [[MCPopMenuItem alloc] init];
            item.itemid = @"0";
            item.itemtitle = weakSelf.leftArray[i];
            item.itmeImageName=weakSelf.leftImgArray[i];
            item.itemtitleColor=weakSelf.leftArrayColor[i];
            [arrayM addObject:item];
        }
        
        MCPopMenuViewController *popVc = [[MCPopMenuViewController alloc] initWithDataSource:arrayM fromView:weakSelf.topView];
        [popVc show];
        popVc.didSelectedItemBlock = ^(MCPopMenuItem *item){
            [weakSelf.levelButton refreshWithTitle:item.itemtitle];
            weakSelf.levelButton.extend = item;
            weakSelf.str_searchKeyword1=item.itemtitle;
            weakSelf.arr_SearchResult= [weakSelf CreateSearchResult:weakSelf.str_searchKeyword1 con2:weakSelf.str_searchKeyword2];
            [weakSelf.tableView reloadData];
            
        };
    };
    
    //点击等级
    self.groupButton.clickedBlock = ^(id data){
        
        NSMutableArray *arrayM = [NSMutableArray array];
        
        weakSelf.groupButton.backgroundColor=[UIColor colorWithRed:80/255.0f green:125/255.0f blue:236/255.0f alpha:1];
        [weakSelf.groupButton setTitleColor:[UIColor whiteColor]];
        
        weakSelf.levelButton.backgroundColor=[UIColor whiteColor];
        [weakSelf.levelButton setTitleColor:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1]];
        
        for (int i = 0 ; i < self.rightArray.count ; i++ ) {
            
            MCPopMenuItem *item = [[MCPopMenuItem alloc] init];
            item.itemid = @"0";
            item.itemtitle = weakSelf.rightArray[i];
            item.itmeImageName=weakSelf.rightImgArray[i];
            item.itemtitleColor=weakSelf.rightArrayColor[i];
            [arrayM addObject:item];
        }
        
        MCPopMenuViewController *popVc = [[MCPopMenuViewController alloc] initWithDataSource:arrayM fromView:weakSelf.topView];
        [popVc show];
        popVc.didSelectedItemBlock = ^(MCPopMenuItem *item){
            
            [weakSelf.groupButton refreshWithTitle:item.itemtitle];
            weakSelf.groupButton.extend = item;
            weakSelf.str_searchKeyword2=item.itemtitle;
            weakSelf.arr_SearchResult= [weakSelf CreateSearchResult:weakSelf.str_searchKeyword1 con2:weakSelf.str_searchKeyword2];
            [weakSelf.tableView reloadData];
            
        };
    };
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_str_searchKeyword2 isEqualToString:@"全部"] && [_str_searchKeyword1 isEqualToString:@"全部"]) {
        return [_arr_MyShenPi count];
    }
    else {
        return   [_arr_SearchResult count];
    }
    
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
    return 110;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // NSString *ID=@"cell";
   NSString *ID=[NSString stringWithFormat:@"Cell%ld%ld",(long)[indexPath section],(long)[indexPath row]];
    MyShenPiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
           cell=[self CreateCell:tableView indexPath:indexPath];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyShenPiCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic_tmp=cell.dic_task;
    NSString *str_url=@"";
    if ([cell.lbl_status.text isEqualToString:@"待办"]) {
        NSString *str_key=[dic_tmp objectForKey:@"processDefName"];
        str_url=[dic_url1 objectForKey:str_key];
        NSString *str_processInstID=[dic_tmp objectForKey:@"processInstID"];
        NSString *str_activityDefID=[dic_tmp objectForKey:@"activityDefID"];
        NSString *str_workItemID=[dic_tmp objectForKey:@"workItemID"];
        UnFinishVc *vc=[[UnFinishVc alloc]init];
        vc.str_url=str_url;
        vc.str_processInstID=str_processInstID;
        vc.str_activityDefID=str_activityDefID;
        vc.str_workItemID=str_workItemID;
        vc.delegate=self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([cell.lbl_status.text isEqualToString:@"已办"]) {
        NSString *str_key=[dic_tmp objectForKey:@"processDefName"];
        str_url=[dic_url2 objectForKey:str_key];
        NSString *str_processInstID=[dic_tmp objectForKey:@"processInstId"];
        FinishVc *vc=[[FinishVc alloc]init];
        vc.str_url=str_url;
        vc.str_processInstID=str_processInstID;
        [self.navigationController pushViewController:vc animated:YES];

    }
    /*
     _i_sectionClicked=indexPath.section;
    if ([cell.str_category isEqualToString:@"预约用车"]) {
        CarShenPiDetail *viewController=[[CarShenPiDetail alloc]init];
        viewController.service=cell.car_service;
        viewController.user_Info=_userInfo;
        viewController.delegate=self;
        if ([cell.lbl_status.text isEqualToString:@"同意"] || [cell.lbl_status.text isEqualToString:@"不同意"]) {
            viewController.b_IsEnabled=NO;
        }
        else {
            viewController.b_IsEnabled=YES;
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([cell.str_category isEqualToString:@"复印"]) {
        PrintShenPiDetail *viewController=[[PrintShenPiDetail alloc]init];
        viewController.service=cell.print_service;
        viewController.user_Info=_userInfo;
        viewController.delegate=self;
        if ([cell.lbl_status.text isEqualToString:@"同意"] || [cell.lbl_status.text isEqualToString:@"不同意"]) {
            viewController.b_isEnabled=NO;
        }
        else {
            viewController.b_isEnabled=YES;
        }

        [self.navigationController pushViewController:viewController animated:YES];
    }
     */
}

//刷新表格，后期刷新单个section
-(void)CarRefreshTableView {
    [_tableView reloadData];
    /*
    if (_i_sectionClicked!=-1) {
        NSIndexSet *nd=[[NSIndexSet alloc]initWithIndex:_i_sectionClicked];
        [_tableView reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];
    }
     */
    

}

-(void)PrintRefreshTableView {
    [_tableView reloadData];
    /*
     if (_i_sectionClicked!=-1) {
     NSIndexSet *nd=[[NSIndexSet alloc]initWithIndex:_i_sectionClicked];
     [_tableView reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];
     }
     */
}


//根据条件筛选
-(NSMutableArray*)CreateSearchResult:(NSString*)str_condition1 con2:(NSString*)str_condition2 {
    NSMutableArray *arr_result=[[NSMutableArray alloc]init];
    if (_arr_MyShenPi.count>0 || _arr_SearchResult.count>0) {
        if ([str_condition1 isEqualToString:@"全部"] && [str_condition2 isEqualToString:@"全部"]) {
            //根据类型筛选
            [arr_MyReview removeAllObjects];
            _i_pageIndex1=1;
            _i_pageIndex2=1;
            dic_param1[@"pageIndex"]=@"1";
            dic_param2[@"pageIndex"]=@"1";
            [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];
            [self PrePareData:dic_param2 interface:@"FinishTaskShenPiList"];
        }
        else if ([str_condition2 isEqualToString:@"全部"])
        {
                //根据已办待办筛选
                [arr_MyReview removeAllObjects];
                if ([str_condition1 isEqualToString:@"已办"]) {
                    _i_pageIndex2=1;
                    dic_param2[@"pageIndex"]=@"1";
                    [self PrePareData:dic_param2 interface:@"FinishTaskShenPiList"];
                }
                else if ([str_condition1 isEqualToString:@"待办"]) {
                    _i_pageIndex1=1;
                    dic_param1[@"pageIndex"]=@"1";
                    [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];
                }
            
        }
        /*
        if ([str_condition1 isEqualToString:@"全部"]) {
            arr_result= [self CreateSearchResultAdvanced:_arr_MyShenPi con2:str_condition2];
        }
        else {
            arr_result=[self CreateSearchResultFirst:_arr_MyShenPi con1:str_condition1];
            arr_result=[self CreateSearchResultAdvanced:arr_result con2:str_condition2];
        }
        */
    }
    return arr_result;
}


//根据第一个条件筛选原数组
-(NSMutableArray *)CreateSearchResultFirst:(NSMutableArray*)arr_origin con1:(NSString*)str_condition {
    NSMutableArray *arr_tmp=[[NSMutableArray alloc]init];
    for (int i=0;i<arr_origin.count;i++) {
        NSObject *tmp=[arr_origin objectAtIndex:i];
        PrintService *tmp_Print;
        CarService *tmp_Car;
        if ([tmp isMemberOfClass:[PrintService class]]) {
            tmp_Print=(PrintService*)tmp;
        }
        else if ([tmp isMemberOfClass:[CarService class]]) {
            tmp_Car=(CarService*)tmp;
        }
        if ([str_condition isEqualToString:@"审批中"]) {
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2==nil) {
                if ([tmp_Print.shenpi_1.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2==nil) {
                if ([tmp_Car.shenpi_1.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
        }
        else if ([str_condition isEqualToString:@"同意"]) {
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2!=nil) {
                if ([tmp_Print.shenpi_1.str_status isEqualToString:@"同意"] && [tmp_Print.shenpi_2.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2!=nil) {
                if ([tmp_Car.shenpi_1.str_status isEqualToString:@"同意"] && [tmp_Car.shenpi_2.str_status isEqualToString:@"同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
            
        }
        else if ([str_condition isEqualToString:@"不同意"]) {
            if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2==nil) {
                if ([tmp_Print.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            else if (tmp_Print.shenpi_1!=nil && tmp_Print.shenpi_2!=nil) {
                if ([tmp_Print.shenpi_2.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Print];
                }
            }
            if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2==nil) {
                if ([tmp_Car.shenpi_1.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
            else if (tmp_Car.shenpi_1!=nil && tmp_Car.shenpi_2!=nil) {
                if ([tmp_Car.shenpi_2.str_status isEqualToString:@"不同意"]) {
                    [arr_tmp addObject:tmp_Car];
                }
            }
        }
    }
    
    return arr_tmp;
    
}


//确定第一个条件后再次筛选
-(NSMutableArray*)CreateSearchResultAdvanced:(NSMutableArray*)arr_firstsearch con2:(NSString*)str_condition {
    NSMutableArray *arr_tmp=[[NSMutableArray alloc]init];
    if ([str_condition isEqualToString:@"全部"]) {
        return arr_firstsearch;
    }
    else if ([str_condition isEqualToString:@"复印"]) {
        for (int i=0;i<arr_firstsearch.count;i++) {
            NSObject *tmp=[arr_firstsearch objectAtIndex:i];
            if ([tmp isMemberOfClass:[PrintService class]]) {
                PrintService *tmp_Print=(PrintService*)tmp;
                [arr_tmp addObject:tmp_Print];
            }
        }
    }
    else if ([str_condition isEqualToString:@"预约用车"]) {
        for (int i=0;i<arr_firstsearch.count;i++) {
            NSObject *tmp=[arr_firstsearch objectAtIndex:i];
            if ([tmp isMemberOfClass:[CarService class]]) {
                CarService *tmp_Car=(CarService*)tmp;
                [arr_tmp addObject:tmp_Car];
            }
        }
    }
    
    return arr_tmp;
}


-(MyShenPiCell*)CreateCarCell:(CarService*)service tableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    MyShenPiCell *cell;
    //zr 0503 因为角色不同，所以cell中显示的待办与已办不同，没处理时为待办，处理一个层级后，对于第一层级领导来说是已办，对于第二层级领导来说是待办，目前由于流程角色未分配，按照第二级审批完成变成已办处理
        if (service.shenpi_1==nil && service.shenpi_2==nil) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"预约用车" withStatus:@"待办" withTitle:service.str_reason withTime:service.str_applicationTime atIndex:indexPath];
        }
        else if (service.shenpi_1!=nil && service.shenpi_2==nil) {
            if ([service.shenpi_1.str_status isEqualToString:@"同意"]) {
                cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"预约用车" withStatus:@"待办" withTitle:service.str_reason withTime:service.shenpi_1.str_time atIndex:indexPath];
            }
            else if ([service.shenpi_1.str_status isEqualToString:@"不同意"]) {
                cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"预约用车" withStatus:@"已办" withTitle:service.str_reason withTime:service.shenpi_1.str_time atIndex:indexPath];
            }
        }
        else if (service.shenpi_2!=nil) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"预约用车" withStatus:@"已办" withTitle:service.str_reason withTime:service.shenpi_2.str_time atIndex:indexPath];
        }
        cell.car_service=service;
        cell.str_category=@"预约用车";
        return cell;
}

-(MyShenPiCell*)CreatePrintCell:(PrintService*)service tableView:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath {
    MyShenPiCell *cell;
    if (service.shenpi_1==nil && service.shenpi_2==nil) {
        cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"复印" withStatus:@"待办" withTitle:service.str_title withTime:service.str_applicationTime atIndex:indexPath];
    }
    else if (service.shenpi_1!=nil && service.shenpi_2==nil) {
        if ([service.shenpi_1.str_status isEqualToString:@"同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"复印" withStatus:@"待办" withTitle:service.str_title withTime:service.shenpi_1.str_time atIndex:indexPath];
        }
        else if ([service.shenpi_1.str_status isEqualToString:@"不同意"]) {
            cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"复印" withStatus:@"已办" withTitle:service.str_title withTime:service.shenpi_1.str_time atIndex:indexPath];
        }
    }
    else if (service.shenpi_2!=nil) {
        cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:service.str_name withCategroy:@"复印" withStatus:@"已办" withTitle:service.str_title withTime:service.shenpi_1.str_time atIndex:indexPath];
    }
    cell.print_service=service;
    cell.str_category=@"复印";
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
                        NSString *str_tmp=[dic_url1 objectForKey:str_Mapkey];
                        if (str_tmp==nil) {
                            [dic_url1 setObject:str_Mapvalue forKey:str_Mapkey];
                        }
                    }
                }
                else if ([str_interface isEqualToString:@"FinishTaskShenPiList"]) {
                    str_listname=@"list";
                    NSMutableDictionary *dic_tmpMap =[JSON objectForKey:@"urlMap"];
                    NSArray *arr_tmpMapKey=dic_tmpMap.allKeys;
                    NSArray *arr_tmpMapValue=dic_tmpMap.allValues;
                    for (int i=0;i<[dic_tmpMap count];i++) {
                        NSString *str_Mapkey=[arr_tmpMapKey objectAtIndex:i];
                        NSString *str_Mapvalue=[arr_tmpMapValue objectAtIndex:i];
                        NSString *str_tmp=[dic_url2 objectForKey:str_Mapkey];
                        if (str_tmp==nil) {
                            [dic_url2 setObject:str_Mapvalue forKey:str_Mapkey];
                        }
                    }
                }
                NSArray *arr_list=[JSON objectForKey:str_listname];
                for (int i=0;i<[arr_list count];i++) {
                    [arr_MyReview addObject:[arr_list objectAtIndex:i]];
                }
                NSString *str_totalPage=[JSON objectForKey:@"totalPage"];
                if ([str_interface isEqualToString:@"UnFinishTaskShenPiList"]) {
                    _i_page_Total1=[str_totalPage integerValue];
                }
                else if ([str_interface isEqualToString:@"FinishTaskShenPiList"]) {
                    _i_page_Total2=[str_totalPage integerValue];
                }
                if ([_str_searchKeyword2 isEqualToString:@"全部"] && [_str_searchKeyword1 isEqualToString:@"全部"]) {
                    _arr_MyShenPi=[arr_MyReview mutableCopy];
                }
                else if ([_str_searchKeyword2 isEqualToString:@"全部"]) {
                    _arr_SearchResult=[arr_MyReview mutableCopy];
                }
                
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



-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height=scrollView.frame.size.height;
    CGFloat contentYoffset=scrollView.contentOffset.y;
    CGFloat distanceFromBottom=scrollView.contentSize.height-contentYoffset;
    //NSLog(@"height:%f contentYoffset:%f frame.y:%f",height,contentYoffset,scrollView.frame.origin.y);
    if (distanceFromBottom<height) {
        //  NSLog((@"end of table"));
        if ([_str_searchKeyword1 isEqualToString:@"全部"])
        {
            //  [self PareData:dic_param];
            //   [self PareData:dic_param interface:@"FinishTaskShenPiList"];
            if (_i_pageIndex1<_i_page_Total1) {
                _i_pageIndex1=_i_pageIndex1+1;
                dic_param1[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex1];
                [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];
            }
            if (_i_pageIndex2<_i_page_Total2) {
                _i_pageIndex2=_i_pageIndex2+1;
                dic_param2[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex2];
                [self PrePareData:dic_param2 interface:@"FinishTaskShenPiList"];
            }
        }
        else if ([_str_searchKeyword1 isEqualToString:@"已办"]) {
            if (_i_pageIndex2<_i_page_Total2) {
                _i_pageIndex2=_i_pageIndex2+1;
                dic_param2[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex2];
                [self PrePareData:dic_param2 interface:@"FinishTaskShenPiList"];
            }
        }
        else if ([_str_searchKeyword1 isEqualToString:@"待办"]) {
            if (_i_pageIndex1<_i_page_Total1) {
                _i_pageIndex1=_i_pageIndex1+1;
                dic_param1[@"pageIndex"]=[NSString stringWithFormat:@"%ld",(long)_i_pageIndex1];
                [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];
            }
        }
        
    }
}

-(MyShenPiCell*)CreateCell:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    NSDictionary *dic_task;
    if ([_str_searchKeyword2 isEqualToString:@"全部"] && [_str_searchKeyword1 isEqualToString:@"全部"]) {
        dic_task=[_arr_MyShenPi objectAtIndex:indexPath.section];
    }
    else if ([_str_searchKeyword2 isEqualToString:@"全部"]) {
        dic_task=[_arr_SearchResult objectAtIndex:indexPath.section];
    }
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
    
    //MyShenPiCell *cell=[MyShenPiCell cellWithTable:tableView withTitle:str_title withStatus:@"待办" category:str_categroy withTime:str_startTime];
   // cell.dic_task=dic_task;
    MyShenPiCell *cell=[MyShenPiCell cellWithTable:tableView withImage:_userInfo.str_Logo withName:str_title withCategroy:str_categroy withStatus:str_status withTitle:str_title withTime:str_startTime atIndex:indexPath];
    cell.dic_task=dic_task;
    return cell;
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
        [arr_MyReview removeAllObjects];
        if ([_str_searchKeyword1 isEqualToString:@"全部"]) {
            dic_param1[@"pageIndex"]=@"1";
            dic_param2[@"pageIndex"]=@"1";
            [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];
            [self PrePareData:dic_param2 interface:@"FinishTaskShenPiList"];
        }
        else if ([_str_searchKeyword1 isEqualToString:@"待办"]) {
            dic_param1[@"pageIndex"]=@"1";
            [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];
            
        }
        else if ([_str_searchKeyword1 isEqualToString:@"已办"]) {
            dic_param2[@"pageIndex"]=@"1";
            [self PrePareData:dic_param2 interface:@"FinishTaskShenPiList"];
        }
        [indicator stopAnimating];
        //tableview中插入一条数据
        //[self NewsList:_news_param];
       
    });
}


-(void)RefreshUnFinishView {
    [arr_MyReview removeAllObjects];
    dic_param1[@"pageIndex"]=@"1";
    [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];
}


@end
