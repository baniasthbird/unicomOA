//
//  LoginViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/14.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "LoginViewController.h"
#import "SignInViewController.h"
#import "forgetPasswordViewController.h"
#import "OAViewController.h"
#import "ServerIPViewController.h"
#import "UserInfo.h"
#import "AFHTTPSessionManager.h"
#import "LXAlertView.h"
#import "DataBase.h"
#import "AFNetworkReachabilityManager.h"
#import "settingPasswordViewController.h"
#import "YBMonitorNetWorkState.h"



@interface LoginViewController()<UITextFieldDelegate,YBMonitorNetWorkStateDelegate,ServerIPViewControllerDelegate>
{
    UIImageView *View;
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
    UIButton *checkbox;
    UIButton *btn_login;
}



@property(copy,nonatomic) NSString * accountNumber;
@property(copy,nonatomic) NSString *mmmm;
@property(copy,nonatomic) NSString *str_user;
//连接
@property (nonatomic,strong) AFHTTPSessionManager *session;

//是否可连接
@property (nonatomic,strong) AFNetworkReachabilityManager *reach_manager;
//POST参数
@property (nonatomic,strong) NSMutableDictionary *params;

@property (nonatomic,strong) UIButton *btn_forgetpassword;

@property (nonatomic,strong) UIButton *btn_Server;

@property BOOL i_Success;



@end



@implementation LoginViewController {
    DataBase *db;
    NSString *str_reachable;
    
    UIActivityIndicatorView *indicator;
    
    UILabel *lbl_ip;
    
    BOOL b_rememberPwd;
}

static NSString *kServerSessionCookie=@"JSESSIONID";
static NSString *kLocalCookieName=@"UnicomOACookie";
static NSString *kLocalUserData=@"UnicomOALocalUser";
static NSString *kBaseUrl=@"http://192.168.12.151:8080/default/mobile/user/com.hnsi.erp.mobile.user.LoginManager.login.biz.ext";

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    NSUserDefaults *account = [NSUserDefaults standardUserDefaults];
    NSString *str_usrname= [account objectForKey:@"name"];
    NSString *str_password= [account objectForKey:@"password"];
    if (str_usrname==nil && str_password==nil) {
        user.text=@"";
        pwd.text=@"";
        checkbox.selected=NO;
        b_rememberPwd=NO;
    }
    else if (![str_usrname isEqualToString:@""] && ![str_password isEqualToString:@""]) {
        pwd.text=str_password;
        user.text=str_usrname;
        checkbox.selected=YES;
        b_rememberPwd=YES;
    }
}
 
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_b_update==YES) {
        NSString *str_msg1=@"有新版本，是否下载？\n";
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str_msg1 cancelBtnTitle:@"稍后下载" otherBtnTitle:@"立即下载" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex==0) {
                //稍后下载
                
            }
            else {
                //立即下载
                NSString *DownLoadLink;
                DownLoadLink = @"https://app.hnsi.cn/hnti_soa/";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DownLoadLink]];
                exit(0);

            }
        }];
        [alert showLXAlertView];

    }
    
    [self.navigationItem setHidesBackButton:YES];
    //设置NavigationBar的背景色
    View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if (iPad) {
      //  View.contentMode=UIViewContentModeScaleAspectFit;
        View.image=[UIImage imageNamed:@"LoginView-IPad.png"];
    }
    else {
        View.image=[UIImage imageNamed:@"LoginView.png"];
    }
    View.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:View];
    
  //  NSString *bundleid=[ [NSBundle mainBundle] bundleIdentifier];
    _i_Success=NO;
    
    //_reach_manager=[AFNetworkReachabilityManager managerForAddress:<#(nonnull const void *)#>];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    _params=[NSMutableDictionary dictionary];
   // _params[@"username"]=@"sysadmin";
   // _params[@"password"]=@"000000";
   
    
    [self createLabels];
    [self createButtons];
    [self createTextFields];
    [self CreateCheckBox];
    [self InitDataBase];
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];

    db=[DataBase sharedinstanceDB];
    
    NSMutableArray *arr_ip= [db fetchIPAddress];
    NSString *str_ip_label=@"";
    if (arr_ip!=nil && [arr_ip count]>0) {
        NSArray *arr_sub_ip=[arr_ip objectAtIndex:0];
        NSString *str_ip=[arr_sub_ip objectAtIndex:0];
        NSString *str_port=[arr_sub_ip objectAtIndex:1];
        str_ip_label=[NSString stringWithFormat:@"%@  %@:%@",@"当前服务器端口为",str_ip,str_port];
    }
    
    lbl_ip=[self CreateLabel:CGRectMake(10, self.view.frame.size.height-80, self.view.frame.size.width-20, 30) title:str_ip_label titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:14]];
    lbl_ip.textAlignment=NSTextAlignmentCenter;
  //  [self.view addSubview:lbl_ip];
    
    // 设置代理
    [YBMonitorNetWorkState shareMonitorNetWorkState].delegate = self;
    // 添加网络监听
    [[YBMonitorNetWorkState shareMonitorNetWorkState] addMonitorNetWorkState];
    
    [self netWorkStateChanged];
}

