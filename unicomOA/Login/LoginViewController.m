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


@interface LoginViewController()
{
    UIImageView *View;
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
}

@property(copy,nonatomic) NSString * accountNumber;
@property(copy,nonatomic) NSString *mmmm;
@property(copy,nonatomic) NSString *str_user;

@end



@implementation LoginViewController

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
    
    
    [self createLabels];
    [self createButtons];
    [self createTextFields];
    
}

-(void)createLabels {
    
    UILabel *lbl_title1;
    UILabel *lbl_title2;
    UILabel *lbl_title3;
    if (iPhone6 || iPhone6_plus) {
        lbl_title1=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-170, self.view.frame.size.width-20, 50) title:@"河南省信息咨询" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:25]];
        lbl_title2=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-130, self.view.frame.size.width-20, 50) title:@"设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        lbl_title3=[self CreateLabel:CGRectMake(10, self.view.frame.size.height-50, self.view.frame.size.width-20,30 ) title:@"原河南省电信规划设计院" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15]];
    }
    else if (iPhone5_5s) {
        lbl_title1=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-140, self.view.frame.size.width-20, 50) title:@"河南省信息咨询" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:25]];
        lbl_title2=[self CreateLabel:CGRectMake(10, self.view.frame.size.height/2-100, self.view.frame.size.width-20, 50) title:@"设计研究有限公司" titleColor:[UIColor whiteColor] font:[UIFont fontWithName:@"STHeitiSC-Medium" size:20]];
        lbl_title3=[self CreateLabel:CGRectMake(10, self.view.frame.size.height-50, self.view.frame.size.width-20,30 ) title:@"原河南省电信规划设计院" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15]];
        
    }
    
    
    [self.view addSubview:lbl_title1];
    [self.view addSubview:lbl_title2];
    [self.view addSubview:lbl_title3];
}


-(void)createButtons
{
    UIButton *btn_login=[self createButtonFrame:CGRectMake(self.view.frame.size.width*0.28, self.view.frame.size.height/2+80, self.view.frame.size.width*0.44, 50) backImageName:nil title:@"登  录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:25] target:self action:@selector(landClick)];
    btn_login.backgroundColor=[UIColor clearColor];
    btn_login.layer.cornerRadius=25.0f;
    btn_login.layer.borderWidth=1.0f;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 234/255.0f, 246/255.0f, 254/255.0f, 0.3 });
    btn_login.layer.borderColor=colorref;

    
    UIButton *btn_Server=[self createButtonFrame:CGRectMake(self.view.frame.size.width-75, self.view.frame.size.height-50, 35, 35) backImageName:@"server.png" title:@"" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(serverip:)];
    //newUserBtn.backgroundColor=[UIColor lightGrayColor];
    
    
    UIButton *btn_forgetpassword=[self createButtonFrame:CGRectMake((self.view.frame.size.width-60)/2, self.view.frame.size.height/2+150, 60, 30) backImageName:nil title:@"忘记密码" titleColor:[UIColor colorWithRed:232/255.0f green:242/255.0f blue:255/255.0f alpha:0.3] font:[UIFont systemFontOfSize:15] target:self action:@selector(fogetPwd:)];
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
    OAViewController *viewController=[[OAViewController alloc]init];
    viewController.user_Info=userInfo;
    [self.navigationController pushViewController:viewController animated:YES];
    
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
    user.keyboardType=UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    pwd=[self createTextFielfFrame:CGRectMake(60, self.view.frame.size.height/2, self.view.frame.size.width-120, 30) font:[UIFont systemFontOfSize:20]  placeholder:@"密码" ];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //pwd.text=@"123456";
    //密文样式
    pwd.secureTextEntry=YES;
    pwd.attributedPlaceholder=[[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:placeholderColor}];
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

-(UIAlertController *)createAlertController: (NSString *)str_title message:(NSString*) str_message
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

@end
