//
//  TableViewTitleCell.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/12/5.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewTitleCell : UITableViewCell

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString*)str_Title atIndexPath:(NSIndexPath*)indexPath;

@end
