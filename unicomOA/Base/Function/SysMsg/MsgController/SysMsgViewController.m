//
//  SysMsgViewController.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/29.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "SysMsgViewController.h"
#import "AFNetworking.h"
#import "DataBase.h"
#import "LXAlertView.h"

@interface SysMsgViewController()

@property (nonatomic,strong) AFHTTPSessionManager *session;



@end

@implementation SysMsgViewController


-(void)viewDidLoad {
    NSDictionary * dict;
    if (iPad) {
        dict=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:25]};
    }
    else {
        dict =@{
                NSForegroundColorAttributeName:   [UIColor whiteColor]};
    }
    
    self.navigationController.navigationBar.titleTextAttributes=dict;

    
    
}


@end
