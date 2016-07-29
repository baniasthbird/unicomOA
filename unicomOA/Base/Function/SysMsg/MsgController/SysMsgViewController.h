//
//  SysMsgViewController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/7/29.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import "LXSegmentController.h"
#import "UserInfo.h"
#import "BaseFunction.h"

@interface SysMsgViewController : LXSegmentController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UISearchBar *searchBar;

@property BOOL b_isSysMsg;

@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) BaseFunction *baseFunc;

@end
