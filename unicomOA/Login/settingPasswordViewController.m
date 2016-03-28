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

@interface settingPasswordViewController ()
{
    UIView *bgView;
    UITextField *passward;

}

@end

@implementation settingPasswordViewController

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
    
    UITextField *txt_Pwd=[[UITextField alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.12, self.view.frame.size.width, self.view.frame.size.height*0.08)];
    txt_Pwd.placeholder=@"请输入新密码";
    txt_Pwd.backgroundColor=[UIColor whiteColor];
    
    UISwitch *sw_pwd=[[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0.23, self.view.frame.size.height*0.08, self.view.frame.size.height*0.08)];
    
    UILabel *lbl_Pwd=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.22, self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    
    lbl_Pwd.text=@"显示密码";
    
    lbl_Pwd.textColor=[UIColor blackColor];
    
    [self.view addSubview:txt_Pwd];
    [self.view addSubview:lbl_Pwd];
    [self.view addSubview:sw_pwd];
    
    /*
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickaddBtn)];
    [addBtn setImage:[UIImage imageNamed:@"goback_back_orange_on"]];
    [addBtn setImageInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    addBtn.tintColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    [self.navigationItem setLeftBarButtonItem:addBtn];
    
    [self createTextFields];
     */
}


-(void)MovePreviousVc:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)MoveNextVc:(UIButton*)sender {
    LoginViewController *vc=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
