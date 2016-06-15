//
//  MyShenPiCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarService.h"
#import "PrintService.h"
//我的审批中的tableviewcell

@interface MyShenPiCell : UITableViewCell

@property (nonatomic,strong) NSString *str_category;

/** 快速创建cell的方法 在我的审批中使用**/
+ (instancetype)cellWithTable:(UITableView *)tableView withImage:(NSString*)str_Image withCellHeight:(CGFloat)cellHeight withName:(NSString*)str_Name withCategroy:(NSString*)str_Categroy withStatus:(NSString*)str_status withTitle:(NSString*)str_Title withTime:(NSString*)str_time atIndex:(NSIndexPath*)indexPath ;

@property (nonatomic,strong) CarService *car_service;

@property (nonatomic,strong) PrintService *print_service;

@property (nonatomic,strong) UILabel *lbl_status;


@property (nonatomic,strong) NSDictionary *dic_task;

@end
