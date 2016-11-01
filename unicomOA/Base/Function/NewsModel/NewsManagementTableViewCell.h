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


/**移除的代理方法*/
-(void)sideslipCellRemoveCell:(NewsManagementTableViewCell*)cell atIndex:(NSInteger)index;

/**点击的代理方法*/
-(void)tapCell:(NewsManagementTableViewCell*)cell atIndex:(NSInteger)index;

@end

@interface NewsManagementTableViewCell : UITableViewCell


@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) NSString *str_department;

@property (nonatomic,strong) NSString *str_time;

@property (nonatomic,strong) NSString *str_operator;

@property (nonatomic,unsafe_unretained) id<NewsTapDelegate> delegate;

@property (nonatomic,assign) NSInteger myTag;

@property (nonatomic,retain) UILabel *lbl_Title;

/**快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView*)tableView withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSMutableAttributedString*)str_title withCategory:(NSString*)str_category withDepart:(NSString*)str_depart titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont canScroll:(BOOL)b_scroll withImage:(NSString*)str_Image;

@end
