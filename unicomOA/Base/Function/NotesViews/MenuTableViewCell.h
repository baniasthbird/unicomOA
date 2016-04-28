//
//  MenuTableViewCell.h
//  TableViewCellMenu
//
//  Created by li_yong on 15/7/28.
//  Copyright (c) 2015年 li_yong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenutableViewCellDataSource;
@protocol MenuTableViewCellDelegate;

@interface MenuTableViewCell : UITableViewCell

@property (strong, nonatomic) id <MenutableViewCellDataSource> dataSource;
@property (strong, nonatomic) id <MenuTableViewCellDelegate> delegate;

//是否已经打开
@property (assign, nonatomic) BOOL isOpenMenu;

//头像
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;

//cell的位置标签
@property (strong, nonatomic) IBOutlet UILabel *indexPathLabel;

//下拉菜单按钮
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;

//下拉菜单视图
@property (weak, nonatomic) IBOutlet UIView *menuView;

+(instancetype)cellWithTable:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath;

/**
 *  @author li_yong
 *
 *  自定义Cell中控件属性
 */
- (void)customCell;

/**
 *  构建下拉视图
 */
- (void)buildMenuView;

@end

@protocol MenutableViewCellDataSource <NSObject>

@required
- (NSMutableArray *)dataSourceForMenuItem;

@end

@protocol MenuTableViewCellDelegate <NSObject>

@optional
- (void)didOpenMenuAtCell:(MenuTableViewCell *)menuCell withMoreButton:(UIButton *)moreButton;

- (void)menuTableViewCell:(MenuTableViewCell *)menuTableViewCell didSeletedMentItemAtIndex:(NSInteger)menuItemIndex;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com