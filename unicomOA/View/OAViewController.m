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



@interface OAViewController () {
    NTButton * _previousBtn;//记录前一次选中的按钮
    DataBase *db;
    
}

@property (nonatomic,strong) AFHTTPSessionManager *session;

@end

@implementation OAViewController {
    UIActivityIndicatorView *indicator;
    FunctionViewController *func;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    //wsq
    for (UIView* obj in self.tabBar.subviews) {
        if (obj != _tabBarView) {//_tabBarView 应该单独封装。
            [obj removeFromSuperview];
        }
        //        if ([obj isKindOfClass:[]]) {
        //
        //        }
    }
     */
}


-(UserInfo*)CreateUserInfo {
    UserInfo *userInfo=[[UserInfo alloc]init];
    userInfo.str_name=@"张三";
    userInfo.str_username=@"张三";
    userInfo.str_gender=@"男";
    userInfo.str_department=@"综合部";
    userInfo.str_position=@"部门经理";
    userInfo.str_cellphone=@"13812345678";
    userInfo.str_email=@"未绑定";
    userInfo.str_phonenum=@"未填写";
    userInfo.str_Logo=@"headLogo.png";
    
    return userInfo;

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
    
    //UserInfo *userInfo=[self CreateUserInfo];
    /*
       */
    // Do any additional setup after loading the view.

    //self.view.backgroundColor=[UIColor colorWithRed:70/255.0f green:156/255.0f blue:241/255.0f alpha:1];
    //[self.tabBar addSubview:_tabBarView];
    NSData *data=[[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    UserInfo *userInfo=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    MessageViewController *message=[[MessageViewController alloc]init];
    message.delegate=self;
    message.userInfo=userInfo;
    
    UINavigationController *navi1=[[UINavigationController alloc]initWithRootViewController:message];
    
   // ContactViewController *contact=[[ContactViewController alloc]init];
    ContactViewControllerNew *contact=[[ContactViewControllerNew alloc]init];
    contact.userInfo=userInfo;
    UINavigationController *navi2=[[UINavigationController alloc]initWithRootViewController:contact];
    
    func=[[FunctionViewController alloc]init];
    func.userInfo=userInfo;
    UINavigationController *navi3=[[UINavigationController alloc]initWithRootViewController:func];
    
    SettingViewController *setting=[[SettingViewController alloc]init];
    setting.userInfo=userInfo;
    UINavigationController *navi4=[[UINavigationController alloc]initWithRootViewController:setting];
    
    self.viewControllers=[NSArray arrayWithObjects:navi1,navi2,navi3,navi4, nil];
    
    [self creatButtonWithNormalName:@"message.png" andSelectName:@"message_selected.png" andTitle:@"" andIndex:0];
    [self creatButtonWithNormalName:@"contact.png" andSelectName:@"contact_selected" andTitle:@"" andIndex:1];
    [self creatButtonWithNormalName:@"appcenter.png" andSelectName:@"appcenter_selected.png" andTitle:@"" andIndex:2];
    [self creatButtonWithNormalName:@"user.png" andSelectName:@"user_selected.png" andTitle:@"" andIndex:3];
    
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
        NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_urldata];
        [_session POST:str_url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str_success= [JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
                [indicator stopAnimating];
                NSLog(@"获取审批列表成功");
                NSString *str_totalPage=[JSON objectForKey:@"totalPage"];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
