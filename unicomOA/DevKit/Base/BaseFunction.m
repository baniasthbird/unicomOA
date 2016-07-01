//
//  BaseFunction.m
//  unicomOA
//
//  Created by hnsi-03 on 16/7/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "BaseFunction.h"

@implementation BaseFunction

-(NSString*)GetValueFromDic:(NSDictionary*)dic_tmp key:(NSString*)str_key {
    NSObject *obj_tmp=[dic_tmp objectForKey:str_key];
    NSString *str_tmp=@"";
    if (obj_tmp!=[NSNull null]) {
        str_tmp=(NSString*)obj_tmp;
    }
    return str_tmp;
}

-(NSString*)GetValueFromArray:(NSArray*)arr_tmp index:(NSInteger)i_index {
    NSObject *obj_tmp=[arr_tmp objectAtIndex:0];
    NSString *str_tmp=@"";
    if (obj_tmp!=[NSNull null]) {
        str_tmp=(NSString*)obj_tmp;
    }
    
    return str_tmp;
}

//添加菊花等待图标
-(UIActivityIndicatorView*)AddLoop {
    //初始化:
    UIActivityIndicatorView *l_indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    l_indicator.tag = 103;
    
    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    l_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    
    //设置背景色
    l_indicator.backgroundColor = [UIColor blackColor];
    
    //设置背景透明
    l_indicator.alpha = 0.5;
    
    //设置背景为圆角矩形
    l_indicator.layer.cornerRadius = 6;
    l_indicator.layer.masksToBounds = YES;
    //设置显示位置
    [l_indicator setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/ 2.0, [UIScreen mainScreen].bounds.size.height/ 2.0)];
    return l_indicator;
}

@end
