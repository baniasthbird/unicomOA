//
//  NotesTableVIewCell.h
//  unicomOA
//
//  Created by zr-mac on 16/3/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotesTableVIewCell;

@protocol NotesTableSlidCellDelegate <NSObject>

@required
/**移除的代理方法*/
-(void)sideslipCellRemoveCell:(NotesTableVIewCell*)cell atIndex:(NSInteger)index;
/**点击的代理方法*/
-(void)tapCell:(NotesTableVIewCell*)cell atIndex:(NSInteger)index;

@end

@interface NotesTableVIewCell : UITableViewCell
/** cell的高度*/
{
    CGFloat _cellHeight;
    
}

@property (nonatomic,retain) UILabel *lbl_arrangement;

@property (nonatomic,retain) UILabel *lbl_content;

@property (nonatomic,retain) UILabel *lbl_time;

@property (nonatomic,retain) UILabel *lbl_time2;

@property (nonatomic,strong) UIView *view_bg;

@property (nonatomic, unsafe_unretained) id<NotesTableSlidCellDelegate> delegate;

/**标记*/
@property (nonatomic, assign) NSInteger myTag;

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withCellHeight:(CGFloat) cellHeight atIndexPath:(NSIndexPath*)indexPath;

@end
