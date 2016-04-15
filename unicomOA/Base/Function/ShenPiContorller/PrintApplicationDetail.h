//
//  PrintApplicationDetail.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintService.h"
#import "UserInfo.h"

@interface PrintApplicationDetail : UIViewController

//复印详情
@property (nonatomic,strong) PrintService *service;


//tableView
@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) UserInfo *userInfo;

@end
