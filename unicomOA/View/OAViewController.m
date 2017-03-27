//
//  OAViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "OAViewController.h"
#import "NTButton.h"
#import "MessageViewController.h"
#import "FunctionViewController.h"
#import "SettingViewController.h"
#import "BaseNavigationViewController.h"
#import "ContactViewControllerNew.h"
#import "UITabBar+badge.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"
#import "GCDAsyncSocket.h"
#import "MessageDataPacketTool.h"

#import "OANavigationController.h"

@interface OAViewController ()<GCDAsyncSocketDelegate>
{
    NTButton * _previousBtn;//记录前一次选中的按钮
    DataBase *db;
    
}

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property(nonatomic,strong)GCDAsyncSocket *socket;


/** host  */
@property(nonatomic,copy)NSString *host;
/** port  */
@property(nonatomic,assign)int port;
/**  发送心跳的计时器 */
@property(nonatomic,strong)NSTimer *timer;
/**  一条消息接收到的次数（半包处理） */
@property(nonatomic,assign)int recieveNum;
/**  接收到消息的body Data */
@property(nonatomic,strong)NSMutableData *messageBodyData;
/** 绑定的用户id  */
@property(nonatomic,copy)NSString *userId;
/** 连接次数  */
@property(nonatomic,assign)int connectNum;
@end

@implementation OAViewController {
    UIActivityIndicatorView *indicator;
    FunctionViewController *func;
    MessageViewController *message;
}

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor grayColor];
        self.title = @"视图";
        // Custom initialization
    }
    return self;
}
*/

- (NSMutableArray *)messages{
    if (_messages == nil) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    indicator=[self AddLoop];
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    [_session.requestSerializer setTimeoutInterval:10.0f];
    
    NSMutableDictionary *dic_param1=[NSMutableDictionary dictionary];
    dic_param1[@"pageIndex"]=@"1";
    [self PrePareData:dic_param1 interface:@"UnFinishTaskShenPiList"];
    [self AddressList];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [self UpdateFlowTable];
    }
    //UserInfo *userInfo=[self CreateUserInfo];
    /*
       */
    // Do any additional setup after loading the view.

    //self.view.backgroundColor=[UIColor colorWithRed:70/255.0f green:156/255.0f blue:241/255.0f alpha:1];
    //[self.tabBar addSubview:_tabBarView];
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    UserInfo *userInfo=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    message=[[MessageViewController alloc]init];
    message.delegate=self;
    message.userInfo=userInfo;
    
    self.userId=userInfo.str_empid;
    [self connectToHost];
    //  [self BindUser];
    //    UINavigationController *navi1=[[UINavigationController alloc]initWithRootViewController:message];
    OANavigationController *messageNav = [[OANavigationController alloc]initWithRootViewController:message];
    
    // ContactViewController *contact=[[ContactViewController alloc]init];
    ContactViewControllerNew *contact=[[ContactViewControllerNew alloc]init];
    contact.userInfo=userInfo;
    //    UINavigationController *navi2=[[UINavigationController alloc]initWithRootViewController:contact];
    OANavigationController *contactNav = [[OANavigationController alloc]initWithRootViewController:contact];
    
    func=[[FunctionViewController alloc]init];
    func.userInfo=userInfo;
    //    UINavigationController *navi3=[[UINavigationController alloc]initWithRootViewController:func];
    OANavigationController *funcNav = [[OANavigationController alloc]initWithRootViewController:func];
    
    SettingViewController *setting=[[SettingViewController alloc]init];
    setting.userInfo=userInfo;
    //    UINavigationController *navi4=[[UINavigationController alloc]initWithRootViewController:setting];
    OANavigationController *settingNav = [[OANavigationController alloc]initWithRootViewController:setting];
    
    self.viewControllers=[NSArray arrayWithObjects:messageNav,contactNav,funcNav,settingNav, nil];
    /*
    if (!iPad) {
        [self creatButtonWithNormalName:@"message.png" andSelectName:@"message_selected.png" andTitle:@"" andIndex:0];
        [self creatButtonWithNormalName:@"contact.png" andSelectName:@"contact_selected.png" andTitle:@"" andIndex:1];
        [self creatButtonWithNormalName:@"appcenter.png" andSelectName:@"appcenter_selected.png" andTitle:@"" andIndex:2];
        [self creatButtonWithNormalName:@"user.png" andSelectName:@"user_selected.png" andTitle:@"" andIndex:3];

    }
     */
 //   else {
       
        self.tabBar.itemPositioning=UITabBarItemPositioningFill;
        
        UITabBarItem *item1=[self.tabBar.items objectAtIndex:0];
        item1.image=[UIImage imageNamed:@"message.png"];
        item1.selectedImage=[UIImage imageNamed:@"message_selected.png"];
        item1.title=@"消息";
        
        UITabBarItem *item2=[self.tabBar.items objectAtIndex:1];
        item2.image=[UIImage imageNamed:@"contact.png"];
        item2.selectedImage=[UIImage imageNamed:@"contact_selected.png"];
        item2.title=@"通讯录";
        
        UITabBarItem *item3=[self.tabBar.items objectAtIndex:2];
        item3.image=[UIImage imageNamed:@"appcenter.png"];
        item3.selectedImage=[UIImage imageNamed:@"appcenter_selected.png"];
        item3.title=@"应用";

        UITabBarItem *item4=[self.tabBar.items objectAtIndex:3];
        item4.image=[UIImage imageNamed:@"user.png"];
        item4.selectedImage=[UIImage imageNamed:@"user_selected.png"];
        item4.title=@"我";
        
      

        
        
        

 //   }
    
    
    /*
    for (int i=0;i<4;i++) {
        UITabBarItem *item=[self.tabBar.items objectAtIndex:i];
        item.title=@"";
    }
    */
    
    // NTButton *button=_tabBarView.subviews[0];
    NTButton *button=self.tabBar.subviews[0];
    [self changeViewController:button];
    
    

   
   // item.badgeValue=@"2";
   // [self.tabBar.items objectAtIndex:2].badgeValue=@"1";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 创建一个按钮

