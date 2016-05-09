//
//  settingPasswordViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "settingPasswordViewController.h"
#import "settingHeaderViewController.h"
#import "LoginViewController.h"
#import "AFNetWorking.h"
#import "DataBase.h"

@interface settingPasswordViewController ()
{
    BOOL b_isSecure;
}

@property (nonatomic,strong) UITextField *txt_Pwd;

@property (nonatomic,strong) UITextField *txt_Pwd2;

@property (nonatomic,strong) UITextField *txt_OldPwd;

//连接
@property (nonatomic,strong) AFHTTPSessionManager *session;

@end

@implementation settingPasswordViewController {
    DataBase *db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"找回密码";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItemNx = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(MoveNextVc:)];
    [barButtonItemNx setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barButtonItemNx;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    CGFloat i_Float=0;
    if (iPhone6_plus || iPhone6) {
        i_Float=20;
    }
    else {
        i_Float=16;
    }

    db=[DataBase sharedinstanceDB];
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];

    
    UIView *view_OldPwd;
    UIView *view_Pwd;
    UIView *view_Pwd2;
    
    if (iPhone6_plus || iPhone6) {
        view_OldPwd=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.06, self.view.frame.size.width*0.9, 50)];
        view_Pwd=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.2, self.view.frame.size.width*0.9, 50)];
        
        view_Pwd2=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.34, self.view.frame.size.width*0.9, 50)];
        
        _txt_OldPwd=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.06, self.view.frame.size.width*0.8, 50) placeholder:@"请输入原始密码" security:YES fontsize:i_Float];
        
        _txt_Pwd=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.2, self.view.frame.size.width*0.8, 50) placeholder:@"请输入新密码" security:YES fontsize:i_Float];

        _txt_Pwd2=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.34, self.view.frame.size.width*0.8, 50) placeholder:@"再次输入密码" security:YES fontsize:i_Float];
    }
    else {
        view_OldPwd=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.06, self.view.frame.size.width*0.9, 50)];
        
        view_Pwd=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.25, self.view.frame.size.width*0.9, 50)];
        
        view_Pwd2=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.44, self.view.frame.size.width*0.9, 50)];
        
         _txt_OldPwd=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.06, self.view.frame.size.width*0.8, 50) placeholder:@"请输入原始密码" security:YES fontsize:i_Float];
        
        _txt_Pwd=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.25, self.view.frame.size.width*0.8, 50) placeholder:@"请输入新密码" security:YES fontsize:i_Float];
        
        
        _txt_Pwd2=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.44, self.view.frame.size.width*0.8, 50) placeholder:@"再次输入密码" security:YES fontsize:i_Float];
        
    }
    
    view_OldPwd.backgroundColor=[UIColor whiteColor];
    view_OldPwd.layer.cornerRadius=25.0f;
    
    view_Pwd.backgroundColor=[UIColor whiteColor];
    view_Pwd.layer.cornerRadius=25.0f;
    
    view_Pwd2.backgroundColor=[UIColor whiteColor];
    view_Pwd2.layer.cornerRadius=25.0f;

    
    b_isSecure=YES;
    
    
    
    //UISwitch *sw_pwd=[[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0., self.view.frame.size.height*0.08, self.view.frame.size.height*0.08)];
    
    UIButton *checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
    
    if (iPhone6_plus) {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.28, 30, 30);
    }
    else if (iPhone6) {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.285, 30, 30);
    }
    else {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.36, 30, 30);
    }
    
    
    [checkbox setImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
    
    [checkbox setImage:[UIImage imageNamed:@"checkbox_checked.png"] forState:UIControlStateSelected];
    
    
    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [checkbox setSelected:YES];
    
    UILabel *lbl_Pwd;
    if (iPhone6) {
       lbl_Pwd =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.18, self.view.frame.size.height*0.265, self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    }
    else if (iPhone6_plus) {
         lbl_Pwd =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.18, self.view.frame.size.height*0.26, self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    }
    else {
        lbl_Pwd =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.18, self.view.frame.size.height*0.345, self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    }
    
    
    lbl_Pwd.text=@"显示密码";
    lbl_Pwd.font=[UIFont systemFontOfSize:i_Float];
    
    lbl_Pwd.textColor=[UIColor blackColor];
    
    [self.view addSubview:view_OldPwd];
    [self.view addSubview:view_Pwd];
    [self.view addSubview:view_Pwd2];
    [self.view addSubview:_txt_OldPwd];
    [self.view addSubview:_txt_Pwd];
    [self.view addSubview:lbl_Pwd];
    //[self.view addSubview:sw_pwd];
    [self.view addSubview:_txt_Pwd2];
    [self.view addSubview:checkbox];
    
}


-(void)MovePreviousVc:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)MoveNextVc:(UIButton*)sender {
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_interface=[db fetchInterface:@"ChangePassword"];
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_interface];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITextField*)CreateTextFiled:(CGRect)rect placeholder:(NSString*)str_placeholder security:(BOOL)b_secure fontsize:(CGFloat)i_fontsize{
    UITextField *txt_tmp=[[UITextField alloc]initWithFrame:rect];
    
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:str_placeholder];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1] range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, attributedStr.length)];
    
    txt_tmp.attributedPlaceholder=attributedStr;
    
    txt_tmp.backgroundColor=[UIColor whiteColor];
    txt_tmp.keyboardType=UIKeyboardTypeDefault;
    //txt_tmp.layer.cornerRadius=25.0f;
    [txt_tmp.layer setMasksToBounds:YES];
    
    txt_tmp.secureTextEntry=b_secure;
    
    return txt_tmp;
}

-(void)checkboxClick:(UIButton*)btn {
    btn.selected=!btn.selected; //每次点击都改变按钮状态
    
    if (btn.selected) {
        b_isSecure=YES;
        _txt_Pwd.secureTextEntry=YES;
        _txt_Pwd2.secureTextEntry=YES;
    }
    else {
        b_isSecure=NO;
        _txt_Pwd.secureTextEntry=NO;
        _txt_Pwd.secureTextEntry=NO;
    }
    
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
