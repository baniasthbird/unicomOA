//
//  PrintApplicationTitleCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//复印标题 textField

@interface PrintApplicationTitleCell : UITableViewCell


/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name withPlaceHolder:(NSString*)str_Placeholder atIndexPath:(NSIndexPath*)indexPath keyboardType:(UIKeyboardType)type;

@property (nonatomic,strong) UITextField *txt_title;

@end
