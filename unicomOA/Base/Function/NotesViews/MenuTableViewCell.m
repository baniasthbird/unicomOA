//
//  MenuTableViewCell.m
//  TableViewCellMenu
//
//  Created by li_yong on 15/7/28.
//  Copyright (c) 2015年 li_yong. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "UIButton+Extra.h"
#import "LYButton.h"
#import "UIViewExt.h"

#define MENU_ITEM_SPACE     5
#define MENU_ITEM_WHIDE     ([[UIScreen mainScreen] bounds].size.width - 6*5)/5
#define MENU_ITEM_HEIGHT    50

#define MAX_ITEM_COUNT      5

@interface MenuTableViewCell()

//下拉菜单数据源
@property (nonatomic, strong) NSMutableArray *menuItemDataSourceArray;

//是否已经绘制了下拉菜单
@property (nonatomic, assign) BOOL isAlreadyDrawMenu;

@end

@implementation MenuTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    [self customCell];
}

/**
 *  @author li_yong
 *
 *  自定义Cell中控件属性
 */
- (void)customCell
{
    //最重要的一句代码！没有的话单元格直接全部显示下拉菜单了！两句随便选一句
    self.layer.masksToBounds = YES;
//    self.clipsToBounds = YES;
    //设置cell自身属性(必须设置，不然收起下拉菜单动画可能有问题)
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置头像圆角
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2;
    self.headImageView.layer.masksToBounds = YES;
    
    //绑定事件
    [self.moreBtn addTarget:self
                     action:@selector(moreClick:)
           forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  构建下拉视图
 */
- (void)buildMenuView
{
    //避免多次绘制下拉菜单
    if (self.isAlreadyDrawMenu)
    {
        return;
    }
    
    //构建菜单
    self.menuItemDataSourceArray = [NSMutableArray arrayWithCapacity:0];
    if ([self.dataSource respondsToSelector:@selector(dataSourceForMenuItem)])
    {
        self.menuItemDataSourceArray = [self.dataSource dataSourceForMenuItem];
        
        __weak MenuTableViewCell *weakSelf = self;
        [self.menuItemDataSourceArray enumerateObjectsUsingBlock:^(MenuItemModel *menuItemModel, NSUInteger idx, BOOL *stop) {
            
            if (idx >= MAX_ITEM_COUNT)
            {
                //下拉菜单的item超过最大数(MAX_ITEM_COUNT:5)的时候就不绘制,可以自定义下拉菜单个数
                return ;
            }
            
            CGRect menuItemRect = CGRectMake(MENU_ITEM_SPACE + (MENU_ITEM_SPACE + MENU_ITEM_WHIDE) * idx, 0, MENU_ITEM_WHIDE, MENU_ITEM_HEIGHT);
            LYButton *menuItemButton = [[LYButton alloc] initWithFrame:menuItemRect model:menuItemModel];
            menuItemButton.tag = idx;
            [menuItemButton addTarget:self
                               action:@selector(menuItemClick:)
                     forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.menuView addSubview:menuItemButton];
        }];
    }
    
    self.isAlreadyDrawMenu = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    //设置单元格菜单是否被打开，其实可以直接使用isSelected代替。
    self.isOpenMenu = selected;
}

/**
 *  下拉菜单按钮
 *
 *  @param sender 下拉菜单按钮
 */
- (void)moreClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didOpenMenuAtCell:withMoreButton:)])
    {
        [self.delegate didOpenMenuAtCell:self withMoreButton:sender];
    }
}

/**
 *  下拉菜单item点击事件
 *
 *  @param sender 下拉菜单item
 */
- (void)menuItemClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(menuTableViewCell:didSeletedMentItemAtIndex:)])
    {
        [self.delegate menuTableViewCell:self didSeletedMentItemAtIndex:sender.tag];
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com