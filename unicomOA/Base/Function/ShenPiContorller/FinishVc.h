//
//  FinishVc.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/27.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFunction.h"
//已办审批界面
@interface FinishVc : UIViewController

@property (nonatomic,strong) NSString *str_processInstID;

@property (nonatomic,strong) NSString *str_url;

@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) BaseFunction *baseFunc;

//附件传值
@property (nonatomic,strong)  NSMutableArray *arr_attachment_data;

@end
