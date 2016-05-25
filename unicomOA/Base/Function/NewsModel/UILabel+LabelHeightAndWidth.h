//
//  UILabel+LabelHeightAndWidth.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/25.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel_LabelHeightAndWidth : UILabel

+(CGFloat)getHeightByWidth:(CGFloat)width title:(NSString*)title font:(UIFont*)font;

+(CGFloat)getWidthWithTitle:(NSString*)title font:(UIFont*)font;

@end
