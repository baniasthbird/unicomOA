//
//  MyShenPiViewController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/13.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "LXSegmentController.h"
#import "UnFinishVc.h"

@class MyShenPiViewController;
@protocol MyShenPiViewControllerDelegate <NSObject>

-(void)RefreshBadgeNumber;

@end

//我的审批页面
@interface MyShenPiViewController : LXSegmentController<UITableViewDelegate,UITableViewDataSource,UnFinishVcDelegate>

//我的审批事项
@property (nonatomic,strong) NSMutableArray *arr_MyShenPi;

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) NSMutableArray *arr_SearchResult;

@property (nonatomic,strong) id<MyShenPiViewControllerDelegate> delegate;

@property NSInteger i_Class;

@property (nonatomic,strong) NSString *str_title;

@end
