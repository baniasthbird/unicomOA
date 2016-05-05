//
//  IVotingDisplayController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/3/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface IVotingDisplayController : UIViewController

@property (strong,nonatomic) NSString *str_title;

@property (nonatomic,strong) UserInfo *user_Info;

@end
