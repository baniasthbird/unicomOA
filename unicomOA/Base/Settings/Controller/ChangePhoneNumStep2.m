//
//  ChangePhoneNumStep2.m
//  unicomOA
//
//  Created by zr-mac on 16/3/22.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ChangePhoneNumStep2.h"
#import "ChangePhoneNumStep3.h"

@interface ChangePhoneNumStep2 ()

@property (nonatomic,strong) UITextField *txt_num;

@end

@implementation ChangePhoneNumStep2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"更换手机账号";
    
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};

    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:243/255.0f];
    
    _txt_num=[[UITextField alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.12, self.view.frame.size.width, self.view.frame.size.height*0.08)];
    
    _txt_num.backgroundColor=[UIColor whiteColor];
    
    _txt_num.placeholder=@"请输入新手机号";
    
    _txt_num.keyboardType=UIKeyboardTypeNumberPad;
    
    
    [self.view addSubview:_txt_num];
    
    
    UIBarButtonItem *barButtonItemNx = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(MoveNextVc:)];
    [barButtonItemNx setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=barButtonItemNx;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MoveNextVc:(UIButton*)sender {
    ChangePhoneNumStep3 *viewController=[[ChangePhoneNumStep3 alloc]init];
    viewController.str_phonenum=_txt_num.text;
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