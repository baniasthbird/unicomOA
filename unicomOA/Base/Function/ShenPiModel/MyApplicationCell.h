//
//  MyShenPi.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarService.h"
#import "PrintService.h"

//我的申请
@interface MyApplicationCell : UITableViewCell

/** 快速创建cell的方法 在添加预约用车时使用**/
+ (instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString*)str_Title withStatus:(NSString*)str_status isUsingCar:(BOOL)b_Category withTime:(NSString*)str_time;

@property (strong,nonatomic) CarService* car_service;

@property (strong,nonatomic) PrintService *print_service;

@property (nonatomic,strong) NSString *str_status;

@property (nonatomic,strong) NSString *str_time;

@end
