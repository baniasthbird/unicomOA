//
//  CarShenPiDetail.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "CarApplicationDetail.h"
#import "UserInfo.h"

@class CarShenPiDetail;
@protocol CarShenPiDetailDelegate <NSObject>

-(void)CarRefreshTableView;

@end

@interface CarShenPiDetail : CarApplicationDetail

@property (nonatomic,strong) UserInfo *user_Info;

@property (nonatomic,strong) id<CarShenPiDetailDelegate> delegate;

@property BOOL b_IsEnabled;

@property BOOL b_IsVisible;

@end
