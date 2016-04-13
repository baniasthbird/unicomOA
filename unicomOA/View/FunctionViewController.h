//
//  FunctionViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface FunctionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UserInfo *userInfo;

@end
