//
//  ServerIPViewController.m
//  unicomOA
//
//  Created by zr-mac on 16/3/23.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ServerIPViewController.h"
#import "LoginViewController.h"

@interface ServerIPViewController ()

@end

@implementation ServerIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"服务器设置";
    
    UILabel *lbl_label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.03, self.view.frame.size.width*0.9, self.view.frame.size.height*0.05)];
    lbl_label.text=@"服务器设置";
    lbl_label.textAlignment=NSTextAlignmentCenter;
    lbl_label.font=[UIFont boldSystemFontOfSize:22];
    lbl_label.textColor=[UIColor blackColor];
    
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    self.view.backgroundColor=[UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1];
    
    UITextField *txt_IP=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.15, self.view.frame.size.width*0.9, self.view.frame.size.height*0.05)];
    
    UITextField *txt_Port=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.24, self.view.frame.size.width*0.9, self.view.frame.size.height*0.05)];
    
    txt_IP.backgroundColor=[UIColor whiteColor];
    
    txt_IP.placeholder=@"请输入服务器地址";
    
    txt_Port.backgroundColor=[UIColor whiteColor];
    
    txt_Port.placeholder=@"请输入服务器端口";
    
    
    UIButton *btn_OK=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.2, self.view.frame.size.height*0.45, self.view.frame.size.width*0.6, self.view.frame.size.height*0.05)];
    btn_OK.backgroundColor=[UIColor colorWithRed:30/255.0f green:156/255.0f blue:241/255.0f alpha:1];
    [btn_OK setTitle:@"确定" forState:UIControlStateNormal];
    [btn_OK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_OK.titleLabel.font=[UIFont systemFontOfSize:22];
    [btn_OK addTarget:self action:@selector(backToLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:lbl_label];
    
    [self.view addSubview:txt_IP];
    
    [self.view addSubview:txt_Port];
    
    [self.view addSubview:btn_OK];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToLogin:(UIButton*)sender {
    LoginViewController *vc=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