//新增添加显示IP地址的界面
-(void)CreateCheckBox {
    checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
    UILabel *lbl_checkname;
    if (!iPad) {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.08, self.view.frame.size.height/2+45,20,20);
        lbl_checkname=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.08+30, self.view.frame.size.height/2+30, self.view.frame.size.width*0.3, 50)];
    }
    else {
        checkbox.frame=CGRectMake(105, 620,25,25);
        lbl_checkname=[[UILabel alloc]initWithFrame:CGRectMake(160, 608, self.view.frame.size.width*0.3, 50)];
        lbl_checkname.font=[UIFont systemFontOfSize:20];
    }
    lbl_checkname.textColor=[UIColor whiteColor];
    lbl_checkname.text=@"记住密码";

    [checkbox setImage:[UIImage imageNamed:@"check_off.png"]forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"check_on.png"]forState:UIControlStateSelected];
    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:checkbox];
    [self.view addSubview:lbl_checkname];
    
}

-(void)createLabels {
    
    UILabel *lbl_title1;
    UILabel *lbl_title2;
    UILabel *lbl_title3;
    
    if (iPhone6 || iPhone6_plus) {
        lbl_title1=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-170, self.view.frame.size.width-20, 50) title:@"YICR综合信息管理系统" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:25]];
        lbl_title2=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-130, self.view.frame.size.width-20, 50) title:@"设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        lbl_title3=[self CreateLabel:CGRectMake(10, self.view.frame.size.height-50, self.view.frame.size.width-20,30 ) title:@"河南省信息咨询设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15]];
    }
    else if (iPhone5_5s) {
        lbl_title1=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-140, self.view.frame.size.width-20, 50) title:@"YICR综合信息管理系统" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:25]];
        lbl_title2=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-100, self.view.frame.size.width-20, 50) title:@"设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        lbl_title3=[self CreateLabel:CGRectMake(10, self.view.frame.size.height-50, self.view.frame.size.width-20,30 ) title:@"河南省信息咨询设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15]];
    }
    else if (iPad) {
        lbl_title1=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-240, self.view.frame.size.width-20, 50) title:@"YICR综合信息管理系统" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:35]];
        lbl_title2=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-100, self.view.frame.size.width-20, 50) title:@"设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        lbl_title3=[self CreateLabel:CGRectMake(10, 900, self.view.frame.size.width-20,30 ) title:@"河南省信息咨询设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:25]];
    }
    
    
    [self.view addSubview:lbl_title1];
  //  [self.view addSubview:lbl_title2];
    [self.view addSubview:lbl_title3];
}


