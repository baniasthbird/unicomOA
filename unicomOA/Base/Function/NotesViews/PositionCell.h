//
//  PositionCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/17.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionCell : UITableViewCell

+ (instancetype)cellWithTable:(UITableView*)tableView location:(NSString*)str_location_content cellHeight:(CGFloat)i_cellHeight indexPath:(NSIndexPath*)indexPath;

@end
