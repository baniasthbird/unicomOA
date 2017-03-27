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
#import "SysMsgViewController.h"
#import "UnFinishViewController.h"
#import "INTULocationManager.h"
#import "WeatherData.h"
#import "WeatherViewController.h"
#import "NewsNewsTableViewCell.h"
#import "NewsInformTableViewCell.h"
#import "FFDropDownMenuView.h"
#import "DWBubbleMenuButton.h"
#import "WZLBadgeImport.h"
#import "XSpotLight.h"
#import "PushMsgVC.h"



@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,NewsTapDelegate,YBMonitorNetWorkStateDelegate,RemindCellDelegate,MyShenPiViewControllerDelegate,XSpotLightDelegate,PushMsgVCDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property  NSInteger count;

@property NSInteger news_count;

@property NSInteger i_doc_num;

@property NSInteger i_flow_num;

@property NSInteger i_msg_num;

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSMutableArray *arr_NewsList;

@property (nonatomic,strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign) double lati;

@property (nonatomic, assign) double longi;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *dt;    //当前日期

/** 下拉菜单 */
//@property (nonatomic, strong) FFDropDownMenuView *dropdownMenu;

@end

@implementation MessageViewController {
    DataBase *db;
    UIActivityIndicatorView *indicator;
    CGFloat i_totalHeight;
    NSInteger selectedIndex;
    
    NSString *selected_title;
    
    BOOL b_ReplaceDataSource;
    
    NSTimer *timer;
    
    NSString *str_ip;
    
    NSString *str_port;
    
    CGFloat i_titleFont;
    CGFloat i_otherFont;
    
    UIButton *btn_title1;
    
    UIButton *btn_title2;
    
    UIButton *btn_title3;
    
    NSArray *modelsArray;
    
    DWBubbleMenuButton *bubbleMenuButton;
    
    NSMutableArray *arr_Push_Msg;
    
    
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

-(CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
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
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor clearColor];
   

    _arr_NewsList=[[NSMutableArray alloc]init];
    
    i_totalHeight=0;
    _refreshControl=[[UIRefreshControl alloc] init];
    
    //设置refreshControl的属性
    _refreshControl.attributedTitle=[[NSAttributedString alloc]initWithString:@"加载中..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];
    
    
    [self.view insertSubview:_tableView atIndex:0];
    [self addBubbleMenu];
    _news_count=0;
    
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];
    
    //zr 0809
    
    indicator=[self AddLoop];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    NSMutableDictionary *news_param=[NSMutableDictionary dictionary];
    news_param[@"pageIndex"]=@"1";
    news_param[@"classId"]=@"0";
    for (int i=1;i<3;i++) {
        news_param[@"type"]=[NSString stringWithFormat:@"%d",i];
        [self NewsList:news_param];
    }
   
    if (iPhone6_plus) {
        i_titleFont=17;
        i_otherFont=14;
    }
    else if (iPad) {
        i_titleFont=24;
        i_otherFont=18;
    }
    else {
        i_titleFont=17;
        i_otherFont=11;
    }

    
    [self NewsCount];
    
    [self setupLocation];
    
    arr_Push_Msg=[[NSMutableArray alloc]init];
    //添加消息响应
    UIButton *btn_notification=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
    [btn_notification setImage:[UIImage imageNamed:@"push_notification1"] forState:UIControlStateSelected];
    [btn_notification setImage:[UIImage imageNamed:@"push_notification"] forState:UIControlStateNormal];
   // [btn_notification setTitle:@"推送" forState:UIControlStateNormal];
    BOOL b_new_notification=[[NSUserDefaults standardUserDefaults] boolForKey:@"GetNotification"];
    btn_notification.selected=b_new_notification;
    [btn_notification setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 45)];
    [btn_notification addTarget:self action:@selector(PushNotification:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_notification];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    XSpotLight *SpotLight=[[XSpotLight alloc]init];
    SpotLight.messageArray=@[@"快速审批以悬浮球方式展现"];
    CGFloat i_img_width = 40.0f;
    CGFloat button_offset_y=85.0f;
    CGFloat button_offset_x=60.0f;
    if (iPhone6) {
        i_img_width = 45.0f;
        button_offset_y = 95.0f;
        button_offset_x=55.0f;
    }
    else if (iPhone6_plus) {
        i_img_width=50.0f;
        button_offset_y = 100.0f;
        button_offset_x=55.0f;
    }
    // SpotLight.rectArray=@[[NSValue valueWithCGRect:CGRectMake(i_x, i_y, 50, 500)]];
    SpotLight.rectArray=@[[NSValue valueWithCGRect:CGRectMake(Width-button_offset_x, Height-button_offset_y,i_img_width , i_img_width)]];
    SpotLight.delegate=self;
   
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
    //    [self presentViewController:SpotLight animated:NO completion:^{
            
    //    }];
    }
    
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    param[@"userId"]=[NSString stringWithFormat:@"%@",_userInfo.str_empid];
    [self GetPushNotification:param];

    
    timer=[NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(setupLocation) userInfo:nil repeats:YES];
    
    
}


