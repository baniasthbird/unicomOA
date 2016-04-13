//
//  CarShenPiDetail.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CarShenPiDetail.h"
#import "ShenPiAgree.h"
#import "ShenPiDisAgree.h"
#import "ShenPiCopy.h"

@implementation CarShenPiDetail

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100)];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    
    UIButton *btn_agree=[self CreateButton:0 y:self.view.frame.size.height-100 width:self.view.frame.size.width/3 height:50 text:@"同意"];
    
    
    
    UIButton *btn_disagree=[self CreateButton:self.view.frame.size.width/3 y:self.view.frame.size.height-100 width:self.view.frame.size.width/3 height:50 text:@"不同意"];
    
    UIButton *btn_copy=[self CreateButton:2*self.view.frame.size.width/3 y:self.view.frame.size.height-100 width:self.view.frame.size.width/3 height:50 text:@"抄送"];
    
    
    [btn_agree addTarget:self action:@selector(SignToAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_disagree addTarget:self action:@selector(SignToDissAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_copy addTarget:self action:@selector(SignToCopy:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn_agree];
    [self.view addSubview:btn_disagree];
    [self.view addSubview:btn_copy];
}

-(void)SignToAgree:(UIButton*)sender {
    ShenPiAgree *viewController=[[ShenPiAgree alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)SignToDissAgree:(UIButton*)sender {
    
}

-(void)SignToCopy:(UIButton*)sender {
    
}

-(UIButton*)CreateButton:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height text:(NSString*)str_text{
    UIButton *btn_tmp=[[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
    [btn_tmp setTitle:str_text forState:UIControlStateNormal];
    btn_tmp.backgroundColor=[UIColor whiteColor];
    [btn_tmp setTitleColor:[UIColor colorWithRed:30/255.0f green:155/255.0f blue:240/255.0f alpha:1] forState:UIControlStateNormal];
    btn_tmp.layer.borderWidth=1;
    btn_tmp.titleLabel.font=[UIFont systemFontOfSize:13];
    return btn_tmp;
    
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
