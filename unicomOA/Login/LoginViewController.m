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
    
    //设置NavigationBar的背景色
    View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    View.image=[UIImage imageNamed:@"bg4"];
    [self.view addSubview:View];
    
    //navigationbar上面的三个按钮
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(5, 27, 35, 35)];
    [btn_back setImage:[UIImage imageNamed:@"goback_back_orange_on"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_back];
    
    UIButton *btn_signin=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 30, 50, 30)];
    [btn_signin setTitle:@"注册" forState:UIControlStateNormal];
    [btn_signin setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
   // btn_signin.font=[UIFont systemFontOfSize:17];
    btn_signin.titleLabel.font=[UIFont systemFontOfSize:17];
    [btn_signin addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_signin];
    
    UILabel *lb_login=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-30)/2, 30, 50, 30)];
    lb_login.text=@"登陆";
    lb_login.textColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.view addSubview:lb_login];
    
    
    [self createButtons];
    [self createImageViews];
    [self createTextFields];
    
}



-(void)createButtons
{
    UIButton *btn_login=[self createButtonFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 37) backImageName:nil title:@"登录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(landClick)];
    btn_login.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    btn_login.layer.cornerRadius=5.0f;
    
    UIButton *btn_newuser=[self createButtonFrame:CGRectMake(5, 235, 70, 30) backImageName:nil title:@"快速注册" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(registration:)];
    //newUserBtn.backgroundColor=[UIColor lightGrayColor];
    
    UIButton *btn_forgetpassword=[self createButtonFrame:CGRectMake(self.view.frame.size.width-75, 235, 60, 30) backImageName:nil title:@"找回密码" titleColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] target:self action:@selector(fogetPwd:)];
    //fogotPwdBtn.backgroundColor=[UIColor lightGrayColor];
    
    
    #define Start_X 60.0f           // 第一个按钮的X坐标
    #define Start_Y 440.0f           // 第一个按钮的Y坐标
    #define Width_Space 50.0f        // 2个按钮之间的横间距
    #define Height_Space 20.0f      // 竖间距
    #define Button_Height 50.0f    // 高
    #define Button_Width 50.0f      // 宽
    
    [self.view addSubview:btn_login];
    [self.view addSubview:btn_newuser];
    [self.view addSubview:btn_forgetpassword];
    
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
    if ([user.text isEqualToString:@""])
    {
        //[SVProgressHUD showInfoWithStatus:@"亲,请输入用户名"];
        return;
    }
    else if (user.text.length <11)
    {
        //[SVProgressHUD showInfoWithStatus:@"您输入的手机号码格式不正确"];
        return;
    }
    else if ([pwd.text isEqualToString:@""])
    {
        //[SVProgressHUD showInfoWithStatus:@"亲,请输入密码"];
        return;
    }
    else if (pwd.text.length <6)
    {
        //[SVProgressHUD showInfoWithStatus:@"亲,密码长度至少六位"];
        return;
    }
    
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


-(void)createImageViews
{
    
    UIImageView *line3=[self createImageViewFrame:CGRectMake(2, 400, 100, 1) imageName:nil color:[UIColor lightGrayColor]];
    UIImageView *line4=[self createImageViewFrame:CGRectMake(self.view.frame.size.width-100-4, 400, 100, 1) imageName:nil color:[UIColor lightGrayColor]];
    
    //    [bgView addSubview:userImageView];
    //    [bgView addSubview:pwdImageView];
    //    [bgView addSubview:line1];
    //[self.view addSubview:line2];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    
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
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    user=[self createTextFielfFrame:CGRectMake(60, 10, 271, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入您手机号码"];
    //user.text=@"13419693608";
    user.keyboardType=UIKeyboardTypeNumberPad;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    pwd=[self createTextFielfFrame:CGRectMake(60, 60, 271, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"密码" ];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    //pwd.text=@"123456";
    //密文样式
    pwd.secureTextEntry=YES;
    //pwd.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(20, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(20, 60, 25, 25) imageName:@"mm_normal" color:nil];
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    [bgView addSubview:user];
    [bgView addSubview:pwd];
    
    [bgView addSubview:userImageView];
    [bgView addSubview:pwdImageView];
    [bgView addSubview:line1];
}


-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}



@end
