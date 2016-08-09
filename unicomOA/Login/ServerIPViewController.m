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

@end

@implementation ServerIPViewController {
    DataBase *db;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title=@"服务器设置";
    
    UILabel *lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.03, self.view.frame.size.width*0.9, self.view.frame.size.height*0.05)];
    lbl_label.text=@"服务器设置";
    lbl_label.textAlignment=NSTextAlignmentCenter;
    lbl_label.font=[UIFont boldSystemFontOfSize:22];
    lbl_label.textColor=[UIColor blackColor];
    
    db=[DataBase sharedinstanceDB];
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    self.view.backgroundColor=[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1];
    
    UIView *view_IP=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.15, self.view.frame.size.width*0.9, self.view.frame.size.height*0.05)];
    view_IP.backgroundColor=[UIColor whiteColor];
    
    UIView *view_Port=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.24, self.view.frame.size.width*0.9, self.view.frame.size.height*0.05)];
    view_Port.backgroundColor=[UIColor whiteColor];
    
    _txt_IP=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.15, self.view.frame.size.width*0.8, self.view.frame.size.height*0.05)];
    
    _txt_Port=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.24, self.view.frame.size.width*0.8, self.view.frame.size.height*0.05)];
    
    _txt_IP.backgroundColor=[UIColor clearColor];
    
    _txt_Port.backgroundColor=[UIColor clearColor];
    
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
    
    _txt_IP.placeholder=@"  请输入服务器地址";
    
    _txt_IP.delegate=self;
    
    //_txt_Port.layer.cornerRadius=i_cornerRadius;
    [_txt_Port.layer setMasksToBounds:YES];
    
    _txt_Port.backgroundColor=[UIColor whiteColor];
    
    _txt_Port.placeholder=@"  请输入服务器端口";
    
    _txt_Port.delegate=self;
    
    _txt_IP.keyboardType=UIKeyboardTypeDecimalPad;
    
    _txt_Port.keyboardType=UIKeyboardTypeNumberPad;
    
    
    UIButton *btn_OK=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.2, self.view.frame.size.height*0.45, self.view.frame.size.width*0.6, self.view.frame.size.height*0.05)];
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
    
    [self.view addSubview:view_IP];
    
    [self.view addSubview:view_Port];
    
    [self.view addSubview:_txt_IP];
    
    [self.view addSubview:_txt_Port];
    
    [self.view addSubview:btn_OK];
    
    NSMutableArray *arr_tmp=[db fetchIPAddress];
    NSArray *arr_ip= [arr_tmp objectAtIndex:0];
    NSString *str_ip=[arr_ip objectAtIndex:0];
    NSString *str_port=[arr_ip objectAtIndex:1];
    
    _txt_IP.text=str_ip;
    _txt_Port.text=str_port;
    
    
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
    [_delegate RefreshIP];
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
