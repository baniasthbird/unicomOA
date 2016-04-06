//
//  PrintApplicationDetailCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//备注信息 textView

@interface PrintApplicationDetailCell : UITableViewCell

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name;

@end
