//
//  PasswordViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PasswordViewController.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "LXAlertView.h"


@interface PasswordViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) AFHTTPSessionManager *session;

@property (nonatomic,strong) NSString *str_newPwd;

@property (nonatomic,strong) NSString *str_oldPwd;

@end

@implementation PasswordViewController {
     UITextField *txt_oldName;
    
     UITextField *txt_newPassword;
    
     UITextField *txt_confirmPassword;
    
     UIButton *btn_finish;
    
      DataBase *db;
    
    BOOL b_back;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"修改密码";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    // Do any additional se tup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:246.0/255.0f green:249.0/255.0f blue:254.0/255.0f alpha:1];
    
    UIView *view_oldPassword=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.03, self.view.frame.size.width*0.8, 40)];
    view_oldPassword.layer.cornerRadius=20;
    view_oldPassword.backgroundColor=[UIColor whiteColor];
    
    UILabel *lbl_oldName=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/16, 0, 100, 40)];
    lbl_oldName.font=[UIFont systemFontOfSize:17];
    lbl_oldName.text=@"旧密码";
    lbl_oldName.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:236.0/255.0f];
    
    txt_oldName=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.35, 0, 7*self.view.frame.size.width/16,40 )];
    txt_oldName.font=[UIFont systemFontOfSize:17];
    txt_oldName.placeholder=@"请输入旧密码";
    txt_oldName.textColor=[UIColor blackColor];
    txt_oldName.secureTextEntry=YES;
    txt_oldName.delegate=self;
    
    [view_oldPassword addSubview:lbl_oldName];
    [view_oldPassword addSubview:txt_oldName];
    
    [self.view addSubview:view_oldPassword];
    
    UIView *view_newPassword=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.13, self.view.frame.size.width*0.8, 40)];
    view_newPassword.backgroundColor=[UIColor whiteColor];
    view_newPassword.layer.cornerRadius=20.0f;
    UILabel *lbl_newPassword=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/16, 0, 100, 40)];
    lbl_newPassword.font=[UIFont systemFontOfSize:17];
    lbl_newPassword.text=@"新密码";
    lbl_newPassword.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
    
    txt_newPassword=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.35, 0, 7*self.view.frame.size.width/16, 40)];
    txt_newPassword.font=[UIFont systemFontOfSize:17];
    txt_newPassword.placeholder=@"请输入新密码";
    txt_newPassword.textColor=[UIColor blackColor];
    txt_newPassword.secureTextEntry=YES;
    txt_newPassword.delegate=self;
    
    [view_newPassword addSubview:lbl_newPassword];
    [view_newPassword addSubview:txt_newPassword];
    
    [self.view addSubview:view_newPassword];
    
    UIView *view_confirmPassword=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.1,self.view.frame.size.height*0.23, self.view.frame.size.width*0.8, 40)];
    view_confirmPassword.backgroundColor=[UIColor whiteColor];
    view_confirmPassword.layer.cornerRadius=20.0f;
    UILabel *lbl_confirm=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/16, 0, 100, 40)];
    lbl_confirm.font=[UIFont systemFontOfSize:17];
    lbl_confirm.text=@"确认密码";
    lbl_confirm.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];

    txt_confirmPassword=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.35, 0, 7*self.view.frame.size.width/16, 40)];
    txt_confirmPassword.font=[UIFont systemFontOfSize:17];
    txt_confirmPassword.placeholder=@"请确认新密码";
    txt_confirmPassword.textColor=[UIColor blackColor];
    txt_confirmPassword.secureTextEntry=YES;
    txt_confirmPassword.delegate=self;
    
    [view_confirmPassword addSubview:lbl_confirm];
    [view_confirmPassword addSubview:txt_confirmPassword];
    
    [self.view addSubview:view_confirmPassword];
    
    btn_finish=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.2,self.view.frame.size.height*0.45 , self.view.frame.size.width*0.6, 40)];
    [btn_finish setTitle:@"完成" forState:UIControlStateNormal];
    [btn_finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_finish setBackgroundColor:[UIColor colorWithRed:70/255.0f green:115/255.0f blue:230/255.0f alpha:1]];
    btn_finish.layer.cornerRadius=20.0f;
    [btn_finish addTarget:self action:@selector(btn_Finish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_finish];
    
    b_back=NO;
    
    db=[DataBase sharedinstanceDB];
    
    _session=[AFHTTPSessionManager manager];
    _session.responseSerializer= [AFHTTPResponseSerializer serializer];
    [_session.requestSerializer setHTTPShouldHandleCookies:YES];
    
    _str_oldPwd=@"";
    _str_newPwd=@"";
    
    
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn_finish];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)btn_Finish:(UIButton *)newBtn {
    //在点击finish时判断是否更新
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    if (![txt_oldName.text isEqualToString:@""]) {
        _str_oldPwd=txt_oldName.text;
    }
    if (![txt_newPassword.text isEqualToString:@""] && ![txt_confirmPassword.text isEqualToString:@""]) {
        NSString *str_new1=txt_newPassword.text;
        NSString *str_new2=txt_confirmPassword.text;
        if ([str_new1 isEqualToString:str_new2]) {
            _str_newPwd=str_new2;
        }
        else {
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"两次输入密码不一致" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                //NSLog(@"点击index====%ld",clickIndex);
            }];
            [alert showLXAlertView];
            return;
        }
    }
    if (![_str_newPwd isEqualToString:@""] && ![_str_oldPwd isEqualToString:@""]) {
        dic_param[@"oldPassword"]=_str_oldPwd;
        dic_param[@"newPassword"]=_str_newPwd;
        [self UpdatePassword:dic_param];
    }
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)MovePreviousVc:(UIButton*)sender {
    b_back=YES;
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (b_back==NO) {
        if (![txt_confirmPassword.text isEqualToString:@""] && ![txt_newPassword.text isEqualToString:@""]) {
            NSString *str_confirmPwd=txt_confirmPassword.text;
            NSString *str_newPwd=txt_newPassword.text;
            if (![str_confirmPwd isEqualToString:str_newPwd]) {
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"两次输入密码不一致" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                    //NSLog(@"点击index====%ld",clickIndex);
                }];
                [alert showLXAlertView];
                // self.navigationItem.leftBarButtonItem.enabled=NO;
                [btn_finish setEnabled:NO];
                return NO;
            }
            else {
                _str_newPwd=str_confirmPwd;
            }
        }
    }
    [btn_finish setEnabled:YES];
    self.navigationItem.leftBarButtonItem.enabled=YES;
    return YES;
}
*/


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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