/** 显示下拉菜单 */
/*
- (void)showDropDownMenu:(UIButton*)sender  {
    for (CALayer *sublayer in sender.layer.sublayers) {
        if ([sublayer isKindOfClass:[CATextLayer class]]) {
            [sublayer removeFromSuperlayer];
        }
    }
    [self.dropdownMenu showMenu];
}
*/
/** 初始化下拉菜单 */
/*
- (void)setupDropDownMenu:(NSInteger)i_flow_num doc_num:(NSInteger)i_doc_num msg_num:(NSInteger)i_msg_num {
    modelsArray = [self getMenuModelsArray:i_flow_num doc_num:i_doc_num msg_num:i_msg_num];
    
    self.dropdownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray menuWidth:FFDefaultFloat eachItemHeight:FFDefaultFloat menuRightMargin:FFDefaultFloat triangleRightMargin:FFDefaultFloat];
}
*/

-(void)setupsectionView {
    CGRect frameRect = CGRectMake(0, 70, self.view.frame.size.width, 40);
    
    UIView *seperate_view = [[UIView alloc] initWithFrame:frameRect];
    
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newsbodcast.png"]];
    
    [img setFrame:CGRectMake(20, 5, 20, 20)];
    
    // [view addSubview:img];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(25, 5, self.view.frame.size.width-80, 30)];
    
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
    
    
    [seperate_view addSubview:label];
    seperate_view.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];

    [self.view addSubview:seperate_view];
}

-(UIButton*)CreateButton:(NSString*)str_title tag:(NSInteger)i_tag{
    UIButton *btn_title=[[UIButton alloc]initWithFrame:CGRectMake(i_tag*Width/3, 0, Width/3, 60)];
    [btn_title setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_title setTitle:str_title forState:UIControlStateNormal];
    btn_title.titleLabel.font=[UIFont systemFontOfSize:16];
    [btn_title setBackgroundColor:[UIColor clearColor]];
    btn_title.titleLabel.textAlignment=NSTextAlignmentCenter;
    //  [btn_title1 addTarget:self action:@selector(MoveToShenPi:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn_title;
}


-(UIImageView*)updateImage:(UIImageView*)view_menu num:(NSInteger)i_num {
    if (i_num!=0) {
        CATextLayer  *_badgeLayer = [[CATextLayer alloc] init];
        _badgeLayer.backgroundColor=[UIColor redColor].CGColor;
        _badgeLayer.foregroundColor = [UIColor blackColor].CGColor;
        _badgeLayer.alignmentMode = kCAAlignmentCenter;
        [_badgeLayer setFrame:CGRectMake(0, 0, 16, 16)];
        _badgeLayer.position=CGPointMake(view_menu.frame.size.width/2, view_menu.frame.size.height/2);
        _badgeLayer.wrapped = YES;
        _badgeLayer.cornerRadius = 8.0f;
        // [_badgeLayer setFontSize:16];
        // [_badgeLayer setString:@"4"];
        _badgeLayer.anchorPoint=CGPointZero;
        _badgeLayer.contentsScale = [[UIScreen mainScreen] scale];
        [view_menu.layer addSublayer:_badgeLayer];
    }
    return view_menu;
}

