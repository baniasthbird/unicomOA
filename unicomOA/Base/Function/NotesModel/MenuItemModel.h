//
//  MenuItemModel.h
//  TableViewCellMenu
//
//  Created by 李勇 on 15/7/31.
//  Copyright (c) 2015年 li_yong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItemModel : NSObject

//正常状态下图片
@property (nonatomic, strong) NSString *normalImageName;
//高亮状态下图片
@property (nonatomic, strong) NSString *highLightedImageName;
//选中状态下图片
@property (nonatomic, strong) NSString *selectedImageName;
//菜单item的标题
@property (nonatomic, strong) NSString *itemText;

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
                 withItemText:(NSString *)itemText;

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

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com