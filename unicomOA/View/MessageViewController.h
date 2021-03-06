//
//  MessageViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAViewController.h"
#import "UserInfo.h"
#import "DataBase.h"
#import "AFNetworking.h"
#import "BaseFunction.h"

@interface MessageViewController : UIViewController

@property (nonatomic,weak) OAViewController *delegate;

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) BaseFunction *baseFunc;

-(void)RefreshFlowNum;

@end
