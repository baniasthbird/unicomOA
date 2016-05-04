//
//  CarApplication.h
//  unicomOA
//
//  Created by zr-mac on 16/4/8.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarService.h"
#import "UserInfo.h"

@class CarApplication;
@protocol CarApplicationDelegate <NSObject>

-(void)PassCarValue:(NSString*)str_reason CarObject:(CarService*)carservice;


@end

//预约用车
@interface CarApplication : UIViewController

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,unsafe_unretained) id<CarApplicationDelegate> delegate;

//用车详情
@property (nonatomic,strong) CarService *service;

@end
