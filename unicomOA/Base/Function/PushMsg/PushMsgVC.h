//
//  PushMsgVC.h
//  unicomOA
//
//  Created by hnsi-03 on 2017/2/13.
//  Copyright © 2017年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@class PushMsgVC;
@protocol PushMsgVCDelegate <NSObject>

-(void)RefreshBtnBadge;

@end


@interface PushMsgVC : UITableViewController

@property NSInteger i_rownum;

@property (nonatomic,strong) NSMutableArray *arr_PushMsg;

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) id<PushMsgVCDelegate> delegate;

@end
