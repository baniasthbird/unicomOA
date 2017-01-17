//
//  OAViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/2/15.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface OAViewController : UITabBarController

@property (nonatomic,strong) UserInfo *user_Info;

/** 盛放消息内容的数组  */
@property(nonatomic,strong)NSMutableArray *messages;

@end
