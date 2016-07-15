//
//  FunctionViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface FunctionViewController : UIViewController

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) NSString *str_page;

//审批的数字减1方法
-(void)RefreshNum;

@end
