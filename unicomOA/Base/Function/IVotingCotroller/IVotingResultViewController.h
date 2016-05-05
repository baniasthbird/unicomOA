//
//  IVotingResultViewController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/3/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface IVotingResultViewController : UIViewController

@property (strong,nonatomic) NSString *str_title;

@property (strong,nonatomic) NSString *str_condition;

@property (strong,nonatomic) UserInfo *user_Info;

@end
