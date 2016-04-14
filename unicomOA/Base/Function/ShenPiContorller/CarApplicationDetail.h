//
//  CarApplicationDetail.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarService.h"
#import "ShenPiStatus.h"
#import "UserInfo.h"

@interface CarApplicationDetail : UIViewController

//用车详情
@property (nonatomic,strong) CarService *service;

//各级领导的审批状态
@property (nonatomic,strong) NSMutableArray *arr_ShenPiStatus;

//tableView
@property  UITableView *tableview;

@property (nonatomic,strong) UserInfo *userInfo;



@end
