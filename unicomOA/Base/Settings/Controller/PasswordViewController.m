//
//  PasswordViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@property (nonatomic,strong) UIView *view_oldPassword;

@property (nonatomic,strong) UIView *view_newPassword;

@property (nonatomic,strong) UIView *view_confirmPassword;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"修改密码";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:246.0/255.0f green:249.0/255.0f blue:254.0/255.0f alpha:1];
    
    _view_oldPassword=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.03, self.view.frame.size.width*0.8, 40)];
    _view_oldPassword.layer.cornerRadius=20;
    _view_oldPassword.backgroundColor=[UIColor whiteColor];
    
    UILabel *lbl_oldName=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/16, 0, 100, 40)];
    lbl_oldName.font=[UIFont systemFontOfSize:17];
    lbl_oldName.text=@"旧密码";
    lbl_oldName.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:236.0/255.0f];
    
    UITextField *txt_oldName=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.35, 0, 7*self.view.frame.size.width/16,40 )];
    txt_oldName.font=[UIFont systemFontOfSize:17];
    txt_oldName.placeholder=@"请输入旧密码";
    txt_oldName.textColor=[UIColor blackColor];
    
    [_view_oldPassword addSubview:lbl_oldName];
    [_view_oldPassword addSubview:txt_oldName];
    
    [self.view addSubview:_view_oldPassword];
    
    _view_newPassword=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.13, self.view.frame.size.width*0.8, 40)];
    _view_newPassword.backgroundColor=[UIColor whiteColor];
    _view_newPassword.layer.cornerRadius=20.0f;
    UILabel *lbl_newPassword=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/16, 0, 100, 40)];
    lbl_newPassword.font=[UIFont systemFontOfSize:17];
    lbl_newPassword.text=@"新密码";
    lbl_newPassword.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
    
    UITextField *txt_newPassword=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.35, 0, 7*self.view.frame.size.width/16, 40)];
    txt_newPassword.font=[UIFont systemFontOfSize:17];
    txt_newPassword.placeholder=@"请输入新密码";
    txt_newPassword.textColor=[UIColor blackColor];
    
    [_view_newPassword addSubview:lbl_newPassword];
    [_view_newPassword addSubview:txt_newPassword];
    
    [self.view addSubview:_view_newPassword];
    
    _view_confirmPassword=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.1,self.view.frame.size.height*0.23, self.view.frame.size.width*0.8, 40)];
    _view_confirmPassword.backgroundColor=[UIColor whiteColor];
    _view_confirmPassword.layer.cornerRadius=20.0f;
    UILabel *lbl_confirm=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/16, 0, 100, 40)];
    lbl_confirm.font=[UIFont systemFontOfSize:17];
    lbl_confirm.text=@"确认密码";
    lbl_confirm.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];

    UITextField *txt_confirmPassword=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.35, 0, 7*self.view.frame.size.width/16, 40)];
    txt_confirmPassword.font=[UIFont systemFontOfSize:17];
    txt_confirmPassword.placeholder=@"请确认新密码";
    txt_confirmPassword.textColor=[UIColor blackColor];
    
    [_view_confirmPassword addSubview:lbl_confirm];
    [_view_confirmPassword addSubview:txt_confirmPassword];
    
    [self.view addSubview:_view_confirmPassword];
    
#pragma mark 完成按钮
    UIButton *btn_finish=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.2,self.view.frame.size.height*0.45 , self.view.frame.size.width*0.6, 40)];
    [btn_finish setTitle:@"完成" forState:UIControlStateNormal];
    [btn_finish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_finish setBackgroundColor:[UIColor colorWithRed:70/255.0f green:115/255.0f blue:230/255.0f alpha:1]];
    btn_finish.layer.cornerRadius=20.0f;
    [btn_finish addTarget:self action:@selector(btn_Finish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_finish];
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn_finish];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)btn_Finish:(UIButton *)newBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
