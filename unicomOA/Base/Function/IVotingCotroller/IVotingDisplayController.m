//
//  IVotingDisplayController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "IVotingDisplayController.h"
#import "RadioBox.h"
#import "RadioGroup.h"
#import "IVotingResultViewController.h"

@implementation IVotingDisplayController

-(void)viewDidLoad {
    
    self.title=@"投票详情";
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
    lbl_condition.text=@"投票进行中";
    
#pragma mark 时间
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
    
    [self buildView];
    [self buildRadio];
    [self buildButton];
}

//日后根据要求，单选或多选，多少人参与投票，投票题目与选项
-(void)buildView {
    UILabel *lbl_label1;
    if (iPhone6_plus || iPhone6)
    {
        lbl_label1=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.08, self.view.frame.size.height*0.31, self.view.frame.size.width*0.2, self.view.frame.size.height*0.05)];
    }
    else if (iPhone4_4s || iPhone5_5s) {
        lbl_label1=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.08, self.view.frame.size.height*0.31, self.view.frame.size.width*0.2, self.view.frame.size.height*0.05)];
    }
    lbl_label1.text=@"单项投票:";
    lbl_label1.textColor=[UIColor blackColor];
    lbl_label1.font=[UIFont boldSystemFontOfSize:14];
    lbl_label1.textAlignment=NSTextAlignmentLeft;
   
    UILabel *lbl_label2;
    if (iPhone6 || iPhone6_plus) {
       lbl_label2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0.31, self.view.frame.size.width*0.2, self.view.frame.size.height*0.05)];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        lbl_label2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.3, self.view.frame.size.height*0.31, self.view.frame.size.width*0.2, self.view.frame.size.height*0.05)];
    }
    
    lbl_label2.text=@"目前共有";
    lbl_label2.textColor=[UIColor blackColor];
    lbl_label2.font=[UIFont systemFontOfSize:14];
    lbl_label2.textAlignment=NSTextAlignmentLeft;
    
    UILabel *lbl_label3;
    if (iPhone6_plus || iPhone6) {
       lbl_label3=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.45, self.view.frame.size.height*0.31, self.view.frame.size.width*0.05, self.view.frame.size.height*0.05)];
    }
    else if (iPhone4_4s || iPhone5_5s) {
        lbl_label3=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.31, self.view.frame.size.width*0.08, self.view.frame.size.height*0.05)];
    }
    lbl_label3.text=@"30";
    lbl_label3.textColor=[UIColor blackColor];
    lbl_label3.font=[UIFont boldSystemFontOfSize:14];
    lbl_label3.textAlignment=NSTextAlignmentLeft;
    
    UILabel *lbl_label4;
    if (iPhone6_plus || iPhone6) {
        lbl_label4=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.31, self.view.frame.size.width*0.35, self.view.frame.size.height*0.05)];
    }
    else if (iPhone4_4s || iPhone5_5s) {
        lbl_label4=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.6, self.view.frame.size.height*0.31, self.view.frame.size.width*0.35, self.view.frame.size.height*0.05)];
    }
    
    lbl_label4.text=@"人参与投票";
    lbl_label4.textColor=[UIColor blackColor];
    lbl_label4.font=[UIFont systemFontOfSize:14];
    lbl_label4.textAlignment=NSTextAlignmentLeft;
    
    [self.view addSubview:lbl_label1];
    [self.view addSubview:lbl_label2];
    [self.view addSubview:lbl_label3];
    [self.view addSubview:lbl_label4];
    
}

-(void)buildRadio {
    
    RadioBox *radio1=[[RadioBox alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.9, self.view.frame.size.height*0.05)];
    RadioBox *radio2=[[RadioBox alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.05, self.view.frame.size.width*0.9, self.view.frame.size.height*0.05)];
    RadioBox *radio3=[[RadioBox alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.1, self.view.frame.size.width*0.9, self.view.frame.size.height*0.05)];
    
    radio1.text=@"在公司举办的party上找机会婉转谈起";
    radio2.text=@"面对面交流";
    radio3.text=@"电子邮件或电话";
    
    radio1.value=0;
    radio2.value=1;
    radio3.value=2;
    
    
    NSArray *controls=[NSArray arrayWithObjects:radio1,radio2,radio3, nil];
    
    RadioGroup *radioGroup1=[[RadioGroup alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.08, self.view.frame.size.height*0.4, self.view.frame.size.width*0.9, self.view.frame.size.height*0.15) WithControl:controls];
    [radioGroup1 addSubview:radio1];
    [radioGroup1 addSubview:radio2];
    [radioGroup1 addSubview:radio3];
    
    radioGroup1.backgroundColor=[UIColor clearColor];
    radioGroup1.textFont=[UIFont systemFontOfSize:14];
    radioGroup1.selectValue=1;
    
    [self.view addSubview:radioGroup1];
    
}

-(void)buildButton {
    UIButton *btn_result;
    if (iPhone6 || iPhone6_plus) {
        btn_result=[[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.85, self.view.frame.size.width*0.495, self.view.frame.size.height*0.08)];
    }
    else if (iPhone5_5s || iPhone4_4s) {
        btn_result=[[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.83, self.view.frame.size.width*0.495, self.view.frame.size.height*0.08)];

    }
    [btn_result setTitle:@"查看投票结果" forState:UIControlStateNormal];
    [btn_result setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_result.layer setBorderWidth:1.0];
    btn_result.titleLabel.font=[UIFont systemFontOfSize:22];
    btn_result.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn_result addTarget:self action:@selector(VoteResult:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn_vote;
    if (iPhone6 || iPhone6_plus) {
        btn_vote=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.85, self.view.frame.size.width*0.495, self.view.frame.size.height*0.08)];
    }
    else if (iPhone4_4s || iPhone5_5s) {
        btn_vote=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5, self.view.frame.size.height*0.83, self.view.frame.size.width*0.495, self.view.frame.size.height*0.08)];
    }
    
    [btn_vote setTitle:@"投票" forState:UIControlStateNormal];
    [btn_vote setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_vote.layer setBorderWidth:1.0];
    btn_vote.titleLabel.font=[UIFont systemFontOfSize:22];
    btn_vote.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn_vote addTarget:self action:@selector(Vote:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn_result];
    [self.view addSubview:btn_vote];
}


-(void)VoteResult:(UIButton*)sender {
    IVotingResultViewController *viewController=[[IVotingResultViewController alloc]init];
    viewController.str_title=_str_title;
    viewController.str_condition=@"投票进行中";
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)Vote:(UIButton*)sender {
    //数值没有传，回去再看
    NSString *str_tmp=@"";
    for (UIView *view in self.view.subviews) {
        if ([view isMemberOfClass:[RadioGroup class]]) {
            RadioGroup *tmp_radio=(RadioGroup*)view;
            for (UIView *sub_view in tmp_radio.subviews) {
                if ([sub_view isMemberOfClass:[RadioBox class]]) {
                    RadioBox *tmp_box=(RadioBox*)sub_view;
                    if (tmp_box.on==YES) {
                        str_tmp=tmp_box.text;
                    }
                }
            }
        }
    }
    
    NSString *alert_title=@"提示";
    NSString *alert_message=[NSString stringWithFormat:@"%@%@",@"您已投票成功，您投给了:",str_tmp];
    
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:alert_title message:alert_message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮");
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
