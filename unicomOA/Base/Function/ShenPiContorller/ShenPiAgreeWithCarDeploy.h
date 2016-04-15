//
//  ShenPiAgreeWithCarDeploy.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"
#import "ShenPiStatus.h"
#import "UserInfo.h"

//预约车辆派遣
@class ShenPiAgreeWithCarDeploy;
@protocol ShenPiAgreeWithCarDeployDelegate <NSObject>

-(void)SendAgreeStatus:(ShenPiStatus*)tmp_status CarModel:(CarModel*)model;

@end


@interface ShenPiAgreeWithCarDeploy : UIViewController

@property (nonatomic,strong) id<ShenPiAgreeWithCarDeployDelegate> delegate;

@property (nonatomic,strong) UserInfo *user_info;

@end
