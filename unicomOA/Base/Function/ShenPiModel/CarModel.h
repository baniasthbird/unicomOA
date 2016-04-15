//
//  CarModel.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//车辆型号
@interface CarModel : NSObject

//车牌
@property (nonatomic,strong) NSString *str_ID;

//品牌
@property (nonatomic,strong) NSString *str_brand;

@property (nonatomic,strong) NSString *str_color;

//司机
@property (nonatomic,strong) NSString *str_driver;



@end
