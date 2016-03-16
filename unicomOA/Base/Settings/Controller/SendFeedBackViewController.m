//
//  SendFeedBackViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/3/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SendFeedBackViewController.h"
#import "SendFeedbackView.h"

@interface SendFeedBackViewController ()<UITextViewDelegate>

@end

@implementation SendFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"意见反馈";
    
    self.view.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
    
    UIButton *btn_send=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn_send setTitle:@"发送" forState:UIControlStateNormal];
    [btn_send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_send addTarget:self action:@selector(SendFeedback:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn_send];
    
    SendFeedbackView *textView=[[SendFeedbackView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/8, self.view.frame.size.width, self.view.frame.size.height/3)];
    textView.myPlaceholder=@"为了第一时间帮助您解决问题，建议您留下联系方式";
    textView.myPlaceholderColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
    textView.delegate=self;
    
    [self.view addSubview:textView];
    /*
    UITextView *txt_Content=[[UITextView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/8, self.view.frame.size.width, self.view.frame.size.height/2)];
    
    txt_Content.font=[UIFont systemFontOfSize:17];
    txt_Content.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    txt_Content.backgroundColor=[UIColor whiteColor];
    txt_Content.hidden=NO;
    txt_Content.delegate=self;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/8, self.view.frame.size.width, 40)];
    label.text=@"为了第一时间帮助您解决问题，建议您留下联系方式";
    label.enabled=NO;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1];
    
    [self.view addSubview:txt_Content];
    [self.view addSubview:label];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SendFeedback:(UIButton*)btn {
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
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
