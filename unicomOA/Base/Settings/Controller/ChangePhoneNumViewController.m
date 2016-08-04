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
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    CGFloat i_Float=0;
    if (iPhone6_plus || iPhone6) {
        i_Float=20;
    }
    else {
        i_Float=16;
    }

    
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImage *img_bg=[UIImage imageNamed:@"PHONEOA.png"];
    //UIImageView *img_View=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.2, self.view.frame.size.height*0.14, self.view.frame.size.width*0.5, self.view.frame.size.height*0.3)];
    UIImageView *img_View=[[UIImageView alloc]initWithImage:img_bg];
    if (iPhone6_plus || iPhone6) {
        img_View.frame=CGRectMake(0, -60, self.view.frame.size.width, self.view.frame.size.height);
    }
    else if (iPhone4_4s || iPhone5_5s) {
        img_View.frame=CGRectMake(0, -80, self.view.frame.size.width, self.view.frame.size.height);

    }
    
    
    UILabel *lbl_txt1;
    if (iPhone6 || iPhone6_plus) {
        lbl_txt1=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.55, self.view.frame.size.width*0.9, self.view.frame.size.height/32)];
    }
    else if (iPhone4_4s || iPhone5_5s) {
        lbl_txt1=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.5, self.view.frame.size.width*0.9, self.view.frame.size.height/32)];
    }
    lbl_txt1.font=[UIFont systemFontOfSize:i_Float];
    lbl_txt1.numberOfLines=0;
    lbl_txt1.textAlignment=NSTextAlignmentCenter;
    lbl_txt1.text=@"当前绑定的手机号:";
    
    UILabel *lbl_txtnum;
    if (iPhone6 || iPhone6_plus) {
        lbl_txtnum=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.6, self.view.frame.size.width*0.9, self.view.frame.size.height/32)];
    }
    else if (iPhone4_4s || iPhone5_5s) {
        lbl_txtnum=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.55, self.view.frame.size.width*0.9, self.view.frame.size.height/32)];
    }
    lbl_txtnum.font=[UIFont systemFontOfSize:i_Float];
    lbl_txtnum.numberOfLines=0;
    lbl_txtnum.textAlignment=NSTextAlignmentCenter;
    lbl_txtnum.text=_str_phonenum;
    
    
    lbl_txt1.textColor=[UIColor blackColor];
    
    UIButton *btn_ChangeNum;
    if (iPhone6 || iPhone6_plus) {
        btn_ChangeNum=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.65, self.view.frame.size.width*0.9, self.view.frame.size.height/16)];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        btn_ChangeNum=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.6, self.view.frame.size.width*0.9, self.view.frame.size.height/16)];
    }
 
    [btn_ChangeNum setTitle:@"更换手机账号" forState:UIControlStateNormal];
    [btn_ChangeNum setBackgroundColor:[UIColor colorWithRed:70/255.0f green:115/255.0f blue:230/255.0f alpha:1]];
    btn_ChangeNum.titleLabel.textAlignment=NSTextAlignmentCenter;
    btn_ChangeNum.titleLabel.textColor=[UIColor whiteColor];
    btn_ChangeNum.layer.cornerRadius=20.0f;
    [btn_ChangeNum.layer setMasksToBounds:YES];
    [btn_ChangeNum addTarget:self action:@selector(MoveNextVc:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *lbl_txt2;
    if (iPhone6 || iPhone6_plus) {
        lbl_txt2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.72, self.view.frame.size.width*0.9, self.view.frame.size.height/32)];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        lbl_txt2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.height*0.67, self.view.frame.size.width*0.9, self.view.frame.size.height/32)];
    }
    
    
    lbl_txt2.text=@"手机账号可用于登陆和找回密码";
    
    lbl_txt2.font=[UIFont systemFontOfSize:14];
    lbl_txt2.textAlignment=NSTextAlignmentCenter;
    
    lbl_txt2.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];

    
    
    [self.view addSubview:img_View];
    [self.view addSubview:lbl_txt1];
    [self.view addSubview:lbl_txtnum];
    [self.view addSubview:btn_ChangeNum];
    [self.view addSubview:lbl_txt2];
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)MoveNextVc:(UIButton*)sender {
    ChangePhoneNumStep1 *viewController=[[ChangePhoneNumStep1 alloc]init];
    viewController.userInfo=_user_Info;
    [self.navigationController pushViewController:viewController animated:NO];
    
    
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:NO];
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
