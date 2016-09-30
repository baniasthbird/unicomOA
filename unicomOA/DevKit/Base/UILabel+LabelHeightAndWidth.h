//
//  UILabel+LaelHeightAndWidth.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/9/29.
//  Copyright © 2016年 zr-mac. All rights reserved.
//



@interface UILabel (LabelHeightAndWidth)

+(CGFloat)getHeightByWidth:(CGFloat)width title:(NSString*)title font:(UIFont*)font;

+(CGFloat)getWidthWithTitle:(NSString*)title font:(UIFont*)font;

@end
