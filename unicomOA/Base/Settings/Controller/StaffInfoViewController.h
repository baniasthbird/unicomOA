//
//  StaffInfoViewController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/3/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface StaffInfoViewController : UITableViewController

@property (nonatomic,strong) NSString *str_cellphone;

@property (nonatomic,strong) UserInfo *userInfo;

@end
