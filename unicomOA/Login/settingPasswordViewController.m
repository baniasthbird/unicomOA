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
#import "LXAlertView.h"

@interface settingPasswordViewController ()<UITextFieldDelegate>
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
    NSString *str_newPwd;
    NSString *str_oldPwd;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.navigationController.navigationBarHidden = NO;
    self.title=@"找回密码";
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItemNx = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(MoveNextVc:)];
    [barButtonItemNx setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barButtonItemNx;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
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
        
        _txt_Pwd=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.2, self.view.frame.size.width*0.8, 50) placeholder:@"请输入新密码" security:NO fontsize:i_Float];

        _txt_Pwd2=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.34, self.view.frame.size.width*0.8, 50) placeholder:@"再次输入密码" security:NO fontsize:i_Float];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        view_OldPwd=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.03, self.view.frame.size.width*0.9, 50)];
        
        view_Pwd=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.17, self.view.frame.size.width*0.9, 50)];
        
        view_Pwd2=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.37, self.view.frame.size.width*0.9, 50)];
        
         _txt_OldPwd=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.03, self.view.frame.size.width*0.8, 50) placeholder:@"请输入原始密码" security:YES fontsize:i_Float];
        
        _txt_Pwd=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.17, self.view.frame.size.width*0.8, 50) placeholder:@"请输入新密码" security:NO fontsize:i_Float];
        
        
        _txt_Pwd2=[self CreateTextFiled:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.37, self.view.frame.size.width*0.8, 50) placeholder:@"再次输入密码" security:NO fontsize:i_Float];
        
    }
    else if (iPad) {
        view_OldPwd=[[UIView alloc]initWithFrame:CGRectMake(100, 70, 568, 50)];
        view_Pwd=[[UIView alloc]initWithFrame:CGRectMake(100, 170, 568, 50)];
        view_Pwd2=[[UIView alloc]initWithFrame:CGRectMake(100, 300, 568, 50)];
        _txt_OldPwd=[self CreateTextFiled:CGRectMake(153, 70, 500, 50) placeholder:@"请输入原始密码" security:YES fontsize:i_Float];
        _txt_Pwd=[self CreateTextFiled:CGRectMake(153, 170, 500, 50) placeholder:@"请输入新密码" security:NO fontsize:i_Float];
        _txt_Pwd2=[self CreateTextFiled:CGRectMake(153,300,500,50) placeholder:@"再次输入密码" security:NO fontsize:i_Float];
        
    }
    
    view_OldPwd.backgroundColor=[UIColor whiteColor];
    view_OldPwd.layer.cornerRadius=25.0f;
    
    view_Pwd.backgroundColor=[UIColor whiteColor];
    view_Pwd.layer.cornerRadius=25.0f;
    
    view_Pwd2.backgroundColor=[UIColor whiteColor];
    view_Pwd2.layer.cornerRadius=25.0f;


    _txt_Pwd2.delegate=self;
    
    b_isSecure=YES;

    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    
    //UISwitch *sw_pwd=[[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0., self.view.frame.size.height*0.08, self.view.frame.size.height*0.08)];
    
    UIButton *checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
    
    if (iPhone6_plus) {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.28, 30, 30);
    }
    else if (iPhone6) {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.285, 30, 30);
    }
    else if (iPhone5_5s || iPhone4_4s) {
        checkbox.frame=CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.285, 30, 30);
    }
    else if (iPad) {
        checkbox.frame=CGRectMake(110, 250, 30, 30);
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
    else if (iPhone5_5s || iPhone4_4s) {
        lbl_Pwd =[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.18, self.view.frame.size.height*0.27, self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    }
    else if (iPad) {
         lbl_Pwd =[[UILabel alloc]initWithFrame:CGRectMake(160, 250, 200, 30)];
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
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    if (![_txt_OldPwd.text isEqualToString:@""]) {
        str_oldPwd=_txt_OldPwd.text;
    }
    if (![str_newPwd isEqualToString:@""] && [str_oldPwd isEqualToString:@""]) {
        dic_param[@"oldPassword"]=str_oldPwd;
        dic_param[@"newPassword"]=str_newPwd;
        [self UpdatePassword:dic_param];
    }
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
    
    
    if (btn.selected) {
        b_isSecure=YES;
        _txt_Pwd.secureTextEntry=YES;
        _txt_Pwd2.secureTextEntry=YES;
    }
    else {
        b_isSecure=NO;
        _txt_Pwd.secureTextEntry=NO;
        _txt_Pwd2.secureTextEntry=NO;
    }
    btn.selected=!btn.selected; //每次点击都改变按钮状态
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (![_txt_Pwd2.text isEqualToString:@""] && ![_txt_Pwd.text isEqualToString:@""]) {
        NSString *str_pwd2=_txt_Pwd2.text;
        NSString *str_pwd=_txt_Pwd.text;
        if (![str_pwd2 isEqualToString:str_pwd]) {
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"两次输入密码不一致" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                    //NSLog(@"点击index====%ld",clickIndex);
                }];
                [alert showLXAlertView];
                
                self.navigationItem.rightBarButtonItem.enabled=NO;
                return YES;
        }
        else {
            str_newPwd=str_pwd;
        }
    }
    self.navigationItem.rightBarButtonItem.enabled=YES;
    return YES;
}


-(void)UpdatePassword:(NSMutableDictionary*)dic_param {
    NSString *str_updatePwd= [db fetchInterface:@"ChangePassword"];
    NSString *str_ip=@"";
    NSString *str_port=@"";
    NSMutableArray *t_array=[db fetchIPAddress];
    if (t_array.count==1) {
        NSArray *arr_ip=[t_array objectAtIndex:0];
        str_ip=[arr_ip objectAtIndex:0];
        str_port=[arr_ip objectAtIndex:1];
    }
    NSString *str_url=[NSString stringWithFormat:@"%@%@:%@%@",@"http://",str_ip,str_port,str_updatePwd];
    [_session POST:str_url parameters:dic_param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *JSON=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *str_success= [JSON objectForKey:@"success"];
        BOOL b_success=[str_success intValue];
        if (b_success==YES) {
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"修改密码成功！" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                //NSLog(@"点击index====%ld",clickIndex);
            }];
            [alert showLXAlertView];
        }
        else {
            NSString *str_msg=[JSON objectForKey:@"msg"];
            NSString *str_note=[NSString stringWithFormat:@"%@%@",@"修改密码失败:",str_msg];
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:str_note cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                //NSLog(@"点击index====%ld",clickIndex);
            }];
            [alert showLXAlertView];
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [_txt_OldPwd resignFirstResponder];
    [_txt_Pwd resignFirstResponder];
    [_txt_Pwd2 resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
