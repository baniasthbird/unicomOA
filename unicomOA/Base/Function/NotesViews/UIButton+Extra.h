//
//  UIButton+Extra.h
//  TableViewCellMenu
//
//  Created by 李勇 on 15/8/1.
//  Copyright (c) 2015年 li_yong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItemModel.h"

@interface UIButton (Extra)

/**
 *  下拉菜单按钮的工厂方法
 *
 *  @param menuItemModel 创建下拉菜单按钮的Model
 *  @param buttonFrame   创建下拉菜单按钮的尺寸
 *
 *  @return
 */
+ (UIButton *)creartButtonWith:(MenuItemModel *)menuItemModel withFrame:(CGRect)buttonFrame;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com