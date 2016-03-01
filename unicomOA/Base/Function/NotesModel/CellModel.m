//
//  CellModel.m
//  TableViewCellMenu
//
//  Created by li_yong on 15/8/20.
//  Copyright (c) 2015年 li_yong. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

/**
 *  @author li_yong
 *
 *  构造函数
 *
 *  @param imageName 图片名
 *  @param labelText 标签内容
 *
 *  @return
 */
- (id)initWithImageName:(NSString *)imageName labelText:(NSString *)labelText
{
    self = [super init];
    if (self)
    {
        self.imageName = imageName;
        self.labelText = labelText;
    }
    return self;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com