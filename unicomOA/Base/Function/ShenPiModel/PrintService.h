//
//  PrintService.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrintFiles.h"
#import "ShenPiStatus.h"
//复印业务

@interface PrintService : NSObject

//发起人
@property (nonatomic,strong) NSString *str_name;

//复印标题
@property (nonatomic,strong) NSString *str_title;

//备注信息
@property (nonatomic,strong) NSString *str_remark;

//所在部门
@property (nonatomic,strong) NSString *str_department;

//联系电话
@property (nonatomic,strong) NSString *str_phonenum;

//发起时间
@property (nonatomic,strong) NSString *str_time;

//复印文件
@property (nonatomic,strong) NSArray *arr_PrintFiles;

//部门主任
@property (nonatomic,strong) ShenPiStatus *shenpi_1;

//出版室
@property (nonatomic,strong) ShenPiStatus *shenpi_2;

//申请时间
@property (nonatomic,strong) NSString *str_applicationTime;


@end
