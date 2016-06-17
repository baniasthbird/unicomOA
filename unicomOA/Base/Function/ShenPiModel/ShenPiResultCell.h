//
//  ShenPiResultCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//审批结果cell

@interface ShenPiResultCell : UITableViewCell

/** 快速创建cell的方法 在编辑数据时使用**/
+ (instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString*)str_title withName:(NSString*)str_Name withStatus:(NSString*)str_status withTime:(NSString*)str_time ActivityName:(NSString*)str_activename atIndex:(NSIndexPath*)indexPath;

@property (nonatomic,strong) UILabel *lbl_status;

@property (nonatomic,strong) UILabel *lbl_time;

@end