-(void)createButtons
{
    //登陆
    
    if (!iPad) {
        btn_login=[self createButtonFrame:CGRectMake(self.view.frame.size.width*0.18, self.view.frame.size.height/2+110, self.view.frame.size.width*0.64, 50) backImageName:nil title:@"登  录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:25] target:self action:@selector(landClick)];
        btn_login.layer.cornerRadius=25.0f;
    }
    else {
        btn_login=[self createButtonFrame:CGRectMake(120, 700, 528, 60) backImageName:nil title:@"登  录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:30] target:self action:@selector(landClick)];
        btn_login.layer.cornerRadius=30.0f;
    }
    btn_login.backgroundColor=[UIColor clearColor];
    
    btn_login.layer.borderWidth=1.0f;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 234/255.0f, 246/255.0f, 254/255.0f, 0.3 });
    btn_login.layer.borderColor=colorref;

    //服务器设置
    CGFloat i_Width=35.0f;
    CGFloat i_Right=75.0f;
    if (iPhone6 || iPhone6_plus) {
        i_Width=35.0f;
        i_Right=75.0f;
    }
    else if (iPhone5_5s || iPhone4_4s) {
        i_Width=25.0f;
        i_Right=55.0f;
    }
    
    if (!iPad) {
        _btn_Server=[self createButtonFrame:CGRectMake(self.view.frame.size.width-i_Right, self.view.frame.size.height-50, i_Width, i_Width) backImageName:@"server.png" title:@"" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(serverip:)];
    }
    else {
        _btn_Server=[self createButtonFrame:CGRectMake(600, 898, 30, 30) backImageName:@"server.png" title:@"" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17] target:self action:@selector(serverip:)];
    }
        //newUserBtn.backgroundColor=[UIColor lightGrayColor];
    
    //忘记密码
    
    if (!iPad) {
        _btn_forgetpassword=[self createButtonFrame:CGRectMake(self.view.frame.size.width*0.35, self.view.frame.size.height/2+180, self.view.frame.size.width*0.3, 30) backImageName:nil title:@"忘记密码?" titleColor:[UIColor colorWithRed:232/255.0f green:242/255.0f blue:255/255.0f alpha:0.3] font:[UIFont systemFontOfSize:15] target:self action:@selector(fogetPwd:)];
    }
    else {
        _btn_forgetpassword=[self createButtonFrame:CGRectMake(self.view.frame.size.width*0.35, self.view.frame.size.height/2+280, self.view.frame.size.width*0.3, 50) backImageName:nil title:@"忘记密码?" titleColor:[UIColor colorWithRed:232/255.0f green:242/255.0f blue:255/255.0f alpha:0.3] font:[UIFont systemFontOfSize:18] target:self action:@selector(fogetPwd:)];
    }
  
    //fogotPwdBtn.backgroundColor=[UIColor lightGrayColor];
    
    
    [self.view addSubview:btn_login];
   // [self.view addSubview:btn_newuser];
    [self.view addSubview:_btn_forgetpassword];
    
    [self.view addSubview:_btn_Server];
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}


//登录
-(void)landClick
{
    //zr 20160215 测试暂时屏蔽
    /*
    UIAlertController *alert;
    if ([user.text isEqualToString:@""])
    {
        alert= [self createAlertController:@"提示" message:@"请输入用户名"];
    }
    else if (user.text.length <11)
    {
        alert=[self createAlertController:@"提示" message:@"您输入的手机号码格式不正确"];
    }
    else if ([pwd.text isEqualToString:@""])
    {
        alert=[self createAlertController:@"提示" message:@"请输入密码"];
    }
    else if (pwd.text.length <6)
    {
        alert=[self createAlertController:@"提示" message:@"密码长度至少六位"];
    }
    if (alert!=nil) {
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
     */
  //  NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
  //  UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:2];
  //  personCenterTabBarItem.badgeValue = @"2";
    
    /*
    if ([self isLocal]) {
        [self LocalEnter];
    }
    else {
     */
    
    
    
    [self postLogin];
   // }
    
   // [self LocalEnter];

 
}

//判断是在线还是离线
/*
-(BOOL)isLocal {
    NSString *File=[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithContentsOfFile:File];
    BOOL isLocal=  [dict objectForKey:@"blocal"];
    return isLocal;
}
 */

//离线测试用
-(void)LocalEnter {
    UserInfo *userInfo=[self CreateUserInfo];
    [self saveUserInfo:userInfo];
    OAViewController *viewController=[[OAViewController alloc]init];
    //viewController.user_Info=userInfo;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) InitDataBase {
    DataBase *db_local=[DataBase sharedinstanceDB];
    //创建数据库
    [db_local initTables];
    //添加IP数据
    [db_local InsertIPTable:@"192.168.1.62" port:@"8080" IP_Mark:@"TestServer"];
    //添加接口数据
    [db_local InsertInterFaceTable];
    
    
    
}

//注册
-(void)zhuce
{
    [self.navigationController pushViewController:[[SignInViewController alloc]init] animated:YES];
}

