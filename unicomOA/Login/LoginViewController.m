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




@interface LoginViewController()<UITextFieldDelegate>
{
    UIImageView *View;
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
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

@property BOOL i_Success;



@end



@implementation LoginViewController {
     DataBase *db;
}

static NSString *kServerSessionCookie=@"JSESSIONID";
static NSString *kLocalCookieName=@"UnicomOACookie";
static NSString *kLocalUserData=@"UnicomOALocalUser";
static NSString *kBaseUrl=@"http://192.168.12.151:8080/default/mobile/user/com.hnsi.erp.mobile.user.LoginManager.login.biz.ext";

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}
 
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    //设置NavigationBar的背景色
    View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    View.image=[UIImage imageNamed:@"LoginView.png"];
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
    
    [self InitDataBase];
    db=[DataBase sharedinstanceDB];
}

-(void)createLabels {
    
    UILabel *lbl_title1;
    UILabel *lbl_title2;
    UILabel *lbl_title3;
    if (iPhone6 || iPhone6_plus) {
        lbl_title1=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-170, self.view.frame.size.width-20, 50) title:@"HNTI综合信息管理系统" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:25]];
        lbl_title2=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-130, self.view.frame.size.width-20, 50) title:@"设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        lbl_title3=[self CreateLabel:CGRectMake(10, self.view.frame.size.height-50, self.view.frame.size.width-20,30 ) title:@"河南省信息咨询设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15]];
    }
    else if (iPhone5_5s) {
        lbl_title1=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-140, self.view.frame.size.width-20, 50) title:@"HNTI综合信息管理系统" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:25]];
        lbl_title2=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-100, self.view.frame.size.width-20, 50) title:@"设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        lbl_title3=[self CreateLabel:CGRectMake(10, self.view.frame.size.height-50, self.view.frame.size.width-20,30 ) title:@"河南省信息咨询设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15]];
        
    }
    
    
    [self.view addSubview:lbl_title1];
  //  [self.view addSubview:lbl_title2];
    [self.view addSubview:lbl_title3];
}


-(void)createButtons
{
    UIButton *btn_login=[self createButtonFrame:CGRectMake(self.view.frame.size.width*0.18, self.view.frame.size.height/2+80, self.view.frame.size.width*0.64, 50) backImageName:nil title:@"登  录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:25] target:self action:@selector(landClick)];
    btn_login.backgroundColor=[UIColor clearColor];
    btn_login.layer.cornerRadius=25.0f;
    btn_login.layer.borderWidth=1.0f;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 234/255.0f, 246/255.0f, 254/255.0f, 0.3 });
    btn_login.layer.borderColor=colorref;

    CGFloat i_Width=35.0f;
    CGFloat i_Right=75.0f;
    if (iPhone6 || iPhone6_plus) {
        i_Width=35.0f;
        i_Right=75.0f;
    }
    else {
        i_Width=25.0f;
        i_Right=55.0f;
    }
    UIButton *btn_Server=[self createButtonFrame:CGRectMake(self.view.frame.size.width-i_Right, self.view.frame.size.height-50, i_Width, i_Width) backImageName:@"server.png" title:@"" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(serverip:)];
    //newUserBtn.backgroundColor=[UIColor lightGrayColor];
    
    
    UIButton *btn_forgetpassword=[self createButtonFrame:CGRectMake(self.view.frame.size.width*0.35, self.view.frame.size.height/2+150, self.view.frame.size.width*0.3, 30) backImageName:nil title:@"忘记密码?" titleColor:[UIColor colorWithRed:232/255.0f green:242/255.0f blue:255/255.0f alpha:0.3] font:[UIFont systemFontOfSize:15] target:self action:@selector(fogetPwd:)];
    //fogotPwdBtn.backgroundColor=[UIColor lightGrayColor];
    
    
    
    #define Start_X 60.0f           // 第一个按钮的X坐标
    #define Start_Y 440.0f           // 第一个按钮的Y坐标
    #define Width_Space 50.0f        // 2个按钮之间的横间距
    #define Height_Space 20.0f      // 竖间距
    #define Button_Height 50.0f    // 高
    #define Button_Width 50.0f      // 宽
    
    [self.view addSubview:btn_login];
   // [self.view addSubview:btn_newuser];
    [self.view addSubview:btn_forgetpassword];
    
    [self.view addSubview:btn_Server];
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
    NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
    UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:2];
    personCenterTabBarItem.badgeValue = @"2";
    
    /*
    if ([self isLocal]) {
        [self LocalEnter];
    }
    else {
     */
   // [self postLogin];
   // }
    
   [self LocalEnter];

 
}

