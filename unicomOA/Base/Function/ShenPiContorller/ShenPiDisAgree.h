//
//  ShenPiDisAgree.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShenPiStatus.h"
#import "UserInfo.h"

@class ShenPiDisAgree;

@protocol ShenPiDisAgreeDelegate <NSObject>

-(void)SendDisAgreeStatus:(ShenPiStatus*)tmp_Status;

@end

@interface ShenPiDisAgree : UIViewController


@property (nonatomic,strong) id<ShenPiDisAgreeDelegate> delegate;

@property (nonatomic,strong) UserInfo *userInfo;

@end
