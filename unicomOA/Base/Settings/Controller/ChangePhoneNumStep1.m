//
//  ChangePhoneNumStep1.m
//  unicomOA
//
//  Created by zr-mac on 16/3/22.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ChangePhoneNumStep1.h"
#import "ChangePhoneNumStep2.h"

@interface ChangePhoneNumStep1 ()

@end

@implementation ChangePhoneNumStep1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"更换手机账号";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    
    UITextField *txt_Num=[[UITextField alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.12, self.view.frame.size.width, self.view.frame.size.height*0.08)];
    
    txt_Num.backgroundColor=[UIColor whiteColor];
    
    txt_Num.placeholder=@"请输入登陆密码";
    
    txt_Num.keyboardType=UIKeyboardTypeNumberPad;
    
    UIButton *btn_next=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [btn_next setTitle:@"下一步" forState:UIControlStateNormal];
    [btn_next addTarget:self action:@selector(MoveNextVc:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:txt_Num];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn_next];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MoveNextVc:(UIButton*)sender {
    ChangePhoneNumStep2 *viewController=[[ChangePhoneNumStep2 alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
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