//
//  NSString+Extension.h
//  unicomOA
//
//  Created by hnsi-03 on 16/8/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
-(CGSize)sizewithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