-(void)registration:(UIButton *)button
{
    [self.navigationController pushViewController:[[SignInViewController alloc]init] animated:YES];
    
}

-(void)fogetPwd:(UIButton *)button
{
   // PasswordViewController *vc=[[PasswordViewController alloc]init];
   // [self.navigationController pushViewController:vc animated:YES];
    
    [self.navigationController pushViewController:[[settingPasswordViewController alloc]init] animated:YES];
}


-(void)serverip:(UIButton*)button {
    ServerIPViewController *vc=[[ServerIPViewController alloc]init];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}


-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

-(void)clickBack:(UIButton *)button
{
    //      [kAPPDelegate appDelegateInitTabbar];
    self.view.backgroundColor=[UIColor whiteColor];
    exit(0);
}


-(void)createTextFields
{
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 75, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.alpha=0.7;
    bgView.backgroundColor=[UIColor clearColor];
    //[self.view addSubview:bgView];
    
    UIColor *placeholderColor= [UIColor colorWithRed:166/255.0f green:191/255.0f blue:250/255.0f alpha:1];
    if (!iPad) {
        user=[self createTextFielfFrame:CGRectMake(60, self.view.frame.size.height/2-50, self.view.frame.size.width-120, 30) font:[UIFont systemFontOfSize:20] placeholder:@"用户名"];
    }
    else {
        user=[self createTextFielfFrame:CGRectMake(160, 450, self.view.frame.size.width-320, 50) font:[UIFont systemFontOfSize:25] placeholder:@"用户名"];
    }
   
    user.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    //user.text=@"13419693608";
    user.keyboardType=UIKeyboardTypeDefault;
    user.textColor=[UIColor whiteColor];
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    user.delegate=self;
   // user.text=@"sysadmin";
  //  user.text=@"张克进";
    
    if (!iPad) {
        pwd=[self createTextFielfFrame:CGRectMake(60, self.view.frame.size.height/2, self.view.frame.size.width-120, 30) font:[UIFont systemFontOfSize:20]  placeholder:@"密码" ];
    }
    else {
        pwd=[self createTextFielfFrame:CGRectMake(160, 550, self.view.frame.size.width-320, 50) font:[UIFont systemFontOfSize:25]  placeholder:@"密码" ];
    }
   
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //pwd.text=@"123456";
    //密文样式
    pwd.secureTextEntry=YES;
    pwd.textColor=[UIColor whiteColor];
    pwd.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    pwd.delegate=self;
   // pwd.text=@"000000";
    //pwd.keyboardType=UIKeyboardTypeNumberPad;
    
    UIImageView *userImageView;
    UIImageView *pwdImageView;
    if (!iPad) {
      userImageView=[self createImageViewFrame:CGRectMake(self.view.frame.size.width*0.07, self.view.frame.size.height/2-50, 25, 25) imageName:@"ic_landing_nickname" color:nil];
      pwdImageView=[self createImageViewFrame:CGRectMake(self.view.frame.size.width*0.07, self.view.frame.size.height/2, 25, 25) imageName:@"mm_normal" color:nil];
    }
    else {
        userImageView=[self createImageViewFrame:CGRectMake(100, 460, 30, 30) imageName:@"ic_landing_nickname" color:nil];
        pwdImageView=[self createImageViewFrame:CGRectMake(100, 560, 30, 30) imageName:@"mm_normal" color:nil];
    }
    
   
    UIView *underline1;
    UIView *underline2;
    if (!iPad) {
        underline1=[[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2-20, self.view.frame.size.width-40, 1)];
        underline1.backgroundColor=[UIColor whiteColor];
        underline2=[[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2+30, self.view.frame.size.width-40, 1)];
        underline2.backgroundColor=[UIColor whiteColor];
    }
    else {
        underline1=[[UIView alloc]initWithFrame:CGRectMake(100, self.view.frame.size.height/2-20, self.view.frame.size.width-200, 1)];
        underline1.backgroundColor=[UIColor whiteColor];
        underline2=[[UIView alloc]initWithFrame:CGRectMake(100, self.view.frame.size.height/2+80, self.view.frame.size.width-200, 1)];
        underline2.backgroundColor=[UIColor whiteColor];
    }
   
    [self.view addSubview:underline1];
    [self.view addSubview:underline2];
    [self.view addSubview:user];
    [self.view addSubview:pwd];
    
    [self.view addSubview:userImageView];
    [self.view addSubview:pwdImageView];
   // [bgView addSubview:line1];
}




