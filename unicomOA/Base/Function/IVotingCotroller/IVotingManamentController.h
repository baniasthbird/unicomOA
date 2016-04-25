//
//  IVotingManamentController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/3/30.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "VotingCell.h"

@interface IVotingManamentController : UIViewController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate,VotingTapDelegate> {
    NIDropDown *dropDown;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *btn_Select;

@property (nonatomic,strong) UISearchBar *searchBar;

@end
