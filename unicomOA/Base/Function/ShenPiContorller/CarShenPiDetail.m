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
#import "ShenPiResultCell.h"
#import "ShenPiAgreeWithCarDeploy.h"

@interface CarShenPiDetail()<ShenPiAgreeDelegate,ShenPiDisAgreeDelegate,ShenPiAgreeWithCarDeployDelegate,ShenPiCopyDelegate>

@property (nonatomic,strong) UIButton *btn_agree;

@property (nonatomic,strong) UIButton *btn_disagree;

@end

@implementation CarShenPiDetail

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100)];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    
    _btn_agree=[self CreateButton:0 y:self.view.frame.size.height-100 width:self.view.frame.size.width/3 height:50 text:@"同意"];
    
    
    
    _btn_disagree=[self CreateButton:self.view.frame.size.width/3 y:self.view.frame.size.height-100 width:self.view.frame.size.width/3 height:50 text:@"不同意"];
    
    UIButton *btn_copy=[self CreateButton:2*self.view.frame.size.width/3 y:self.view.frame.size.height-100 width:self.view.frame.size.width/3 height:50 text:@"抄送"];
    
    
    [_btn_agree addTarget:self action:@selector(SignToAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn_disagree addTarget:self action:@selector(SignToDissAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn_copy addTarget:self action:@selector(SignToCopy:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_b_IsEnabled==NO) {
        [_btn_agree setEnabled:NO];
        [_btn_disagree setEnabled:NO];
    }
    else if (_b_IsEnabled==YES) {
        [_btn_disagree setEnabled:YES];
        [_btn_agree setEnabled:YES];
    }
    
    
    [self.view addSubview:_btn_agree];
    [self.view addSubview:_btn_disagree];
    [self.view addSubview:btn_copy];
}

-(void)SignToAgree:(UIButton*)sender {
    if (self.service.shenpi_1!=nil && self.service.shenpi_2==nil) {
        ShenPiAgreeWithCarDeploy *viewController=[[ShenPiAgreeWithCarDeploy alloc]init];
        viewController.delegate=self;
        viewController.user_info=_user_Info;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    else if (self.service.shenpi_1==nil && self.service.shenpi_2==nil) {
        ShenPiAgree *viewController=[[ShenPiAgree alloc]init];
        viewController.delegate=self;
        viewController.userInfo=_user_Info;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(void)SignToDissAgree:(UIButton*)sender {
    ShenPiDisAgree *viewController=[[ShenPiDisAgree alloc]init];
    viewController.delegate=self;
    viewController.userInfo=_user_Info;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)SignToCopy:(UIButton*)sender {
    ShenPiCopy *viewController=[[ShenPiCopy alloc]init];
    viewController.delegate=self;
    viewController.userInfo=_user_Info;
    [self.navigationController pushViewController:viewController animated:YES];
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
    [_delegate CarRefreshTableView];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SendAgreeStatus:(ShenPiStatus *)tmp_status {
    if (self.service.shenpi_1==nil) {
        self.service.shenpi_1=tmp_status;
    }
    else if (self.service.shenpi_2==nil) {
        self.service.shenpi_2=tmp_status;
        [_btn_agree setEnabled:NO];
        [_btn_disagree setEnabled:NO];
    }
    [self.tableview reloadData];
    
}

-(void)SendDisAgreeStatus:(ShenPiStatus *)tmp_Status {
    if (self.service.shenpi_1==nil) {
        self.service.shenpi_1=tmp_Status;
        [_btn_agree setEnabled:NO];
        [_btn_disagree setEnabled:NO];
    }
    else if (self.service.shenpi_2==nil) {
        self.service.shenpi_2=tmp_Status;
        [_btn_agree setEnabled:NO];
        [_btn_disagree setEnabled:NO];
    }
    [self.tableview reloadData];
}

-(void)SendAgreeStatus:(ShenPiStatus *)tmp_status CarModel:(CarModel *)model {
    if (self.service.shenpi_2==nil) {
        self.service.shenpi_2=tmp_status;
        //self.service.car_model=model;
    }
    [self.tableview reloadData];
}

-(void)SendShenPiCopyUser:(NSMutableArray *)usr_copy {
    
}

@end
