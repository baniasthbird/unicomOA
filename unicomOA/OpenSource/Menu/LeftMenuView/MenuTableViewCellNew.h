//
//  MenuTableViewCell.h
//  QQ侧滑菜单Demo
//
//  Created by MCL on 16/7/18.
//  Copyright © 2016年 CHLMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCellNew : UITableViewCell

+ (instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString*)str_Title withCount:(NSString*)str_count withLabel:(NSString*)str_Label atIndexPath:(NSIndexPath *)indexPath;

@end
