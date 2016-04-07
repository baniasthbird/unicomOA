//
//  PrintApplicationNoFileCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/7.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//复印文件  没文件时的tableviewcell,支持拖拽删除

@interface PrintApplicationNoFileCell : UITableViewCell

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withName:(NSString*)str_Name;

@end
