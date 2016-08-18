//
//  UIBarButtonItem+Weather.h
//  unicomOA
//
//  Created by hnsi-03 on 16/8/18.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Weather)
+(UIBarButtonItem *)ItemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;
+(UIBarButtonItem *)ItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
