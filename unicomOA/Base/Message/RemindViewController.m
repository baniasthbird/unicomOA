//
//  RemindViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/5/3.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "RemindViewController.h"



@implementation RemindViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"工作提醒";
    
    NSDictionary * dict=@{
                          NSForegroundColorAttributeName:   [UIColor whiteColor]};
    
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStyleDone target:self action:@selector(MovePreviousVc:)];
    [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    barButtonItem.tintColor=[UIColor whiteColor];
    [barButtonItem setImage:[UIImage imageNamed:@"returnlogo.png"]];
    self.navigationItem.leftBarButtonItem = barButtonItem;

    
}


-(void)MovePreviousVc:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
