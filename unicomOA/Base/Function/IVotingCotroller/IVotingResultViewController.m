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
    
    CGFloat i_Font1=0;
    CGFloat i_Font2=0;
    CGFloat i_Font3=0;
    
    if (iPhone5_5s || iPhone4_4s) {
        i_Font1=20;
        i_Font2=14;
        i_Font3=20;
    }
    else if (iPhone6) {
        i_Font1=22;
        i_Font2=16;
        i_Font3=22;
    }
    else {
        i_Font1=24;
        i_Font2=18;
        i_Font3=22;
    }
#pragma mark 标题
    UILabel *lbl_Title=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, self.view.frame.size.height*0.05)];
    lbl_Title.textAlignment=NSTextAlignmentCenter;
    lbl_Title.font=[UIFont systemFontOfSize:i_Font1];
    lbl_Title.textColor=[UIColor blackColor];
    lbl_Title.text=_str_title;
    lbl_Title.numberOfLines=0;
    
    UILabel *lbl_time=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.05, self.view.frame.size.width, self.view.frame.size.height*0.05)];
    lbl_time.textAlignment=NSTextAlignmentCenter;
    lbl_time.font=[UIFont systemFontOfSize:i_Font2];
    lbl_time.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    lbl_time.text=@"结束时间：2016-01-26 16：45";
    
    
#pragma mark 状态
    UILabel *lbl_condition=[[UILabel alloc]initWithFrame:CGRectMake(03, self.view.frame.size.height*0.10, self.view.frame.size.width, self.view.frame.size.height*0.05)];
    lbl_condition.textAlignment=NSTextAlignmentCenter;
    lbl_condition.font=[UIFont systemFontOfSize:i_Font2];
    lbl_condition.text=_str_condition;
    if ([_str_condition isEqualToString:@"投票进行中"]) {
        lbl_condition.textColor=[UIColor colorWithRed:154/255.0f green:202/255.0f blue:64/255.0f alpha:1];
    }
    else {
        lbl_condition.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    }
    
    
#pragma mark 时间为变量，日后修改
    
    UIView *view_line=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.15, self.view.frame.size.width, 1)];
    view_line.backgroundColor=[UIColor blackColor];
    
    
    [self.view addSubview:lbl_Title];
    [self.view addSubview:lbl_condition];
    [self.view addSubview:lbl_time];
    [self.view addSubview:view_line];
    
    [self buildView:NO number:30 font:i_Font3];
    [self buildChart];
}


//日后根据要求，单选或多选，多少人参与投票，投票题目与选项
-(void)buildView:(BOOL)is_Multi number:(NSInteger)i_Number font:(CGFloat)i_Font{
    UILabel *lbl_label1=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.18, self.view.frame.size.width, self.view.frame.size.height*0.05)];
    if (is_Multi==NO) {
        lbl_label1.text=[NSString stringWithFormat:@"%@%@%ld%@",@"单项选择：",@"目前共有",(long)i_Number,@"人参与投票"];
    }
    else {
        lbl_label1.text=[NSString stringWithFormat:@"%@%@%ld%@",@"多项选择：",@"目前共有",(long)i_Number,@"人参与投票"];
        
    }
    
    lbl_label1.textColor=[UIColor blackColor];
    lbl_label1.font=[UIFont boldSystemFontOfSize:i_Font];
    lbl_label1.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:lbl_label1];
    
}



-(void)buildChart {
    NSMutableArray *textIndicators = [[NSMutableArray alloc] initWithObjects:@"在公司举办的party上找机会婉转谈起", @"面对面交流", @"电子邮件或电话",  nil];
    NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@12, @31, @13, nil];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    JXBarChartView *barChartView = [[JXBarChartView alloc] initWithFrame:frame
                                                              startPoint:CGPointMake(20, self.view.frame.size.height*0.28)
                                                                  values:values maxValue:50
                                                          textIndicators:textIndicators
                                                               textColor:[UIColor colorWithRed:61/255.0f green:189/255.0f blue:144/255.0f alpha:1]
                                                               barHeight:30
                                                             barMaxWidth:200
                                                                gradient:nil];
    [self.view addSubview:barChartView];
}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
