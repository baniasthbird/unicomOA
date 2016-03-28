//
//  LYButton.m
//  TableViewCellMenu
//
//  Created by li_yong on 15/8/25.
//  Copyright (c) 2015年 li_yong. All rights reserved.
//

#import "LYButton.h"

@implementation LYButton

- (id)initWithFrame:(CGRect)frame model:(MenuItemModel *)menuItemModel
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self customViewWithModel:menuItemModel];
    }
    
    return self;
}

- (void)customViewWithModel:(MenuItemModel *)menuItemModel
{
    //图片
    UIImageView *buttonImageView = [[UIImageView alloc] init];
    buttonImageView.bounds = CGRectMake(0, 0, 20, 20);
    buttonImageView.center = CGPointMake(self.frame.size.width/2, 20);
    buttonImageView.image = [UIImage imageNamed:menuItemModel.normalImageName];
    [self addSubview:buttonImageView];
    
    //文案
    UILabel *buttonLabel = [[UILabel alloc] init];
    buttonLabel.bounds = CGRectMake(0, 0, self.frame.size.width, 20);
    buttonLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - buttonLabel.frame.size.height/2);
    buttonLabel.text = menuItemModel.itemText;
    buttonLabel.textAlignment = NSTextAlignmentCenter;
    buttonLabel.font = [UIFont systemFontOfSize:15];
    buttonLabel.textColor = [UIColor whiteColor];
    [self addSubview:buttonLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com