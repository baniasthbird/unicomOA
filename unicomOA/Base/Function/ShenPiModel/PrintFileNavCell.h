//
//  PrintFileNavCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintFiles.h"

//tableview类型的cell
@interface PrintFileNavCell : UITableViewCell

@property (nonatomic,strong) NSArray *file_data;

@property (nonatomic,strong) NSArray *file_title;

@property (nonatomic,strong) NSString *str_label;

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString*)str_Title withTileName:(NSString*)str_TitleName withLabel:(NSString*)str_Label atIndexPath:(NSIndexPath*)indexPath;

@end
