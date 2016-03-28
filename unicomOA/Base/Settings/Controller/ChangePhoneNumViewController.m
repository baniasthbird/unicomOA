//
//  ChangePhoneNumViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ChangePhoneNumViewController.h"
#import "ChangePhoneNumStep1.h"

@interface ChangePhoneNumViewController ()

@end

@implementation ChangePhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"绑定手机号";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImage *img_bg=[UIImage imageNamed:@"PHONEOA.png"];
    //UIImageView *img_View=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.2, self.view.frame.size.height*0.14, self.view.frame.size.width*0.5, self.view.frame.size.height*0.3)];
    UIImageView *img_View=[[UIImageView alloc]initWithImage:img_bg];
    img_View.frame=CGRectMake(self.view.frame.size.width*0.15, self.view.frame.size.height*0.15, self.view.frame.size.width*0.7, self.view.frame.size.height*0.3);
    
    UILabel *lbl_txt1=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.45, self.view.frame.size.width*0.5, self.view.frame.size.height/32)];
    
    lbl_txt1.text=@"当前绑定的手机号:";
    
    lbl_txt1.font=[UIFont systemFontOfSize:22];
    
    lbl_txt1.textColor=[UIColor blackColor];
    
    UIButton *btn_ChangeNum=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.55, self.view.frame.size.width*0.9, self.view.frame.size.height/16)];
    [btn_ChangeNum setTitle:@"更换手机账号" forState:UIControlStateNormal];
    [btn_ChangeNum setBackgroundColor:[UIColor colorWithRed:22/255.0f green:156/255.0f blue:213/255.0f alpha:1]];
    btn_ChangeNum.titleLabel.textAlignment=NSTextAlignmentCenter;
    btn_ChangeNum.titleLabel.textColor=[UIColor whiteColor];
    [btn_ChangeNum addTarget:self action:@selector(MoveNextVc:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lbl_txt2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.615, self.view.frame.size.width*0.6, self.view.frame.size.height/32)];
    
    lbl_txt2.text=@"手机账号可用于登陆和找回密码";
    
    lbl_txt2.font=[UIFont systemFontOfSize:14];
    
    lbl_txt2.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];

    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我的资料" style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [self.view addSubview:img_View];
    [self.view addSubview:lbl_txt1];
    [self.view addSubview:btn_ChangeNum];
    [self.view addSubview:lbl_txt2];
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MoveNextVc:(UIButton*)sender {
    ChangePhoneNumStep1 *viewController=[[ChangePhoneNumStep1 alloc]init];
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
