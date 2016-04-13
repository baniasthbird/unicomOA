//
//  PrintApplicationDetail.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintService.h"

@interface PrintApplicationDetail : UIViewController

//复印详情
@property (nonatomic,strong) PrintService *service;

//审批状态
@property (nonatomic,strong) NSString *str_status;

//审批时间
@property (nonatomic,strong) NSString *str_time;

//tableView
@property (nonatomic,strong) UITableView *tableview;

@end
