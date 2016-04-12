//
//  PrintFileNavCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrintFiles.h"

//申请详情中的复印文件
@interface PrintFileNavCell : UITableViewCell

@property (nonatomic,strong) PrintFiles *file;

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString*)str_Title withPages:(int)str_Pages withCopies:(int)str_copies  atIndexPath:(NSIndexPath*)indexPath;

@end
