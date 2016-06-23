//
//  AlarmCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/6/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlarmCell;

@protocol AlarmCellDelegate <NSObject>

@required
/**点击的代理方法*/
//-(void)tapCell:(AlarmCell*)cell atIndex:(NSInteger)index;
-(void)tapCell:(AlarmCell*)cell atIndex:(NSInteger)index;

@end


@interface AlarmCell : UITableViewCell

+ (instancetype)cellWithTable:(UITableView*)tableView cellHeight:(CGFloat)i_cellHeight switch:(BOOL)b_switch indexPath:(NSIndexPath*)indexPath;

@property (nonatomic, unsafe_unretained)id<AlarmCellDelegate> delegate;

@end
