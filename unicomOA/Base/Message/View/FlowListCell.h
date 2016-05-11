//
//  FlowListCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/11.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowListCell : UITableViewCell

+ (instancetype)cellWithTable:(UITableView*)tableView dic:(NSDictionary*)dic_flowcontent cellHeight:(CGFloat)i_cellHeight;

@end
