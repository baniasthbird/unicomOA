//
//  SendMeViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/4/17.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"


//抄送页面
@interface SendMeViewController : UIViewController

//抄送事项
@property (nonatomic,strong) NSMutableArray *arr_SendMe;

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) NSMutableArray *arr_SearchResult;

@end
