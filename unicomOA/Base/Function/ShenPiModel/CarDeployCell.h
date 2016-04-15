//
//  CarDeployCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>


//派遣车辆TableViewCell

@interface CarDeployCell : UITableViewCell

/** 快速创建cell的方法 在我的审批中使用**/
+ (instancetype)cellWithTable:(UITableView *)tableView withID:(NSString*)str_ID withBrand:(NSString*)str_Brand withColor:(NSString*)str_Color withDriver:(NSString*)str_driver;

@property (nonatomic,strong) UILabel *lbl_ID;

@property (nonatomic,strong) UILabel *lbl_Brand;

@property (nonatomic,strong) UILabel *lbl_Color;

@property (nonatomic,strong) UILabel *lbl_driver;

@end