- (void)creatButtonWithNormalName:(NSString *)normal andSelectName:(NSString *)selected andTitle:(NSString *)title andIndex:(int)index{
    
    NTButton * customButton = [NTButton buttonWithType:UIButtonTypeCustom];
    customButton.tag = index;
    
    CGFloat buttonW = self.tabBar.frame.size.width/4;
    CGFloat buttonH = self.tabBar.frame.size.height;
    
    customButton.frame=CGRectMake(buttonW*index, 0, buttonW, buttonH);
    /*
    if (iPhone5_5s || iPhone4_4s) {
        customButton.frame = CGRectMake(80 * index, 0, buttonW, buttonH);
    }
    else if (iPhone6) {
        customButton.frame = CGRectMake(90 * index, 0, buttonW, buttonH);
    }
    else if (iPhone6_plus) {
        customButton.frame = CGRectMake(100 * index, 0, buttonW, buttonH);
    }
    */
    [customButton setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    //[customButton setImage:[UIImage imageNamed:selected] forState:UIControlStateDisabled];
    //这里应该设置选中状态的图片。wsq
    [customButton setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    [customButton addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
    
    customButton.imageView.contentMode = UIViewContentModeCenter;
    customButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    customButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [customButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
   // [_tabBarView addSubview:customButton];
    [self.tabBar addSubview:customButton];
    
    
    if(index == 0)//设置第一个选择项。（默认选择项） wsq
    {
        _previousBtn = customButton;
        _previousBtn.selected = YES;
    }
    
}


#pragma mark 按钮被点击时调用
- (void)changeViewController:(NTButton *)sender
{
    if(self.selectedIndex != sender.tag){ //wsq®
        self.selectedIndex = sender.tag; //切换不同控制器的界面
        _previousBtn.selected = ! _previousBtn.selected;
        _previousBtn = sender;
        _previousBtn.selected = YES;
    }
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
        __block NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                [indicator stopAnimating];
                NSLog(@"获取审批列表成功");
                __block NSString *str_totalPage=[JSON objectForKey:@"totalPage"];
                NSInteger i_totalPage=[str_totalPage integerValue];
                if (i_totalPage>0) {
                    [self.tabBar showBadgeOnItemIndex:2];
                    func.str_page=str_totalPage;
                    [self.view setNeedsDisplay];
                    
                }
                        // [self.tableView reloadData];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            //停止刷新
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


//首次登陆准备通讯录数据
//首次连接获取通讯录
-(void)AddressList {
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
        NSString *str_addresslist=[db fetchInterface:@"AddressList"];
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_addresslist];
        [_session POST:str_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            int i_success=[str_success intValue];
            if (i_success==1) {
                NSLog(@"获取通讯录列表成功:%@",responseObject);
                [indicator stopAnimating];
               // [_refreshControl endRefreshing];
                NSMutableArray *staffArray=[JSON objectForKey:@"empList"];
                NSMutableArray *departArray=[JSON objectForKey:@"orgList"];
                
                [db InserStaffTable:staffArray];
                [db InserDepartMentTable:departArray];
                
                //  DataSource *dt_tmp=[[DataSource alloc]init];
                //  _dataArray=[dt_tmp addRealData:staffArray departArray:departArray];
                //  [self reloadDataForDisplayArray];
                
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
       // [_refreshControl endRefreshing];
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    
}

//每次更新系统后更新流程数据表
-(void)UpdateFlowTable {
    NSString *str_connection=[self GetConnectionStatus];
    if ([str_connection isEqualToString:@"wifi"] || [str_connection isEqualToString:@"GPRS"]){
        NSString *str_ip=@"";
        NSString *str_port=@"";
        NSMutableArray *t_array=[db fetchIPAddress];
        if (t_array.count==1) {
            NSArray *arr_ip=[t_array objectAtIndex:0];
            str_ip=[arr_ip objectAtIndex:0];
            str_port=[arr_ip objectAtIndex:1];
        }
        NSString *str_flowupdate_url=@"/default/mobile/oa/com.hnsi.erp.mobile.oa.TaskAuditSearch.countAllFlow.biz.ext";
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_flowupdate_url];
        [_session POST:str_url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"获取流程列表成功");
            NSMutableArray *flowArray=[JSON objectForKey:@"Process"];
            if (flowArray!=nil && flowArray.count>0) {
                 [db UpdateShiWuTable:flowArray];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
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

-(NSString*)GetConnectionStatus {
    NSString *currentNetWorkState=[[NSUserDefaults standardUserDefaults] objectForKey:@"connection"];
    return currentNetWorkState;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    /*
    //如果点击清除缓存后
    if ([item.title isEqualToString:@"消息"]) {
        [self RefreshTableFilesDetail:0];
    }
    else if ([item.title isEqualToString:@"应用"]) {
        [self RefreshTableFilesDetail:2];
    }
     */
}

- (void)connectToHost{
    // 获取分配的 主机ip 和 端口号
    NSMutableArray *t_array=[db fetchPushIPAddress];
    NSString *str_ip;
    NSString *str_port;
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@",@"http://",str_ip,str_port];
    AFHTTPSessionManager *mng = [AFHTTPSessionManager manager];
    mng.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];
    [mng.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    mng.requestSerializer= [AFHTTPRequestSerializer serializer];
    mng.responseSerializer= [AFHTTPResponseSerializer serializer];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    [mng.requestSerializer setValue:currentVersion forHTTPHeaderField:@"version"];
    [mng GET:str_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"responseObject-----%@",responseObject);
        NSString *responseObjectStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"--%@",responseObjectStr);
        if (responseObjectStr.length < 3) {
            return ;
        }
        NSArray *hostArr = [responseObjectStr componentsSeparatedByString:@":"];
        NSString *host = hostArr[0];
        self.host = host;
        int port = [hostArr[1] intValue];
        self.port = port;
        NSLog(@"%@---%d",host,port);
        
        // 创建一个Socket对象
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        // 连接
        NSError *error = nil;
        BOOL b_connect = [_socket connectToHost:host onPort:port error:&error];
        if (b_connect==YES) {
         //   [self BindUser];
        }
        
        NSLog(@"连接服务器");
       // [self.messages addObject:@"socketConnectToHost"];
       // [self messageTableViewReloadData]
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error-----%@",error);
    }];
    
}

#pragma mark -GCDAsyncSocketDelegate
// 连接主机成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"连接主机成功");
    self.title = @"连接成功";
    [self.messages addObject:@"socketDidConnectToHost"];
    [self messageTableViewReloadData];
    if (![MessageDataPacketTool isFastConnect]) {
      //  [self.messages addObject:@"发送握手数据"];
        NSLog(@"发送握手数据");
        [self messageTableViewReloadData];
        [sock writeData:[MessageDataPacketTool handshakeMessagePacketData] withTimeout:-1 tag:222];
        return;
    }
    
    //[self.messages addObject:@"发送快速重连数据"];
    NSLog(@"发送快速重连数据");
    [self messageTableViewReloadData];
    [sock writeData:[MessageDataPacketTool fastConnect] withTimeout:-1 tag:222];
    
}
- (void) messageTableViewReloadData{
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messageTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
        [self.messageTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
     */
}

// 与主机断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    if(err){
        NSLog(@"断开连接 %@",err);
        self.title = @"连接错误";
        _connectNum ++;
        if (_connectNum < MPMaxConnectTimes) {
            sleep(_connectNum+2);
            NSError *error = nil;
            [_socket connectToHost:self.host onPort:self.port error:&error];
        }
    } else{
        self.title = @"断开连接";
    }
    [self.messages addObject:@"socketDidDisconnect"];
    [self messageTableViewReloadData];
}

// 数据成功发送到服务器
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"数据成功发送到服务器");
    //数据发送成功后，自己调用一下读取数据的方法，接着_socket才会调用下面的代理方法
    [_socket readDataWithTimeout:-1 tag:tag];
}

// 读取到数据时调用
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    //心跳
    if (data.length == 1) {
        return ;
    }
    
    // 半包处理
    int length = 0;
    if (_recieveNum < 1) {
        
        NSData *lengthData = [data subdataWithRange:NSMakeRange(0, 4)];
        [lengthData getBytes: &length length: sizeof(length)];
        NTOHL(length);
    }
    
    if (length > data.length - 13) {
        _recieveNum ++ ;
        [self.messageBodyData appendData:data];
        length = 0;
        return;
    }
    
    [self.messageBodyData appendData:data];
    
    length = 0;
    _recieveNum = 0;
    
    IP_PACKET packet ;
    if (self.messageBodyData == nil) {
        //读取到的数据
        packet = [MessageDataPacketTool handShakeSuccessResponesWithData:data];
    } else {
        packet = [MessageDataPacketTool handShakeSuccessResponesWithData:self.messageBodyData];
    }
    self.messageBodyData = nil;
    
    //解密以前的body
    NSData *body_data = [NSData dataWithBytes:packet.body length:packet.length];
    NSLog(@"bodyData--%@--%d",body_data,packet.length);
    switch (packet.cmd) {
            
        case MpushMessageBodyCMDHandShakeSuccess:
            NSLog(@"握手成功");
            
            [self.messages addObject:@"握手成功"];
            [self messageTableViewReloadData];
            [self processHandShakeDataWithPacket:packet andData:body_data];
            [self BindUser];
            break;
            
        case MpushMessageBodyCMDLogin: //登录
            
            break;
            
        case MpushMessageBodyCMDLogout: //退出
            
            break;
        case MpushMessageBodyCMDBind: //绑定
            
            break;
        case MpushMessageBodyCMDUnbind: //解绑
            
            break;
        case MpushMessageBodyCMDFastConnect: //快速重连
            
            NSLog(@"MpushMessageBodyCMDUNFastConnect");
            NSLog(@"快速重连成功");
            [self.messages addObject:@"快速重连成功"];
            [self messageTableViewReloadData];
            [self BindUser];
            break;
            
        case MpushMessageBodyCMDStop: //暂停
            
            break;
        case MpushMessageBodyCMDResume: //重新开始
            
            break;
        case MpushMessageBodyCMDError: //错误
            [MessageDataPacketTool errorWithBody:body_data];
            break;
        case MpushMessageBodyCMDOk: //ok
            //                        [MessageDataPacketTool okWithBody:body_data];
            [self.messages addObject:@"操作成功!"];
            [self messageTableViewReloadData];
            break;
            
        case MpushMessageBodyCMDHttp: // http代理
        {
            NSLog(@"ok======聊天=========");
            [self.messages addObject:@"成功调用http代理"];
            [self messageTableViewReloadData];
            NSData *bodyData = [MessageDataPacketTool processFlagWithPacket:packet andBodyData:body_data];
            HTTP_RESPONES_BODY responesBody = [MessageDataPacketTool chatDataSuccessWithData:bodyData];
            NSLog(@"--%d",responesBody.statusCode);
        }
            break;
        case MpushMessageBodyCMDPush:  //收到的push消息
            [self processRecievePushMessageWithPacket:packet andData:body_data];
            
            break;
            
        case MpushMessageBodyCMDChat: //聊天
            break;
            
        default:
            break;
    }
    
    [sock readDataWithTimeout:-1 tag:tag];//持续接收服务端放回的数据
}
/**
 *  心跳
 */
