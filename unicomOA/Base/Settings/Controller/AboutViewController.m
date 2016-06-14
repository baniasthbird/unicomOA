//
//  AboutViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"关于";
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
   // self.view.backgroundColor=[UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1];
    UIImageView *img_View= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"aboutbg.png"]];
    [self.view addSubview:img_View];
    [self.view sendSubviewToBack:img_View];
    
#pragma mark 公司LOGO
    UIImage *image=[UIImage imageNamed:@"logo.png"];
    UIImageView *img_logo=[[UIImageView alloc]initWithImage:image];
    [img_logo setFrame:CGRectMake(self.view.frame.size.width/2-image.size.width/6, self.view.frame.size.height/8, image.size.width/3, image.size.height/3)];
    
#pragma mark 公司名
    UILabel *lbl_company=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-image.size.width*2, self.view.frame.size.height/8+image.size.height/3, image.size.width*4, 80)];
    lbl_company.text=@"YICR综合信息管理系统";
    lbl_company.textColor=[UIColor whiteColor];
    lbl_company.font=[UIFont boldSystemFontOfSize:24];
    lbl_company.textAlignment=NSTextAlignmentCenter;
    
#pragma mark 系统版本
    UILabel *lbl_version=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-image.size.width*2, self.view.frame.size.height/8+img_logo.frame.size.height*1.5, image.size.width*4, 80)];
    lbl_version.text=@"for IPhone V1.0";
    lbl_version.textColor=[UIColor whiteColor];
    lbl_version.font=[UIFont systemFontOfSize:14];
    lbl_version.textAlignment=NSTextAlignmentCenter;
    
#pragma mark 服务条款
    UIButton *btn_service=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-image.size.width*0.4, self.view.frame.size.height*0.65, image.size.width*0.4, 15)];
    [btn_service setTitle:@"服务条款" forState:UIControlStateNormal];
    btn_service.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    btn_service.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn_service setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_service addTarget:self action:@selector(servicerole:) forControlEvents:UIControlEventTouchUpInside];
    
    
#pragma mark 保密协议
    UIButton *btn_secret=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,self.view.frame.size.height*0.65, image.size.width*0.4, 15)];
    [btn_secret setTitle:@"保密协议" forState:UIControlStateNormal];
    btn_secret.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    btn_secret.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn_secret setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_secret addTarget:self action:@selector(secretrole:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark 版权
    UILabel *lbl_copyright=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.69, self.view.frame.size.width, 15)];
    lbl_copyright.textAlignment=NSTextAlignmentCenter;
    lbl_copyright.font=[UIFont systemFontOfSize:14];
    lbl_copyright.textColor=[UIColor whiteColor];
    lbl_copyright.text=@"技术支持：河南软信科技有限公司";
    
    UILabel *lbl_copyright_en=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.73, self.view.frame.size.width, 15)];
    lbl_copyright_en.textAlignment=NSTextAlignmentCenter;
    lbl_copyright_en.font=[UIFont systemFontOfSize:14];
    lbl_copyright_en.textColor=[UIColor whiteColor];
    lbl_copyright_en.text=@"Copyright2009-2016 All Rights Reserved";
    
    
    
    [self.view addSubview:img_logo];
    [self.view addSubview:lbl_company];
    [self.view addSubview:lbl_version];
  //  [self.view addSubview:btn_service];
  //  [self.view addSubview:btn_secret];
    [self.view addSubview:lbl_copyright];
    [self.view addSubview:lbl_copyright_en];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)servicerole:(UIButton*)btn {
    NSLog(@"服务条款已选中");
}

-(void)secretrole:(UIButton*)btn {
    NSLog(@"保密协议已选中");
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
