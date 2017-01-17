//
//  ServerIPViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/3/23.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ServerIPViewController.h"
#import "LoginViewController.h"
#import "DataBase.h"
#import "LXAlertView.h"

@interface ServerIPViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *txt_IP;

@property (nonatomic,strong) UITextField *txt_Port;

@property (nonatomic,strong) UITextField *txt_push_IP;

@property (nonatomic,strong) UITextField *txt_push_Port;

@end

@implementation ServerIPViewController {
    DataBase *db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title=@"服务器设置";
    
    UILabel *lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(Width*0.05, Height*0.03, Width*0.9, Height*0.05)];
    lbl_label.text=@"服务器设置";
    lbl_label.textAlignment=NSTextAlignmentCenter;
    lbl_label.font=[UIFont boldSystemFontOfSize:22];
    lbl_label.textColor=[UIColor blackColor];
    
    db=[DataBase sharedinstanceDB];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    self.view.backgroundColor=[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1];
    
    
    UILabel *lbl_IP=[[UILabel alloc]initWithFrame:CGRectMake(Width*0.05, Height*0.15, Width*0.25, Height*0.05)];
    lbl_IP.text=@"主服务器IP";
    lbl_IP.textAlignment=NSTextAlignmentCenter;
    lbl_IP.font=[UIFont systemFontOfSize:18];
    lbl_IP.textColor=[UIColor blackColor];
    lbl_IP.numberOfLines=0;
    
    UIView *view_IP=[[UIView alloc]initWithFrame:CGRectMake(Width*0.35, Height*0.15, Width*0.6, Height*0.05)];
    view_IP.backgroundColor=[UIColor whiteColor];
    
    UILabel *lbl_Port=[[UILabel alloc]initWithFrame:CGRectMake(Width*0.05, Height*0.22, Width*0.25, Height*0.1)];
    lbl_Port.text=@"主服务器端口";
    lbl_Port.textAlignment=NSTextAlignmentCenter;
    lbl_Port.font=[UIFont systemFontOfSize:18];
    lbl_Port.textColor=[UIColor blackColor];
    lbl_Port.numberOfLines=0;
    
    
    UIView *view_Port=[[UIView alloc]initWithFrame:CGRectMake(Width*0.35, Height*0.24, Width*0.6, Height*0.05)];
    view_Port.backgroundColor=[UIColor whiteColor];
    
    _txt_IP=[[UITextField alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.15, Width*0.5, Height*0.05)];
    
    _txt_Port=[[UITextField alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.24, Width*0.5, Height*0.05)];
    
    _txt_IP.backgroundColor=[UIColor clearColor];
    
    _txt_IP.textAlignment=NSTextAlignmentCenter;
    
    _txt_Port.backgroundColor=[UIColor clearColor];
    
    _txt_Port.textAlignment=NSTextAlignmentCenter;
    
    CGFloat i_cornerRadius=0;
    if (iPhone6 || iPhone6_plus) {
        i_cornerRadius=18.0f;
    }
    else {
        i_cornerRadius=13.0f;
    }
    //_txt_IP.layer.cornerRadius=i_cornerRadius;
    view_IP.layer.cornerRadius=i_cornerRadius;
    view_Port.layer.cornerRadius=i_cornerRadius;
    [_txt_IP.layer setMasksToBounds:YES];
    
    _txt_IP.backgroundColor=[UIColor whiteColor];
    
    _txt_IP.placeholder=@"请输入服务器地址";
    
    _txt_IP.delegate=self;
    
    //_txt_Port.layer.cornerRadius=i_cornerRadius;
    [_txt_Port.layer setMasksToBounds:YES];
    
    _txt_Port.backgroundColor=[UIColor whiteColor];
    
    _txt_Port.placeholder=@"请输入服务器端口";
    
    _txt_Port.delegate=self;
    
    _txt_IP.keyboardType=UIKeyboardTypeDecimalPad;
    
    _txt_Port.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UILabel *lbl_Push_IP=[[UILabel alloc]initWithFrame:CGRectMake(Width*0.05, Height*0.34, Width*0.25, Height*0.1)];
    lbl_Push_IP.text=@"推送服务器IP";
    lbl_Push_IP.textAlignment=NSTextAlignmentCenter;
    lbl_Push_IP.font=[UIFont systemFontOfSize:18];
    lbl_Push_IP.textColor=[UIColor blackColor];
    lbl_Push_IP.numberOfLines=0;
    
    UIView *view_Push_IP=[[UIView alloc]initWithFrame:CGRectMake(Width*0.35, Height*0.35, Width*0.6, Height*0.05)];
    view_Push_IP.backgroundColor=[UIColor whiteColor];
    
    UILabel *lbl_Push_Port=[[UILabel alloc]initWithFrame:CGRectMake(Width*0.05, Height*0.43, Width*0.25, Height*0.1)];
    lbl_Push_Port.text=@"推送服务器端口";
    lbl_Push_Port.textAlignment=NSTextAlignmentCenter;
    lbl_Push_Port.font=[UIFont systemFontOfSize:18];
    lbl_Push_Port.textColor=[UIColor blackColor];
    lbl_Push_Port.numberOfLines=0;
    
    UIView *view_Push_Port=[[UIView alloc]initWithFrame:CGRectMake(Width*0.35, Height*0.45, Width*0.6, Height*0.05)];
    view_Push_Port.backgroundColor=[UIColor whiteColor];
    
    _txt_push_IP=[[UITextField alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.35, Width*0.5, Height*0.05)];
    
    _txt_push_Port=[[UITextField alloc]initWithFrame:CGRectMake(Width*0.4, Height*0.45, Width*0.5, Height*0.05)];
    
    _txt_push_IP.backgroundColor=[UIColor clearColor];
    
    _txt_push_IP.textAlignment=NSTextAlignmentCenter;
    
    _txt_push_Port.backgroundColor=[UIColor clearColor];
    
    _txt_push_Port.textAlignment=NSTextAlignmentCenter;
    
    //_txt_IP.layer.cornerRadius=i_cornerRadius;
    view_Push_IP.layer.cornerRadius=i_cornerRadius;
    view_Push_Port.layer.cornerRadius=i_cornerRadius;
    [_txt_push_IP.layer setMasksToBounds:YES];
    
    _txt_push_IP.backgroundColor=[UIColor whiteColor];
    
    _txt_push_IP.placeholder=@"请输入推送服务器地址";
    
    _txt_push_IP.delegate=self;
    
    //_txt_Port.layer.cornerRadius=i_cornerRadius;
    [_txt_push_Port.layer setMasksToBounds:YES];
    
    _txt_push_Port.backgroundColor=[UIColor whiteColor];
    
    _txt_push_Port.placeholder=@"请输入推送服务器端口";
    
    _txt_push_Port.delegate=self;
    
    _txt_push_IP.keyboardType=UIKeyboardTypeDecimalPad;
    
    _txt_push_Port.keyboardType=UIKeyboardTypeNumberPad;
    
    UIButton *btn_OK=[[UIButton alloc]initWithFrame:CGRectMake(Width*0.2, Height*0.60, Width*0.6, Height*0.05)];
    btn_OK.layer.cornerRadius=i_cornerRadius;
    [btn_OK.layer setMasksToBounds:YES];
    btn_OK.backgroundColor=[UIColor colorWithRed:69/255.0f green:115/255.0f blue:230/255.0f alpha:1];
    [btn_OK setTitle:@"确定" forState:UIControlStateNormal];
    [btn_OK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_OK.titleLabel.font=[UIFont systemFontOfSize:22];
    [btn_OK addTarget:self action:@selector(backToLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    
    [self.view addSubview:lbl_label];
    
    [self.view addSubview:lbl_IP];
    
    [self.view addSubview:lbl_Port];
    
    [self.view addSubview:view_IP];
    
    [self.view addSubview:view_Port];
    
    [self.view addSubview:_txt_IP];
    
    [self.view addSubview:_txt_Port];
    
    [self.view addSubview:lbl_Push_IP];
    
    [self.view addSubview:view_Push_IP];
    
    [self.view addSubview:lbl_Push_Port];
    
    [self.view addSubview:view_Push_Port];
    
    [self.view addSubview:_txt_push_IP];
    
    [self.view addSubview:_txt_push_Port];
    
    [self.view addSubview:btn_OK];
    
    NSMutableArray *arr_tmp=[db fetchIPAddress];
    NSArray *arr_ip= [arr_tmp objectAtIndex:0];
    NSString *str_ip=[arr_ip objectAtIndex:0];
    NSString *str_port=[arr_ip objectAtIndex:1];
    
    NSMutableArray *arr_push_tmp=[db fetchPushIPAddress];
    NSArray *arr_push_ip= [arr_push_tmp objectAtIndex:0];
    NSString *str_push_ip=[arr_push_ip objectAtIndex:0];
    NSString *str_push_port=[arr_push_ip objectAtIndex:1];
    
    _txt_IP.text=str_ip;
    _txt_Port.text=str_port;
    
    //zr 170112 推送服务器暂时固定
    _txt_push_IP.text=str_push_ip;
    _txt_push_Port.text=str_push_port;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToLogin:(UIButton*)sender {
    //将修改后的服务器IP及地址存储至数据库
    NSString *str_ip=_txt_IP.text;
    NSString *str_port=_txt_Port.text;
    NSString *str_push_ip=_txt_push_IP.text;
    NSString *str_push_port=_txt_push_Port.text;
    
    BOOL b_Flag=YES;
    if (str_ip!=nil && str_port!=nil) {
        @try {
            NSArray *arr_ip=[str_ip componentsSeparatedByString:@"."];
            int i_port=[str_port intValue];
            if (i_port>65535) {
                b_Flag=NO;
            }
            for (int i=0;i<arr_ip.count;i++) {
                NSString *str_ip_part=[arr_ip objectAtIndex:i];
                int i_part=[str_ip_part intValue];
                if (i_part>255) {
                    b_Flag=NO;
                    break;
                }
            }
            if (b_Flag==NO) {
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"请输入正确的IP地址或端口号" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                }];
                [alert showLXAlertView];
                return;
            }
            else {
                [db UpdateIPTable:str_ip port:str_port IP_Mark:@"Server"];
                [db UpdateIPTable:str_push_ip port:str_push_port IP_Mark:@"PushServer"];
                LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"更新服务器配置成功" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                }];
                [alert showLXAlertView];
            }
        } @catch (NSException *exception) {
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告" message:@"请输入正确的IP地址或端口号" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                NSLog(@"点击index====%ld",(long)clickIndex);
            }];
            [alert showLXAlertView];
            return;
        } @finally {
            
        }
        
    }
    if (_str_pwd!=nil && _str_username!=nil) {
        [_delegate RefreshIP:_str_username pwd:_str_pwd];
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)MovePreviousVc:(UIButton*)sender {
    if (f_v<9.0) {
        self.navigationController.delegate=nil;
    }
    [self.navigationController popViewControllerAnimated:NO];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [_txt_IP resignFirstResponder];
    [_txt_Port resignFirstResponder];
    [_txt_push_IP resignFirstResponder];
    [_txt_push_Port resignFirstResponder];
}

-(void)BuildUnit:(CGRect)rect_lbl rect_view:(CGRect)rect_view lbl_txt:(NSString*)lbl_txt cornerRadius:(CGFloat)cornerRadius {
    UILabel *lbl_Unit=[[UILabel alloc]initWithFrame:rect_lbl];
    lbl_Unit.text=lbl_txt;
    lbl_Unit.textAlignment=NSTextAlignmentCenter;
    lbl_Unit.font=[UIFont systemFontOfSize:20];
    lbl_Unit.textColor=[UIColor blackColor];
    
    UIView *view_Unit=[[UIView alloc]initWithFrame:CGRectMake(Width*0.25, Height*0.15, Width*0.7, Height*0.05)];
    view_Unit.backgroundColor=[UIColor whiteColor];
    view_Unit.layer.cornerRadius=cornerRadius;
    
   
    

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
