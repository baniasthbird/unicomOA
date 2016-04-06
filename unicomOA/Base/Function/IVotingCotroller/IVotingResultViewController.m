//
//  IVotingResultViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "IVotingResultViewController.h"
#import "JXBarChartView.h"

@implementation IVotingResultViewController


-(void)viewDidLoad {
    self.title=@"投票结果";
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
#pragma mark 标题
    UILabel *lbl_Title;
    if (iPhone6 || iPhone6_plus)
    {
        lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.08, self.view.frame.size.width, self.view.frame.size.height*0.15)];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.1, self.view.frame.size.width, self.view.frame.size.height*0.15)];
    }
    lbl_Title.textAlignment=NSTextAlignmentCenter;
    lbl_Title.font=[UIFont systemFontOfSize:24];
    lbl_Title.textColor=[UIColor blackColor];
    lbl_Title.text=_str_title;
    lbl_Title.numberOfLines=0;
    
    
#pragma mark 状态
    UILabel *lbl_condition=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.03, self.view.frame.size.height*0.25, self.view.frame.size.width*0.4, self.view.frame.size.height*0.05)];
    lbl_condition.textAlignment=NSTextAlignmentLeft;
    lbl_condition.font=[UIFont systemFontOfSize:14];
    lbl_condition.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    lbl_condition.text=_str_condition;
    
    UILabel *lbl_time;
    if (iPhone6_plus || iPhone6) {
        lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.45, self.view.frame.size.height*0.25, self.view.frame.size.width*0.55, self.view.frame.size.height*0.05)];
    }
    else if (iPhone4_4s || iPhone5_5s) {
        lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.35, self.view.frame.size.height*0.25, self.view.frame.size.width*0.65, self.view.frame.size.height*0.05)];
    }
    
    lbl_time.textAlignment=NSTextAlignmentLeft;
    lbl_time.font=[UIFont systemFontOfSize:14];
    lbl_time.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
#pragma mark 时间为变量，日后修改
    lbl_time.text=@"结束时间：2016-01-26 16：45";
    
    UIView *view_line=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.31, self.view.frame.size.width, 1)];
    view_line.backgroundColor=[UIColor blackColor];
    
    
    [self.view addSubview:lbl_Title];
    [self.view addSubview:lbl_condition];
    [self.view addSubview:lbl_time];
    [self.view addSubview:view_line];
    
    [self buildChart];
}

-(void)buildChart {
    NSMutableArray *textIndicators = [[NSMutableArray alloc] initWithObjects:@"在公司举办的party上找机会婉转谈起", @"面对面交流", @"电子邮件或电话",  nil];
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@12, @31, @13, nil];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    JXBarChartView *barChartView = [[JXBarChartView alloc] initWithFrame:frame
                                                              startPoint:CGPointMake(20, self.view.frame.size.height*0.38)
                                                                  values:values maxValue:50
                                                          textIndicators:textIndicators
                                                               textColor:[UIColor blackColor]
                                                               barHeight:30
                                                             barMaxWidth:200
                                                                gradient:nil];
    [self.view addSubview:barChartView];
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end