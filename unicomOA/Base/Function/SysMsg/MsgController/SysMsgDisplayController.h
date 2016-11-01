//
//  SysMsgDisplayController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/8/1.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface SysMsgDisplayController : UIViewController

@property NSInteger i_id;

@property (nonatomic,strong) NSString *str_label;

@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) NSString *str_sendName;

@property (nonatomic,strong) NSString *str_time;

@property (nonatomic,strong) NSString *str_category;

@property (nonatomic,strong) NSString *str_SysMsg_Title;

@property (nonatomic,strong) UserInfo *usrInfo;

@end
