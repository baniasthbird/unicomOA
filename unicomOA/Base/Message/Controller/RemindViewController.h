//
//  LYMainViewController.h
//  Page Demo
//
//  Created by 刘勇航 on 16/3/12.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface RemindViewController : UIViewController

@property (nonatomic,strong) UserInfo *userInfo;

//工作流程
@property NSInteger i_index1;

//公文传阅
@property NSInteger i_index2;

//消息提醒
@property NSInteger i_index3;

@end
