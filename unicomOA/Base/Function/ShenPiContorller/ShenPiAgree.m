//
//  ShenPiAgree.m
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "ShenPiAgree.h"

@interface ShenPiAgree()<UITextViewDelegate>

@property (nonatomic,strong) UILabel *lbl_tip;

@end

@implementation ShenPiAgree

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    
    self.title=@"审批意见—同意";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(NewVc:)];
    [barButtonItem2 setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = barButtonItem2;
    
    UITextView *txt_View=[[UITextView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.15, self.view.frame.size.width, self.view.frame.size.height*0.45)];
    txt_View.backgroundColor=[UIColor whiteColor];
    txt_View.delegate=self;
    
    _lbl_tip=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.15, 200, 20)];
    _lbl_tip.text=@"填写意见说明（非必填）";
    _lbl_tip.textColor=[UIColor colorWithRed:116/255.0f green:116/255.0f blue:116/255.0f alpha:1];
    _lbl_tip.textAlignment=NSTextAlignmentLeft;
    _lbl_tip.font=[UIFont systemFontOfSize:13];
    _lbl_tip.backgroundColor=[UIColor clearColor];
    _lbl_tip.enabled=NO;
    
    
    [self.view addSubview:txt_View];
    [self.view addSubview:_lbl_tip];
    

}

-(void)MovePreviousVc:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)NewVc:(UIButton*)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location<500) {
        return YES;
    } else {
        return NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length==0) {
        [_lbl_tip setHidden:NO];
        _lbl_tip.text=@"填写意见说明（非必填）";
    }
    else {
        _lbl_tip.text=@"";
        [_lbl_tip setHidden:YES];
    }

}

@end