-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor blackColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    
    return textField;
    
}

-(UIAlertController *)createAlertController: (NSString *)str_title message:(NSString*)str_message
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:str_title message:str_message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    return alertController;
                                        
}


-(UILabel*)CreateLabel:(CGRect)frame title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font {
    UILabel *lbl_tmp=[[UILabel alloc]init];
    [lbl_tmp setFrame:frame];
    lbl_tmp.text=title;
    lbl_tmp.textColor=titleColor;
    lbl_tmp.font=font;
    lbl_tmp.textAlignment=NSTextAlignmentCenter;
    
    return lbl_tmp;
    
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


-(void)postLogin {
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_interface=[db fetchInterface:@"Login"];
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_interface];

    [_session.requestSerializer setTimeoutInterval:20.0];
    
    NSString *str_username=user.text;
    str_username= [str_username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *str_password=pwd.text;
    str_password=[str_password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _params[@"username"]=str_username;
    _params[@"password"]=str_password;
     //_params[@"username"]=@"sysadmin";
    // _params[@"password"]=@"000000";
    
    indicator=[self AddLoop];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    if ([str_reachable isEqualToString:@"wifi"] || [str_reachable isEqualToString:@"GPRS"])
    {
        [_session POST:str_url parameters:_params progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"正在加载");
            _btn_forgetpassword.enabled=NO;
            _btn_Server.enabled=NO;
            btn_login.enabled=NO;
           
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (JSON.count==1) {
                [indicator stopAnimating];
                NSDictionary *dic_exp=[JSON objectForKey:@"exception"];
                NSString *str_message=[dic_exp objectForKey:@"message"];
                str_message=[NSString stringWithFormat:@"%@%@",@"未能登录成功，",str_message];
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:str_message cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                    
                }];
                _btn_forgetpassword.enabled=YES;
                _btn_Server.enabled=YES;
                btn_login.enabled=YES;
                [alert showLXAlertView];
               
            }
            else if (JSON.count==3) {
                [indicator stopAnimating];
            
                NSLog(@"请求JSON成功");
                NSString *str_success=[JSON objectForKey:@"success"];
                BOOL b_success=[str_success boolValue];
                if (b_success==YES) {
                    if (b_rememberPwd==YES) {
                        [self saveUserInfo];
                    }
                    //保存session
                    [self saveLoginSession:str_url];
                    NSDictionary *dic_usr=[JSON objectForKey:@"userInfo"];
                    // [self postLogin2];
                    [self MoveToNextPage:dic_usr];
                }
                else {
                    NSString *str_msg=[JSON objectForKey:@"msg"];
                    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:str_msg cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                        
                    }];
                    [alert showLXAlertView];
                    _btn_forgetpassword.enabled=YES;
                    _btn_Server.enabled=YES;
                    btn_login.enabled=YES;
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [indicator stopAnimating];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无法连接到服务器" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                
            }];
            [alert showLXAlertView];
            _btn_forgetpassword.enabled=YES;
            _btn_Server.enabled=YES;
            NSLog(@"请求失败:%@",error.description);
            _i_Success=NO;
           // [self LocalEnter];
        } ];
    }
    else {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            
        }];
        [alert showLXAlertView];
    }
    
    
}


-(void)postLogin2 {
    [self updateSession];
    [_session POST:@"http://192.168.12.25:8080/default/project/projectother/demmy/com.hnsi.erp.project.projectother.workload.queryWorkload.biz.ext" parameters:_params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功:%@",responseObject);
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求JSON成功:%@",JSON);
        
       // [self MoveToNextPage];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@",error.description);
        _i_Success=NO;
        return;
        
    } ];
}