//判断是在线还是离线
-(BOOL)isLocal {
    NSString *File=[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithContentsOfFile:File];
    BOOL isLocal=  [dict objectForKey:@"blocal"];
    return isLocal;
    
}

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
    [db_local InsertIPTable:@"192.168.12.151" port:@"8080" IP_Mark:@"TestServer"];
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
    [self.navigationController pushViewController:[[forgetPasswordViewController alloc]init] animated:YES];
}


-(void)serverip:(UIButton*)button {
    ServerIPViewController *vc=[[ServerIPViewController alloc]init];
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
    user=[self createTextFielfFrame:CGRectMake(60, self.view.frame.size.height/2-50, self.view.frame.size.width-120, 30) font:[UIFont systemFontOfSize:20] placeholder:@"用户名"];
    user.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    //user.text=@"13419693608";
    user.keyboardType=UIKeyboardTypeDefault;
    user.textColor=[UIColor whiteColor];
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    user.delegate=self;
    user.text=@"sysadmin";
    
    pwd=[self createTextFielfFrame:CGRectMake(60, self.view.frame.size.height/2, self.view.frame.size.width-120, 30) font:[UIFont systemFontOfSize:20]  placeholder:@"密码" ];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //pwd.text=@"123456";
    //密文样式
    pwd.secureTextEntry=YES;
    pwd.textColor=[UIColor whiteColor];
    pwd.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    pwd.delegate=self;
    pwd.text=@"000000";
    //pwd.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(self.view.frame.size.width*0.07, self.view.frame.size.height/2-50, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(self.view.frame.size.width*0.07, self.view.frame.size.height/2, 25, 25) imageName:@"mm_normal" color:nil];
   
    UIView *underline1=[[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2-20, self.view.frame.size.width-40, 1)];
    underline1.backgroundColor=[UIColor whiteColor];
    UIView *underline2=[[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height/2+30, self.view.frame.size.width-40, 1)];
    underline2.backgroundColor=[UIColor whiteColor];
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

    NSString *str_username=user.text;
    str_username= [str_username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *str_password=pwd.text;
    str_password=[str_password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _params[@"username"]=str_username;
    _params[@"password"]=str_password;
     //_params[@"username"]=@"sysadmin";
    // _params[@"password"]=@"000000";
    
    [_session POST:str_url parameters:_params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功:%@",responseObject);
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (JSON.count==1) {
            NSDictionary *dic_exp=[JSON objectForKey:@"exception"];
            NSString *str_message=[dic_exp objectForKey:@"message"];
            str_message=[NSString stringWithFormat:@"%@%@",@"未能登录成功，",str_message];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:str_message cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
               
            }];
            [alert showLXAlertView];

            
        }
        else if (JSON.count==3) {
            NSLog(@"请求JSON成功:%@",JSON);
            NSString *str_success=[JSON objectForKey:@"success"];
            BOOL b_success=[str_success boolValue];
            if (b_success==YES) {
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

            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@ %@",error.description,@"进入离线模式");
        _i_Success=NO;
       [self LocalEnter];
    } ];
    
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
    [user resignFirstResponder];
    [pwd resignFirstResponder];
    return YES;
}

@end
