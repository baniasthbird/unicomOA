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
    
    CGFloat i_Float=0;
    if (iPhone6_plus || iPhone6) {
        i_Float=20;
    }
    else {
        i_Float=16;
    }

    
    _txt_num=[[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.06, self.view.frame.size.width*0.9, 50)];
    
    _txt_num.backgroundColor=[UIColor whiteColor];
    
    _txt_num.placeholder=@"请输入新手机号";
    
    _txt_num.keyboardType=UIKeyboardTypeNumberPad;
    
    _txt_num.layer.cornerRadius=25.0f;
    
    [_txt_num.layer setMasksToBounds:YES];
    
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:@"  请输入新手机号"];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1] range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:i_Float] range:NSMakeRange(0, attributedStr.length)];
    
    _txt_num.attributedPlaceholder=attributedStr;
    
    _txt_num.font=[UIFont systemFontOfSize:i_Float];
    
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
    viewController.user_Info=_user_Info;
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
