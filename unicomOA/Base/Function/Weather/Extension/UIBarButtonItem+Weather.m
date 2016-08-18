//
//  UIBarButtonItem+Weather.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/18.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "UIBarButtonItem+Weather.h"

@implementation UIBarButtonItem (Weather)

//快速创建一个显示图片的item
+(UIBarButtonItem *)ItemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero,button.currentBackgroundImage.size};
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+(UIBarButtonItem *)ItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = (CGRect){CGPointZero,40,30};
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

@end
