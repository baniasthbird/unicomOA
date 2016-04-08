//
//  AddPrintFileCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/7.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPrintFileCell : UITableViewCell

/** 快速创建cell的方法 在添加数据时使用**/
+ (instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name withPlaceHolder:(NSString*)str_placeholder;

/** 快速创建cell的方法 在编辑数据时使用**/
+ (instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name withText:(NSString*)str_text;

@property (nonatomic,strong) UITextField *txt_title;

@end
