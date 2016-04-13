//
//  CarApplicationDetail.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarService.h"

@interface CarApplicationDetail : UIViewController

//用车详情
@property (nonatomic,strong) CarService *service;

//审批状态
@property (nonatomic,strong) NSString *str_status;

//审批时间
@property (nonatomic,strong) NSString *str_time;
//tableView
@property (nonatomic,strong) UITableView *tableview;


@end
