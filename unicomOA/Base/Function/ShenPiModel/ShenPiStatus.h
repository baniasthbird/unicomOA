//
//  ShenPiStatus.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/14.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//领导审批状态类

@interface ShenPiStatus : NSObject

//领导头像
@property (nonatomic,strong) NSString *str_Logo;

//领导名称
@property (nonatomic,strong) NSString *str_name;

//审批状态
@property (nonatomic,strong) NSString *str_status;

//签字时间
@property (nonatomic,strong) NSString *str_time;



@end
