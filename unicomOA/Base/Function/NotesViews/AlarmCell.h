//
//  AlarmCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/6/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmCell : UITableViewCell

+ (instancetype)cellWithTable:(UITableView*)tableView cellHeight:(CGFloat)i_cellHeight switch:(BOOL)b_switch indexPath:(NSIndexPath*)indexPath;

@end