- (void)heartbeatSend{
    
    [_socket writeData:[MessageDataPacketTool heartbeatPacketData] withTimeout:-1 tag:123];
}

/**
 *  处理收到的消息
 *
 *  @param packet    协议包
 *  @param body_data 协议包body data
 */
- (void)processRecievePushMessageWithPacket:(IP_PACKET)packet andData:(NSData *)body_data{
    id content = [MessageDataPacketTool processRecievePushMessageWithPacket:packet andData:body_data];
    if (content!=nil) {
        NSString *contentJsonStr = content[@"content"];
        
        NSDictionary *contentDict = [self dictionaryWithJsonString:contentJsonStr];
        NSString *contentStr = @"";
        if (contentDict==nil) {
            contentStr = contentJsonStr;
        }
        else {
            contentStr = contentDict[@"content"];
            
        }
        
        
        [self.messages addObject:[NSString stringWithFormat:@"收到push消息--%@",contentStr]];
        [self messageTableViewReloadData];
    }
    
    //  NSLog(@"content--%@",contentDict);
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *  处理心跳响应的数据
 *
 *  @param bodyData 握手ok的bodyData
 */
- (void) processHeartDataWithData:(NSData *)bodyData{
    NSLog(@"接收到心跳");
}

/**
 *  处理握手ok响应的数据
 *
 *  @param bodyData 握手ok的bodyData
 */
- (void) processHandShakeDataWithPacket:(IP_PACKET)packet andData:(NSData *)body_data{
    
    HAND_SUCCESS_BODY handSuccessBody = [MessageDataPacketTool HandSuccessBodyDataWithData:body_data andPacket:packet];
    
    //添加计时器
    _timer = [NSTimer timerWithTimeInterval:handSuccessBody.heartbeat/1000.0 target:self selector:@selector(heartbeatSend) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
}

-(void)BindUser {
    //[self.messages addObject:@"绑定用户..."];
    NSLog(@"绑定用户...");
    [self messageTableViewReloadData];
    //绑定用户
    NSString *str_id=[NSString stringWithFormat:@"%@",self.userId];
    NSLog(@"%@%@",@"userId:",str_id);
    [_socket writeData:[MessageDataPacketTool bindDataWithUserId:str_id andIsUnbindFlag:NO] withTimeout:-1 tag:222];
}

//解绑用户
- (void)unBindUser {
    if (self.userId) {
        //[self.messages addObject:@"解绑用户"];
        NSLog(@"解绑用户");
        [self messageTableViewReloadData];
        //绑定用户
        NSString *str_id=[NSString stringWithFormat:@"%@",self.userId];
        NSLog(@"%@%@",@"userId:",str_id);
        [self.socket writeData:[MessageDataPacketTool bindDataWithUserId:str_id andIsUnbindFlag:YES] withTimeout:-1 tag:222];
        self.userId = nil;
    }
}

//断开连接
-(void)disconnect {
    [self.socket disconnect];
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
