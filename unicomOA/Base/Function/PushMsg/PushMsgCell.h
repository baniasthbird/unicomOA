//
//  PushMsgCell.h
//  unicomOA
//
//  Created by hnsi-03 on 2017/2/22.
//  Copyright © 2017年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushMsgCell : UITableViewCell

@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) NSString *str_time;

/**快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView*)tableView withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSMutableAttributedString*)str_title  withDate:(NSString*)str_date titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont  atIndexPath:(NSIndexPath*)indexPath;

@end
