//
//  PrintApplicationFileCell.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/6.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//复印文件  有文件的tableviewcell

@class PrintApplicationFileCell;

@protocol PrintApplicationFileCellDelegate <NSObject>

@required
/**移除的代理方法*/
-(void)sideslipCellRemoveCell:(PrintApplicationFileCell*)cell atIndex:(NSInteger)index;
/**点击的代理方法*/
-(void)tapCell:(PrintApplicationFileCell*)cell atIndex:(NSInteger)index;

@end


@interface PrintApplicationFileCell : UITableViewCell

@property (nonatomic,unsafe_unretained) id<PrintApplicationFileCellDelegate> delegate;

/**标记*/
@property (nonatomic, assign) NSInteger myTag;

/** 快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView *)tableView withTitle:(NSString*)str_Title withPages:(int)str_Pages withCopies:(int)str_copies withCellHeight:(CGFloat)cellHeight;


@end
