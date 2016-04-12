//
//  CarService.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/12.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//预约用车业务

@interface CarService : NSObject

//申请人
@property (nonatomic,strong) NSString *str_name;

//所在部门
@property (nonatomic,strong) NSString *str_department;

//联系电话
@property (nonatomic,strong) NSString *str_phonenum;

//用车类别
@property (nonatomic,strong) NSString *str_categroy;

//用车人数
@property int i_usernum;

//使用人
@property (nonatomic,strong) NSString *str_usrname;

//用车时间
@property (nonatomic,strong) NSString *str_usingtime;

//返回时间
@property (nonatomic,strong) NSString *str_returntime;

//目的地
@property (nonatomic,strong) NSString *str_destination;

//用车事由
@property (nonatomic,strong) NSString *str_reason;

//备注信息
@property (nonatomic,strong) NSString *str_remark;

@end
