//
//  UnFinishVc.h
//  unicomOA
//
//  Created by hnsi-03 on 16/5/27.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@property (nonatomic,strong) id<UnFinishVcDelegate> delegate;

@end