-(void)saveUserInfo {
    //获取userDefault单例
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //登陆成功后把用户名和密码存储到UserDefault
    NSString *str_username=user.text;
    str_username= [str_username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *str_password=pwd.text;
    str_password=[str_password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [userDefaults setObject:str_username forKey:@"name"];
    [userDefaults setObject:str_password forKey:@"password"];
    [userDefaults synchronize];

}


- (void)saveLoginSession:(NSString*)str_url
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:str_url]];
    for (NSHTTPCookie *cookie in allCookies) {
        if ([cookie.name isEqualToString:kServerSessionCookie]) {
            NSMutableDictionary* cookieDictionary = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:kLocalCookieName]];
            [cookieDictionary setValue:cookie.properties forKey:kBaseUrl];
            [defaults setObject:cookieDictionary forKey:kLocalCookieName];
            [defaults synchronize];
            
            break;
        }
    }
}

-(void)saveUserInfo:(UserInfo*)userInfo {
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:userInfo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"user"];
    [defaults synchronize];
}



// 4.
- (void)removeLoginSession
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kLocalCookieName];
    [defaults synchronize];
}

// 5.
- (void)updateSession
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *cookieDict = [defaults dictionaryForKey:kLocalCookieName];
    NSDictionary *cookieProperties = [cookieDict valueForKey:kBaseUrl];
    if (cookieProperties != nil) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        NSArray *cookies = [NSArray arrayWithObject:cookie];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[NSURL URLWithString:kBaseUrl] mainDocumentURL:nil];
    }
}

- (BOOL)isLoggedIn
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLocalCookieName] != nil;
}

//登录成功转至下一页
-(void)MoveToNextPage:(NSDictionary*)dic_usr {
    UserInfo *userInfo=[[UserInfo alloc]init];
    NSString *str_name=[dic_usr objectForKey:@"empname"];
    NSString *str_orgname=[dic_usr objectForKey:@"orgname"];
    NSString *str_gender=[dic_usr objectForKey:@"sex"];
    NSObject *obj_email=[dic_usr objectForKey:@"oemail"];
    NSString *str_email=[dic_usr objectForKey:@"oemail"];
    NSString *str_cellphone=[dic_usr objectForKey:@"mobileno"];
    NSString *str_posiname=[dic_usr objectForKey:@"posiname"];
    NSString *str_tel=[dic_usr objectForKey:@"otel"];
    userInfo.str_name=str_name;
    userInfo.str_username=str_name;
    userInfo.str_gender=str_gender;
    userInfo.str_department=str_orgname;
    userInfo.str_position=str_posiname;
    userInfo.str_cellphone=str_cellphone;
   //    userInfo.str_email=str_email;
    if (obj_email==[NSNull null]) {
        str_email=@"未绑定";
    }
    userInfo.str_email=str_email;
    userInfo.str_phonenum=str_tel;
    userInfo.str_Logo=@"headLogo.png";
    
    [self saveUserInfo:userInfo];
    OAViewController *viewController=[[OAViewController alloc]init];
  //  viewController.user_Info=userInfo;
    [self.navigationController pushViewController:viewController animated:YES];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [pwd resignFirstResponder];
    [user resignFirstResponder];
}


-(void)RefreshIP {
    NSMutableArray *arr_ip= [db fetchIPAddress];
    if (arr_ip!=nil && [arr_ip count]>0) {
        NSArray *arr_sub_ip=[arr_ip objectAtIndex:0];
        NSString *str_ip=[arr_sub_ip objectAtIndex:0];
        NSString *str_port=[arr_sub_ip objectAtIndex:1];
        lbl_ip.text=[NSString stringWithFormat:@"%@   %@:%@",@"当前服务器地址为",str_ip,str_port];
        lbl_ip.textAlignment=NSTextAlignmentCenter;
    }
}

#pragma mark 网络监听代理方法，当网络状态发生改变的时候出发
-(void)netWorkStateChanged {
    // 获取当前网络类型
    NSString *currentNetWorkState = [[YBMonitorNetWorkState shareMonitorNetWorkState] getCurrentNetWorkType];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentNetWorkState forKey:@"connection"];
    [defaults synchronize];
    
    str_reachable=currentNetWorkState;

}

-(void)checkboxClick:(UIButton*)btn {
    btn.selected=!btn.selected;
    if (btn.selected) {
        b_rememberPwd=YES;
    }
    else {
        b_rememberPwd=NO;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:@"name"];
        [userDefaults setObject:nil forKey:@"password"];
        [userDefaults synchronize];
        
    }
}






@end
