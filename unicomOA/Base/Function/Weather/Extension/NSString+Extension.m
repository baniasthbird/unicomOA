//
//  NSString+Extension.m
//  unicomOA
//
//  Created by hnsi-03 on 16/8/16.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(CGSize)sizewithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs=@{NSFontAttributeName: font};
    return  [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
