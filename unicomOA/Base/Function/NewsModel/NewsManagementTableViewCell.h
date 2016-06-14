//
//  NewsManagementTableViewCell.h
//  unicomOA
//
//  Created by zr-mac on 16/3/10.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsManagementTableViewCell;

@protocol NewsTapDelegate <NSObject>

@required

/**移除的代理方法*/
-(void)sideslipCellRemoveCell:(NewsManagementTableViewCell*)cell atIndex:(NSInteger)index;

/**点击的代理方法*/
-(void)tapCell:(NewsManagementTableViewCell*)cell atIndex:(NSInteger)index;

@end

@interface NewsManagementTableViewCell : UITableViewCell


@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) NSString *str_department;

@property (nonatomic,unsafe_unretained) id<NewsTapDelegate> delegate;

@property (nonatomic,assign) NSInteger myTag;



/**快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView*)tableView withCellHeight:(CGFloat)cellHeight withCategoryHeight:(CGFloat)h_category withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSString*)str_title withCategory:(NSString*)str_category withDepart:(NSString*)str_depart withTime:(NSString*)str_time canScroll:(BOOL)b_scroll;

@end
