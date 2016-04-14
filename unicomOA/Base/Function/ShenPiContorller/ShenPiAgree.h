//
//  ShenPiAgree.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShenPiStatus.h"
#import "UserInfo.h"

@class ShenPiAgree;

@protocol ShenPiAgreeDelegate <NSObject>

-(void)SendAgreeStatus:(ShenPiStatus*)tmp_status;

@end

@interface ShenPiAgree : UIViewController

@property (nonatomic,strong) id<ShenPiAgreeDelegate>delegate;

@property (nonatomic,strong) UserInfo *userInfo;

@end