-(void)setupButtonMenu:(BOOL)b_num {
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [menuBtn addTarget:self action:@selector(showDropDownMenu:) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    if (b_num==YES) {
            CATextLayer  *_badgeLayer = [[CATextLayer alloc] init];
            _badgeLayer.backgroundColor=[UIColor redColor].CGColor;
            _badgeLayer.foregroundColor = [UIColor blackColor].CGColor;
            _badgeLayer.alignmentMode = kCAAlignmentCenter;
            [_badgeLayer setFrame:CGRectMake(0, 0, 6, 6)];
            _badgeLayer.position=CGPointMake(menuBtn.frame.size.width+5, 0);
            _badgeLayer.wrapped = YES;
            _badgeLayer.cornerRadius = 3.0f;
            // [_badgeLayer setFontSize:16];
            // [_badgeLayer setString:@"4"];
            _badgeLayer.anchorPoint=CGPointZero;
            _badgeLayer.contentsScale = [[UIScreen mainScreen] scale];
            [menuBtn.layer addSublayer:_badgeLayer];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
}

-(void)setupButtonView {
    UIView *seperatorline1=[[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3, 0, 1, 60)];
    seperatorline1.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    UIView *seperatorline2=[[UIView alloc]initWithFrame:CGRectMake(2*[UIScreen mainScreen].bounds.size.width/3, 0, 1, 60)];
    seperatorline2.backgroundColor=[UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];

    btn_title1=[self CreateButton:@"待办流程" tag:0];
    [btn_title1 addTarget:self action:@selector(PassNavToShenPi) forControlEvents:UIControlEventTouchUpInside];
    btn_title2 =[self CreateButton:@"公文传阅" tag:1];
    [btn_title2 addTarget:self action:@selector(PassNavToChuanYue) forControlEvents:UIControlEventTouchUpInside];
    btn_title3 = [self CreateButton:@"系统消息" tag:2];
    [btn_title3 addTarget:self action:@selector(PassNaveToMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_title1];
    [self.view addSubview:btn_title2];
    [self.view addSubview:btn_title3];
    [self.view addSubview:seperatorline1];
    [self.view addSubview:seperatorline2];
}

-(void)setupLocation {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] && f_v>=10.0) {
        INTULocationManager *mgr=[INTULocationManager sharedInstance];
        [mgr requestLocationWithDesiredAccuracy:INTULocationAccuracyCity timeout:20 block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
            NSLog(@"----%ld",(long)status);
            
            self.lati=currentLocation.coordinate.latitude;
            self.longi=currentLocation.coordinate.longitude;
            if (self.lati==0 && self.longi==0) {
                self.lati=34.774831;
                self.longi=113.681393;
            }
            
            if (status == 1) {
                //  [MBProgressHUD hideHUD];
                //  [MBProgressHUD showError:@"请求超时"];
                [indicator stopAnimating];
                return;
            }
            [self setupCity];
            
        }];
    }
    else {
        [indicator stopAnimating];
    }
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
       // __block NSString *str_ip=@"";
       // __block NSString *str_port=@"";
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
                
                [self addBubbleMenu];
                [self.view setNeedsDisplay];
                 
              //  [self setupButtonView];
              //  [indicator stopAnimating];
              //  NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0];
              //  [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
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
        //NSString *str_ip=@"";
        //NSString *str_port=@"";
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
                NSArray *arr_list=[JSON objectForKey:@"list"];
                for (int i=0; i<[arr_list count]; i++) {
                    NSDictionary *dic_arr=[arr_list objectAtIndex:i];
                    if (![_arr_NewsList containsObject:dic_arr]) {
                        [_arr_NewsList addObject:dic_arr];
                    }
                }
                
               // [_arr_NewsList addObjectsFromArray:arr_list];
                _news_count++;
                if (_news_count==2) {
                  //  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    _news_count=0;
                   // NSMutableArray *arr_tmp_NewsList=[[NSMutableArray alloc]initWithCapacity:[_arr_NewsList count]];
                    
                    NSSortDescriptor *sortDescriptor;
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                                 ascending:NO];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                    NSArray *sortedArray = [_arr_NewsList sortedArrayUsingDescriptors:sortDescriptors];
                    _arr_NewsList=(NSMutableArray*)sortedArray;
                    NSLog(@"排序");
                    //先不排序
                    /*
                    for (int i=0; i<[_arr_NewsList count]-1; i++) {
                        NSDictionary *dic_i=[_arr_NewsList objectAtIndex:i];
                        NSString *str_date_i=[dic_i objectForKey:@"startDate"];
                        NSDate *date_i=[self dateFromString:str_date_i];
                        for (int j=1; j<[_arr_NewsList count]; j++) {
                            NSDictionary *dic_j=[_arr_NewsList objectAtIndex:j];
                            NSString *str_date_j=[dic_j objectForKey:@"startDate"];
                            NSDate *date_j=[self dateFromString:str_date_j];
                            if (date_i>date_j) {
                                NSDictionary *dic_tmp=dic_i;
                                [_arr_NewsList setObject:dic_j atIndexedSubscript:i];
                                [_arr_NewsList setObject:dic_tmp atIndexedSubscript:j];
                            }
                        }
                    }
                    */
                    
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

- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.s"];
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    

    return destDate;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_arr_NewsList count]<10) {
         return 11;
    }
    else {
        return [_arr_NewsList count]+1;
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 0;
    }
    else {
        if ([_arr_NewsList count]==0) {
            return 110;
        }
        else  {
            
            
            CGFloat h_height=0;
           
            h_height=[self cellHeightForNews:indexPath.section-1];
            
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
       return 0;
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


-(CGFloat)cellHeightForNews:(NSInteger)i_index {
  //  @try {
        if (i_index<[_arr_NewsList count]) {
            NSDictionary *dic_content=[_arr_NewsList objectAtIndex:i_index];
             CGFloat h_Title;
            NSString *str_title=[_baseFunc GetValueFromDic:dic_content key:@"title"];
            NSString *str_category=[_baseFunc GetValueFromDic:dic_content key:@"classname"];
            if ([str_category rangeOfString:@"通知"].location!=NSNotFound) {
                h_Title=[UILabel getHeightByWidth:Width*0.92 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
            }
            else if ([str_category rangeOfString:@"新闻"].location!=NSNotFound) {
                h_Title=[UILabel getHeightByWidth:Width*0.6107 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
            }
            /*
            if (i_index<4) {
                if (iPad) {
                    h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                }
                else {
                    h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-80 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                }
            }
            else {
                if (iPad) {
                    h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                }
                else {
                    h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-30 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                }

            }
            */
           
            
            
            NSString *str_department = [dic_content objectForKey:@"operationDeptName"];
            NSString *str_date = [dic_content objectForKey:@"startDate"];
            NSArray *arr_date = [str_date componentsSeparatedByString:@" "];
            NSString *str_time = [arr_date objectAtIndex:0];
            str_department = [NSString stringWithFormat:@"%@  %@",str_department,str_time];
          //  CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:i_otherFont]];
            CGFloat h_depart=[UILabel getHeightByWidth:Width title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
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
            /*
            RemindCell *r_cell=[RemindCell cellWithTable:tableView DocNum:_i_doc_num FlowNum:_i_flow_num MsgNum:_i_msg_num];
            r_cell.delegate=self;
            r_cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return r_cell;
             */
            static NSString *identifier=@"Cell";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell==nil) {
                cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.textLabel.text=@"";
            }
            return cell;
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
                    NewsNewsTableViewCell *cell_news;
                    NewsInformTableViewCell *cell_infrom;
                    NSDictionary *dic_content=[_arr_NewsList objectAtIndex:indexPath.section-1];
                   // NSString *str_category=[dic_content objectForKey:@"classname"];
                    NSString *str_category=[_baseFunc GetValueFromDic:dic_content key:@"classname"];
                    
                    //  CGFloat h_category=[UILabel_LabelHeighndWidth getHeightByWidth:15*self.view.frame.size.width/16 title:str_category font:[UIFont systemFontOfSize:i_otherFont]];
                    NSString *str_title=[_baseFunc GetValueFromDic:dic_content key:@"title"];
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str_title];
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    [paragraphStyle setLineSpacing:5];
                    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str_title length])];
                    
                    
                    CGFloat h_Title = 0.0;
                    if ([str_category rangeOfString:@"通知"].location!=NSNotFound) {
                        h_Title=[UILabel getHeightByWidth:Width*0.92 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                    }
                    else if ([str_category rangeOfString:@"新闻"].location!=NSNotFound) {
                        h_Title=[UILabel getHeightByWidth:0.6107*Width title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                    }
                    /*
                    if (iPad) {
                        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-100 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                    }
                    else {
                        h_Title=[UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width-30 title:str_title font:[UIFont systemFontOfSize:i_titleFont]];
                    }
                    */
                    NSString *str_department =[_baseFunc GetValueFromDic:dic_content key:@"operationDeptName"];
                   // CGFloat w_depart=[UILabel_LabelHeightAndWidth getWidthWithTitle:[dic_content objectForKey:@"operatorName"] font:[UIFont systemFontOfSize:i_otherFont]];
                    CGFloat h_depart=[UILabel getHeightByWidth:Width title:str_department font:[UIFont systemFontOfSize:i_otherFont]];
                    NSString *str_time =[_baseFunc GetValueFromDic:dic_content key:@"startDate"];
                    NSArray *arr_time=[str_time componentsSeparatedByString:@" "];
                    NSString *str_time2=[arr_time objectAtIndex:0];
                    NSString *str_depart=[NSString stringWithFormat:@"%@ %@",str_department,str_time2];
                    //CGFloat h_height=h_Title+h_depart+30;
                    CGFloat h_height=[self cellHeightForNews:indexPath.section-1];
                    
                    NSObject *obj=[dic_content objectForKey:@"id"];
                    NSInteger i_index = 0;
                    if (obj!=nil) {
                        NSNumber *num_index=(NSNumber*)obj;
                        i_index=[num_index integerValue];
                    }
                    
                    NSString *str_imgsrc=[_baseFunc GetValueFromDic:dic_content key:@"imgsrc"];

                    
                    if ([str_category rangeOfString:@"通知"].location!=NSNotFound) {
                        cell_infrom=[NewsInformTableViewCell cellWithTable:tableView withCellHeight:h_height withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withCategory:str_category withDepart:str_depart withDate:str_time2 titleFont:i_titleFont otherFont:i_otherFont atIndexPath:indexPath];
                      //  cell_infrom.delegate=self;
                        cell_infrom.str_title=str_title;
                        cell_infrom.str_department=str_department;
                        cell_infrom.myTag=indexPath.section-1;
                        cell_infrom.selectionStyle=UITableViewCellSelectionStyleNone;
                        cell_infrom.tag = i_index;
                        cell_infrom.lbl_Title.textColor=[UIColor blackColor];
                        return cell_infrom;
                    }
                    else if ([str_category rangeOfString:@"新闻"].location!=NSNotFound) {
                        cell_news=[NewsNewsTableViewCell cellWithTable:tableView withCellHeight:h_height withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withCategory:str_category withDepart:str_depart withDate:str_time2 titleFont:i_titleFont otherFont:i_otherFont withImage:str_imgsrc atIndexPath:indexPath];
                       // cell_news.delegate=self;
                        cell_news.str_title=str_title;
                        cell_news.str_department=str_department;
                        
                        cell_news.myTag=indexPath.section-1;
                        cell_news.selectionStyle=UITableViewCellSelectionStyleNone;
                        cell_news.tag = i_index;
                        cell_news.lbl_Title.textColor=[UIColor blackColor];
                        return cell_news;
                    }
                    
                    /*
                    if (indexPath.section<4) {
                        cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:h_height withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withCategory:str_category withDepart:str_depart titleFont:i_titleFont otherFont:i_otherFont canScroll:NO withImage:@"hot.png"];
                    }
                    else {
                         cell=[NewsManagementTableViewCell cellWithTable:tableView withCellHeight:h_height withTitleHeight:h_Title withButtonHeight:h_depart withTitle:attributedString withCategory:str_category withDepart:str_depart titleFont:i_titleFont otherFont:i_otherFont canScroll:NO withImage:nil];
                    }
                     */
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
                    cell.tag=i_index;
                    
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

-(void)viewWillAppear:(BOOL)animated {
    
    if (bubbleMenuButton!=nil) {
        UIImageView *img_view=(UIImageView*)bubbleMenuButton.homeButtonView;
        img_view.image=[UIImage imageNamed:@"img_menu"];
        /*
        bubbleMenuButton.homeButtonView.badgeBgColor=[UIColor redColor];
        NSInteger i_total=_i_doc_num+_i_msg_num+_i_flow_num;
        [bubbleMenuButton.homeButtonView showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone x:-8 y:8];
        */
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==1) {
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
    else {
        [self.tableView reloadData];
        NewsNewsTableViewCell *cell_news=(NewsNewsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (cell_news!=nil) {
            cell_news.lbl_Title.textColor=[UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1];
        }
        else {
            NewsInformTableViewCell *cell_Inform=(NewsInformTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            if (cell_Inform!=nil) {
                cell_Inform.lbl_Title.textColor=[UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1];
            }
        }
        NSDictionary *dic_content=[_arr_NewsList objectAtIndex:indexPath.section-1];
        NSString *str_category=[_baseFunc GetValueFromDic:dic_content key:@"classname"];
        NSInteger i_index=0;
        NSString *str_label=@"";
        NSString *str_depart=@"";
        if ([str_category rangeOfString:@"通知"].location!=NSNotFound) {
            NewsInformTableViewCell *cell=(NewsInformTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            i_index=cell.tag;
            str_label=cell.str_title;
            str_depart=cell.str_department;
        }
        else if ([str_category rangeOfString:@"新闻"].location!=NSNotFound) {
            NewsNewsTableViewCell *cell=(NewsNewsTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            i_index=cell.tag;
            str_label=cell.str_title;
            str_depart=cell.str_department;
        }
        
        NewsDisplayViewController *news_controller=[[NewsDisplayViewController alloc]init];
        news_controller.news_index=i_index;
        news_controller.str_label=str_label;
        news_controller.str_depart=str_depart;
        news_controller.userInfo=_userInfo;
        news_controller.b_News=YES;
        selected_title=str_label;
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [self.navigationController pushViewController:news_controller animated:YES];
        
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
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
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
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void)PassNavToChuanYue {
     NSLog(@"单击事件");
    UnFinishViewController *vc=[[UnFinishViewController alloc]init];
    vc.str_title=@"公文传阅";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)PassNaveToMessage {
    NSLog(@"单击事件");
    SysMsgViewController *vc=[[SysMsgViewController alloc] init];
    vc.userInfo=_userInfo;
    vc.str_title=@"系统消息";
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:vc animated:YES];
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


-(void)setupCity {
    CLLocationDegrees lati = self.lati;
    CLLocationDegrees longi = self.longi;
    CLLocation *loc =[[CLLocation alloc]initWithLatitude:lati longitude:longi];
    
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            [indicator stopAnimating];
            NSLog(@"%@",error);
        }
        else {
            CLPlacemark *pm = [placemarks firstObject];
            
            NSLog(@"%@",pm.name);
            NSLog(@"%@ ,%@ ,%@",pm.locality,pm.country,pm.subLocality);
            
            if ([pm.name rangeOfString:@"市"].location != NSNotFound) {
                if ([pm.locality isEqualToString:@"上海市"] || [pm.locality isEqualToString:@"天津市"] || [pm.locality isEqualToString:@"北京市"] || [pm.locality isEqualToString:@"重庆市"]) {
                    NSRange range =[pm.locality rangeOfString:@"市"];
                    int loc= (int)range.location;
                    NSString *citystr =[pm.locality substringToIndex:loc];
                    
                    self.city= self.province = citystr;
                }
                else {
                    NSRange range= [pm.name rangeOfString:@"市"];
                    int loc = (int)range.location;
                    NSString *str= [pm.name substringToIndex:loc];
                    str = [str substringFromIndex:2];
                    
                    NSRange range1 = [str rangeOfString:@"省"];
                    int loc1 = (int)range1.location;
                    
                    if (range1.location != NSNotFound) {
                        NSLog(@"%@",str);
                        self.province = [str substringToIndex:loc1];
                        self.city = [str substringFromIndex:loc1+1];
                        
                        NSLog(@"%@,%@",[str substringToIndex:loc1],[str substringFromIndex:loc1]);
                    }
                    else if ([str isEqualToString:@"广西壮族自治区桂林"]) {
                        self.province=@"广西";
                        self.city=@"桂林";
                    }
                }
            }
            else {
                if ([pm.locality rangeOfString:@"市"].location != NSNotFound) {
                    NSLog(@"---%@",pm.locality);
                    NSRange range = [pm.locality rangeOfString:@"市"];
                    int loc = (int)range.location;
                    NSString *citystr = [pm.locality substringToIndex:loc];
                    self.city = self.province = citystr;
                    
                }
                else {
                    self.city = self.province = @"北京";
                }
            }
            
            [self requestNet:self.province city:self.city];
            
            [[NSUserDefaults standardUserDefaults]setObject:self.province forKey:@"省份"];
            [[NSUserDefaults standardUserDefaults]setObject:self.city forKey:@"城市"];
        }
    }];
}

#pragma mark 请求网络
-(void)requestNet:(NSString *)pro city:(NSString *)city
{
    if ([city isEqualToString:@"郑州"] || [city isEqualToString:@"开封"] || [city isEqualToString:@"洛阳"] || [city isEqualToString:@"平顶山"] || [city isEqualToString:@"安阳"] || [city isEqualToString:@"鹤壁"] || [city isEqualToString:@"新乡"] || [city isEqualToString:@"焦作"] || [city isEqualToString:@"濮阳"] || [city isEqualToString:@"许昌"] || [city isEqualToString:@"漯河"] || [city isEqualToString:@"三门峡"] || [city isEqualToString:@"商丘"] || [city isEqualToString:@"济源"] || [city isEqualToString:@"驻马店"] || [city isEqualToString:@"南阳"] || [city isEqualToString:@"信阳"] || [city isEqualToString:@"周口"]) {
        pro=@"河南";
    }
    NSString *urlstr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/weather/%@|%@.html",pro,city];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *mgr=[AFHTTPSessionManager manager];
    [mgr GET:urlstr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [indicator stopAnimating];
        
        if (responseObject!=nil) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                self.dt = responseObject[@"dt"];
                NSString *str = [NSString stringWithFormat:@"%@|%@",pro,city];
                // NSArray *dataArray = [WeatherData objectArrayWithKeyValuesArray:responseObject[str]];
                NSDictionary *dic=(NSDictionary*)responseObject;
                NSArray *dataArray_tmp= [dic objectForKey:str];
                
                NSDictionary *dic_tmp=[dataArray_tmp objectAtIndex:0];
                
                //pm2d5
                WeatherData *wd=[[WeatherData alloc]init];
                NSObject *i_temperature =[dic objectForKey:@"rt_temperature"];
                NSString *str_temperature=@"";
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber *num_temperature=(NSNumber*)i_temperature;
                str_temperature = [numberFormatter stringFromNumber:num_temperature];
                wd.temperature=[NSString stringWithFormat:@"%@%@",str_temperature,@"°C"];
                wd.climate=[dic_tmp objectForKey:@"climate"];
                
                NSLog(@"获取天气成功!");
                
                UIButton *btn_weather=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
                if ([wd.climate isEqualToString:@"雷阵雨"]) {
                    [btn_weather setImage:[UIImage imageNamed:@"thunder_w"] forState:UIControlStateNormal];
                }
                else if ([wd.climate isEqualToString:@"晴"]) {
                    [btn_weather setImage:[UIImage imageNamed:@"sun_w"] forState:UIControlStateNormal];
                }
                else if ([wd.climate isEqualToString:@"多云"]) {
                    [btn_weather setImage:[UIImage imageNamed:@"sunandcloud_w"] forState:UIControlStateNormal];
                }
                else if ([wd.climate isEqualToString:@"阴"]) {
                    [btn_weather setImage:[UIImage imageNamed:@"cloud_w"] forState:UIControlStateNormal];
                }
                else if ([wd.climate isEqualToString:@"雨"]) {
                    [btn_weather setImage:[UIImage imageNamed:@"rain_w"] forState:UIControlStateNormal];
                }
                else if ([wd.climate isEqualToString:@"雪"]) {
                    [btn_weather setImage:[UIImage imageNamed:@"snow_w"] forState:UIControlStateNormal];
                }
                else {
                    [btn_weather setImage:[UIImage imageNamed:@"sandfloat_w"] forState:UIControlStateNormal];
                }
                [btn_weather setTitle:wd.temperature forState:UIControlStateNormal];
                [btn_weather setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
                [btn_weather addTarget:self action:@selector(WeatherForcast:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_weather];
                self.navigationItem.rightBarButtonItem=barButtonItem;
            }
        }
        
        
       // UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(WeatherForcast:)];
        
        //UIBarButtonItem *barButtonItem=[UIBarButtonItem ItemWithTitleAndIcon:@"sun_w" title:wd.temperature target:self action:@selector(WeatherForcast:)];
       // barButtonItem.tintColor=[UIColor whiteColor];
       // barButtonItem.title=wd.temperature;
       // [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
        
        // WeatherData *wd =[WeatherData mj_objectWithKeyValues:dic[@"pm2d5"]];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [indicator stopAnimating];
    }];
}



-(void)WeatherForcast:(UIButton*)sender {
    WeatherViewController *vc=[[WeatherViewController alloc]init];
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController pushViewController:vc animated:NO];
}


-(void)dealloc {
    self.tableView.delegate=nil;
    self.tableView.dataSource=nil;
}

/** 获取菜单模型数组 */
- (NSArray *)getMenuModelsArray:(NSInteger)i_flow_num doc_num:(NSInteger)i_doc_num msg_num:(NSInteger)i_msg_num {
    __weak typeof(self) weakSelf = self;
    
  //  NSString *str_title0=[NSString stringWithFormat:@"%@   %ld",@"待办",(long)i_flow_num];
    //菜单模型0
    FFDropDownMenuModel *menuModel0 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"待办" menuItemCount:i_flow_num menuItemIconName:@"menu0"  menuBlock:^{
        NSLog(@"单击事件");
        MyShenPiViewController *viewController=[[MyShenPiViewController alloc] init];
        viewController.userInfo=_userInfo;
        viewController.delegate=self;
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [weakSelf.navigationController pushViewController:viewController animated:YES];

      //  FFMenuViewController *vc = [FFMenuViewController new];
      //  vc.backgroundImageName = @"menuBackground";
      //  vc.navigationItem.title = @"QQ";
      //  [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
   // NSString *str_title1=[NSString stringWithFormat:@"%@   %ld",@"传阅",(long)i_doc_num];
    //菜单模型1
    FFDropDownMenuModel *menuModel1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"传阅" menuItemCount:i_doc_num menuItemIconName:@"menu1" menuBlock:^{
        NSLog(@"单击事件");
        UnFinishViewController *vc=[[UnFinishViewController alloc]init];
        vc.str_title=@"公文传阅";
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
      //  FFMenuViewController *vc = [FFMenuViewController new];
      //  vc.backgroundImageName = @"menuBackground";
      //  vc.navigationItem.title = @"Line";
      //  [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
  //  NSString *str_title2=[NSString stringWithFormat:@"%@   %ld",@"传阅",(long)i_msg_num];
    //菜单模型2
    FFDropDownMenuModel *menuModel2 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"消息" menuItemCount:i_msg_num menuItemIconName:@"menu2" menuBlock:^{
        NSLog(@"单击事件");
        SysMsgViewController *vc=[[SysMsgViewController alloc] init];
        vc.userInfo=_userInfo;
        vc.str_title=@"系统消息";
        if (f_v<9.0) {
            self.navigationController.delegate=nil;
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
     //   FFMenuViewController *vc = [FFMenuViewController new];
     //   vc.backgroundImageName = @"menuBackground";
     //   vc.navigationItem.title = @"Twitter";
     //   [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    /*
    //菜单模型3
    FFDropDownMenuModel *menuModel3 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"QZone" menuItemIconName:@"menu3"  menuBlock:^{
    //    FFMenuViewController *vc = [FFMenuViewController new];
    //    vc.backgroundImageName = @"menuBackground";
    //    vc.navigationItem.title = @"QZone";
    //    [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    //菜单模型4
    FFDropDownMenuModel *menuModel4 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"WeChat" menuItemIconName:@"menu4"  menuBlock:^{
     //   FFMenuViewController *vc = [FFMenuViewController new];
     //   vc.backgroundImageName = @"menuBackground";
     //   vc.navigationItem.title = @"WeChat";
     //   [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    //菜单模型5
    FFDropDownMenuModel *menuModel5 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"Facebook" menuItemIconName:@"menu5"  menuBlock:^{
      //  FFMenuViewController *vc = [FFMenuViewController new];
      //  vc.backgroundImageName = @"menuBackground";
      //  vc.navigationItem.title = @"Facebook";
      //  [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    */
 //   NSArray *menuModelArr = @[menuModel0, menuModel1, menuModel2];
    NSArray *menuModelArr = @[menuModel0, menuModel2];
    return menuModelArr;
}

-(void)addBubbleMenu {
    CGFloat i_img_width = 40.0f;
    CGFloat i_offset_x = 8.0f;
    CGFloat i_offset_y = 8.0f;
    CGFloat button_offset_y=165.0f;
    if (iPhone6) {
        i_img_width = 45.0f;
        i_offset_x = 8.0f;
        i_offset_y = 8.0f;
        button_offset_y = 180.0f;
    }
    else if (iPhone6_plus) {
        i_img_width=50.0f;
        i_offset_x = 9.0f;
        i_offset_y = 9.0f;
        button_offset_y = 190.0f;
    }
    UIImageView *img_menu = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, i_img_width, i_img_width)];
    [img_menu setImage:[UIImage imageNamed:@"img_menu"]];
    
   
    if (bubbleMenuButton==nil) {
        bubbleMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(Width-80.0f, Height-button_offset_y, i_img_width, i_img_width) flow_num:_i_flow_num doc_num:_i_doc_num msg_num:_i_msg_num expansionDirection:DirectionUp];
        bubbleMenuButton.homeButtonView = img_menu;
        
        
        
        NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
        btn_title1 = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, i_img_width-5, i_img_width-5)];
        [btn_title1 setBackgroundImage:[UIImage imageNamed:@"img_menu1"] forState:UIControlStateNormal];
        [btn_title1 addTarget:self action:@selector(PassNavToShenPi) forControlEvents:UIControlEventTouchUpInside];
        
        
        btn_title2 = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, i_img_width-5, i_img_width-5)];
        [btn_title2 setBackgroundImage:[UIImage imageNamed:@"img_menu2"] forState:UIControlStateNormal];
        [btn_title2 addTarget:self action:@selector(PassNavToChuanYue) forControlEvents:UIControlEventTouchUpInside];
        
        
        btn_title3 = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, i_img_width-5, i_img_width-5)];
        [btn_title3 setBackgroundImage:[UIImage imageNamed:@"img_menu3"] forState:UIControlStateNormal];
        [btn_title3 addTarget:self action:@selector(PassNaveToMessage) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:btn_title1];
      //  [buttonsMutable addObject:btn_title2];
        [buttonsMutable addObject:btn_title3];
        
        [bubbleMenuButton addButtons:buttonsMutable];
        
        [self.view addSubview:bubbleMenuButton];
    }
    else {
        bubbleMenuButton.i_flow_num=_i_flow_num;
        bubbleMenuButton.i_doc_num=_i_doc_num;
        bubbleMenuButton.i_msg_num=_i_msg_num;
        NSInteger i_total=_i_flow_num+_i_msg_num+_i_doc_num;
        bubbleMenuButton.homeButtonView.badgeBgColor=[UIColor redColor];
        [bubbleMenuButton.homeButtonView showBadgeWithStyle:WBadgeStyleNumber value:i_total animationType:WBadgeAnimTypeNone x:-i_offset_x y:i_offset_y];
    }
   
    
}


//推送消息快速响应
-(void)PushNotification:(UIButton*)sender {
    NSLog(@"单击事件");
    PushMsgVC *vc=[[PushMsgVC alloc] init];
    vc.userInfo=_userInfo;
    vc.str_title=@"系统消息";
    NSArray *Usr_Push_Msg=[[NSUserDefaults standardUserDefaults] objectForKey:@"push_notification"];
    vc.i_rownum=[Usr_Push_Msg count];
    vc.arr_PushMsg=Usr_Push_Msg;
    vc.delegate=self;
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GetNotification"];
    [self.navigationController pushViewController:vc animated:YES];

}

//从推送服务器获取消息
-(void)GetPushNotification:(NSMutableDictionary*)param {
    NSMutableArray *t_array=[db fetchPushIPAddress];
    NSString *str_push_ip;
    NSString *str_push_port;
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_push_ip=[arr_ip objectAtIndex:0];
        str_push_port=@"8083";
    }
    NSString *str_id=[NSString stringWithFormat:@"%@",_userInfo.str_empid];
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@%@",@"http://",str_push_ip,str_push_port,@"/api/admin/get/userMsg.json?userId=",str_id];
    
    [_session POST:str_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取用户推送信息成功");
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *str_success= [JSON objectForKey:@"success"];
        BOOL b_success=[str_success boolValue];
        if (b_success==YES) {
            NSArray *arr_list=[JSON objectForKey:@"data"];
            NSMutableArray *arr_mute_tmp=[[NSMutableArray alloc]init];
            for (int i=0; i<[arr_list count]; i++) {
                NSObject *o_tmp=[arr_list objectAtIndex:i];
                if (o_tmp!=[NSNull null]) {
                    NSString *str_tmp=(NSString*)o_tmp;
                    NSArray *arr_tmp=[str_tmp componentsSeparatedByString:@"||"];
                    if ([arr_tmp count]==2) {
                        [arr_mute_tmp addObject:str_tmp];
                    }
                }
            }
            if ([arr_mute_tmp count]>0) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                for (int i=0; i<[arr_mute_tmp count]-1; i++) {
                    for (int j=0; j<[arr_mute_tmp count]-i-1; j++) {
                        NSString *str_tmp0=[arr_mute_tmp objectAtIndex:j];
                        NSString *str_time0=(NSString*)[[str_tmp0 componentsSeparatedByString:@"||"] objectAtIndex:1];
                        NSDate *date0 = [dateFormatter dateFromString:str_time0];
                        NSString *str_tmp1=[arr_mute_tmp objectAtIndex:j+1];
                        NSString *str_time1=(NSString*)[[str_tmp1 componentsSeparatedByString:@"||"] objectAtIndex:1];
                        NSDate *date1 = [dateFormatter dateFromString:str_time1];
                        if (date0<date1) {
                            NSString *str_tmp=str_tmp0;
                            [arr_mute_tmp setObject:str_tmp1 atIndexedSubscript:j];
                            [arr_mute_tmp setObject:str_tmp atIndexedSubscript:j+1];
                        }
                    }
                }
                NSArray *Usr_Push_Msg=[NSArray arrayWithArray:arr_mute_tmp];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:Usr_Push_Msg forKey:@"push_notification"];
                [defaults synchronize];
                //记录到数据库中
                arr_Push_Msg=arr_mute_tmp;
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)XSpotLightClicked:(NSInteger)index {
    
}

-(void)RefreshBtnBadge {
    UIButton *btn_notification=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
    // [btn_notification setTitle:@"推送" forState:UIControlStateNormal];
    [btn_notification setImage:[UIImage imageNamed:@"push_notification"] forState:UIControlStateNormal];
    [btn_notification setImage:[UIImage imageNamed:@"push_notification1"] forState:UIControlStateSelected];
    [btn_notification setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 45)];
    [btn_notification addTarget:self action:@selector(PushNotification:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_notification];
    btn_notification.selected=NO;
    self.navigationItem.leftBarButtonItem=barButtonItem;
    [self.view setNeedsDisplay];

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
