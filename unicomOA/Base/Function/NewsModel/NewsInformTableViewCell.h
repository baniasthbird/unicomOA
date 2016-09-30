//
//  NewsInformTableViewCell.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/9/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsTapDelegate <NSObject>

/**点击的代理方法*/
-(void)tapCell:(UITableViewCell*)cell atIndex:(NSInteger)index;

@end

@interface NewsInformTableViewCell : UITableViewCell

@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) NSString *str_department;

@property (nonatomic,strong) NSString *str_time;

@property (nonatomic,strong) NSString *str_operator;

@property (nonatomic,unsafe_unretained) id<NewsTapDelegate> delegate;

@property (nonatomic,assign) NSInteger myTag;

/**快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView*)tableView withCellHeight:(CGFloat)cellHeight withTitleHeight:(CGFloat)h_title withButtonHeight:(CGFloat)h_depart withTitle:(NSMutableAttributedString*)str_title withCategory:(NSString*)str_category withDepart:(NSString*)str_depart withDate:(NSString*)str_date titleFont:(CGFloat)i_titleFont otherFont:(CGFloat)i_otherFont;

@end
