//
//  NewsSettingViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/14.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NewsSettingViewController.h"

@interface NewsSettingViewController ()

@property (strong,nonatomic) UIView *view_newsSeting;

@property (strong,nonatomic) UIView *view_sound;

@property (strong,nonatomic) UIView *view_virable;

@property (strong,nonatomic) UILabel *lbl_attention;

@end

@implementation NewsSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1];
    
    self.title=@"新消息通知";
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    _view_newsSeting=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/8, self.view.frame.size.width, 40)];
    _view_newsSeting.backgroundColor=[UIColor whiteColor];
    UILabel *lbl_newsSetting=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/16, 0, 100, 40)];
    lbl_newsSetting.font=[UIFont systemFontOfSize:17];
    lbl_newsSetting.text=@"新消息通知";
    lbl_newsSetting.textColor=[UIColor blackColor];
    
    UILabel *lbl_isSetting=[[UILabel alloc]initWithFrame:CGRectMake(2*self.view.frame.size.width/3,0 , 80, 40)];
    lbl_isSetting.font=[UIFont systemFontOfSize:16];
    lbl_isSetting.text=@"已开启";
    lbl_isSetting.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
    
    
    [_view_newsSeting addSubview:lbl_newsSetting];
    [_view_newsSeting addSubview:lbl_isSetting];
    
    [self.view addSubview:_view_newsSeting];
    
    _view_sound=[[UIView alloc]initWithFrame:CGRectMake(0, 5*self.view.frame.size.height/16, self.view.frame.size.width, 40)];
    _view_sound.backgroundColor=[UIColor whiteColor];
    UILabel *lbl_sound=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/16, 0, 100, 40)];
    lbl_sound.font=[UIFont systemFontOfSize:17];
    lbl_sound.text=@"声音提示";
    lbl_sound.textColor=[UIColor blackColor];
    
    UISwitch *sw_sound=[[UISwitch alloc]initWithFrame:CGRectMake(3*self.view.frame.size.width/4, self.view.frame.size.width/128, 40, 40)];
    [_view_sound addSubview:lbl_sound];
    [_view_sound addSubview:sw_sound];
    
    [self.view addSubview:_view_sound];
    
    
    _view_virable=[[UIView alloc]initWithFrame:CGRectMake(0, 13*self.view.frame.size.height/32, self.view.frame.size.width, 40)];
    _view_virable.backgroundColor=[UIColor whiteColor];
    UILabel *lbl_virable=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/16, 0, 100, 40)];
    lbl_virable.font=[UIFont systemFontOfSize:17];
    lbl_virable.text=@"振动提示";
    lbl_virable.textColor=[UIColor blackColor];
    [_view_virable addSubview:lbl_virable];
    UISwitch *sw_virable=[[UISwitch alloc]initWithFrame:CGRectMake(3*self.view.frame.size.width/4, self.view.frame.size.width/128, 40, 40)];
    [_view_virable addSubview:sw_virable];
    
    _lbl_attention=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.height/32, 3*self.view.frame.size.height/16, self.view.frame.size.width, 40)];
    _lbl_attention.text=@"在iPhone的“设置”-“通知”中找到“手机OA”进行修改";
    _lbl_attention.font=[UIFont systemFontOfSize:14];
    _lbl_attention.textColor=[UIColor colorWithRed:153.0/255.0f green:153.0/255.0f blue:153.0/255.0f alpha:1];
    
    [self.view addSubview:_lbl_attention];
    
    [self.view addSubview:_view_virable];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
