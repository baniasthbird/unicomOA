//
//  TableFilesTitleCell.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/12/5.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableFilesTitleCell : UITableViewCell

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView atIndexPath:(NSIndexPath*)indexPath;


@end
