//
//  UnFinishVc.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/27.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@class UnFinishVc;
@protocol UnFinishVcDelegate <NSObject>

-(void)RefreshUnFinishView;

@end

//待办审批界面
@interface UnFinishVc : UIViewController

@property (nonatomic,strong) NSString *str_processInstID;

@property (nonatomic,strong) NSString *str_activityDefID;

@property (nonatomic,strong) NSString *str_workItemID;

@property (nonatomic,strong) NSString *str_url;

@property (nonatomic,strong) NSString *str_title;



@property (nonatomic,strong) UserInfo *usrInfo;

@property (nonatomic,strong) id<UnFinishVcDelegate> delegate;

//附件传值
@property (nonatomic,strong)  NSMutableArray *arr_attachment_data;


@end
