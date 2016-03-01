//
//  MenuItemModel.m
//  TableViewCellMenu
//
//  Created by 李勇 on 15/7/31.
//  Copyright (c) 2015年 li_yong. All rights reserved.
//

#import "MenuItemModel.h"

@interface MenuItemModel()

@end

@implementation MenuItemModel

/**
 *  构造函数
 *
 *  @param normalImageName      正常状态下图片
 *  @param highLightedImageName 高亮状态下图片
 *  @param itemText             菜单item的标题
 *
 *  @return
 */
- (id)initWithNormalImageName:(NSString *)normalImageName
     withHighLightedImageName:(NSString *)highLightedImageName
                 withItemText:(NSString *)itemText
{
    self = [super init];
    if (self)
    {
        self.normalImageName = normalImageName;
        self.highLightedImageName = highLightedImageName;
        self.itemText = itemText;
    }
    return self;
}

/**
 *  构造函数
 *
 *  @param normalImageName      正常状态下图片
 *  @param highLightedImageName 高亮状态下图片
 *  @param selectedImageName    选中状态下图片
 *  @param itemText             菜单item的标题
 *
 *  @return
 */
- (id)initWithNormalImageName:(NSString *)normalImageName
     withHighLightedImageName:(NSString *)highLightedImageName
        withSelectedImageName:(NSString *)selectedImageName
                 withItemText:(NSString *)itemText;
{
    self = [self initWithNormalImageName:normalImageName
                withHighLightedImageName:highLightedImageName
                            withItemText:itemText];
    if (self)
    {
        self.selectedImageName = selectedImageName;
    }
    return self;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com