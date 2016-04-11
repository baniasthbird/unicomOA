//
//  CarApplication.h
//  unicomOA
//
//  Created by zr-mac on 16/4/8.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarApplication;
@protocol CarApplicationDelegate <NSObject>

-(void)PassCarValue:(NSString*)str_reason;


@end

//预约用车
@interface CarApplication : UIViewController

//发起人
@property NSString *str_name;

//所在部门
@property NSString *str_department;

//联系电话
@property NSString *str_phonenum;

@property (nonatomic,unsafe_unretained) id<CarApplicationDelegate> delegate;

@end
