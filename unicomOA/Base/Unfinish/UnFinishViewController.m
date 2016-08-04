//
//  UnFinishViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "UnFinishViewController.h"
#import "LXAlertView.h"

@interface UnFinishViewController ()

@end

@implementation UnFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_str_title;
    
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
        
    }
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_back setTitle:@"  " forState:UIControlStateNormal];
    [btn_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_back setTintColor:[UIColor whiteColor]];
    [btn_back setImage:[UIImage imageNamed:@"returnlogo.png"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(BackToAppCenter:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn_back];
    
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if ([_str_title isEqualToString:@"系统消息"]) {
         imgView.image=[UIImage imageNamed:@"XiaoXiView"];
    }
    else if ([_str_title isEqualToString:@"公文传阅"]) {
        imgView.image=[UIImage imageNamed:@"chuanyueView"];
    }
    else if ([_str_title isEqualToString:@"办公审批"]) {
        imgView.image=[UIImage imageNamed:@"chuanyueView"];
    }
    else if ([_str_title isEqualToString:@"售前审批"]) {
        imgView.image=[UIImage imageNamed:@"ShouQianView"];
    }
    else if ([_str_title isEqualToString:@"生产审批"]) {
        imgView.image=[UIImage imageNamed:@"ShengChanView"];
    }
    else if ([_str_title isEqualToString:@"合同审批"]) {
        imgView.image=[UIImage imageNamed:@"HeTongView"];
    }
    else if ([_str_title isEqualToString:@"事务审批"]) {
        imgView.image=[UIImage imageNamed:@"ShiWuView"];
    }
    else if ([_str_title isEqualToString:@"决策辅助"]) {
        imgView.image=[UIImage imageNamed:@"JueCeView"];
    }
    
    
    [self.view addSubview:imgView];
    
    CGFloat btnx;
    CGFloat btny;
    CGFloat btnw;
    CGFloat btnh;
    
        btnx=[UIScreen mainScreen].bounds.size.width-130;
        btny=[UIScreen mainScreen].bounds.size.height-233;
        btnw=130;
        btnh=150;
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(btnx,btny,btnw,btnh)];
    btn.backgroundColor=[UIColor clearColor];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    /*
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"该功能正在审核中\n敬请期待" cancelBtnTitle:nil otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    [alert showLXAlertView];
    */
    
    
   // self.view.backgroundColor=[UIColor colorWithRed:154/255.0f green:154/255.0f blue:154/255.0f alpha:0.9];
    // Do any additional setup after loading the view.
}

-(void)btnBack:(UIButton*)sender  {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackToAppCenter:(UIButton*)Btn {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)buildView:(NSString*)str_title {
    
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
