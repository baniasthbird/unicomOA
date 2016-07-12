//
//  LogTriangleView.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "LogTriangleView.h"

@implementation LogTriangleView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //定义画图的path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width*0.05, 0)];
    //从开始位置画一条直线到（160， 150）
    [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width*0.05+40, 0)];
    //在从（160，150）画一条线到（10，150）
    [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width*0.05, 40)];
    
    //关闭path
    [path closePath];
    
    //三角形内填充绿色
    if ([_str_decision isEqualToString:@"1"]) {
        [[UIColor colorWithRed:61/255.0f green:189/255.0f blue:143/255.0f alpha:1] setFill];
    }
    else if ([_str_decision isEqualToString:@"2"]) {
        [[UIColor colorWithRed:247/255.0f green:35/255.0f blue:0/255.0f alpha:1] setFill];
    }
    else if ([_str_decision isEqualToString:@"3"]) {
        [[UIColor colorWithRed:173/255.0f green:173/255.0f blue:173/255.0f alpha:1] setFill];
    }
    else if ([_str_decision isEqualToString:@"0"]) {
        [[UIColor colorWithRed:246/255.0f green:187/255.0f blue:67/255.0f alpha:1] setFill];
    }
    else {
        [[UIColor colorWithRed:137/255.0f green:207/255.0f blue:240/255.0f alpha:1] setFill];
    }
    
    [path fill];
    //三角形的边框为红色
    //[[UIColor redColor] setStroke];
   // [path stroke];
    
}


@end
