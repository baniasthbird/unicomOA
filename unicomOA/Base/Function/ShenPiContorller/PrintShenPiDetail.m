//
//  PrintShenPiDetail.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "PrintShenPiDetail.h"

@implementation PrintShenPiDetail

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100)];
    
    
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
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 204/255.0f, 204/255.0f, 204/255.0f, 1 });
    btn_tmp.layer.borderColor=colorref;
    btn_tmp.layer.borderWidth=1;
    btn_tmp.titleLabel.font=[UIFont systemFontOfSize:13];
    return btn_tmp;
    
}

@end
