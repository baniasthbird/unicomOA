//
//  NewsManagementViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/3/9.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "NewsManagementTableViewCell.h"
#import "NewsDisplayViewController.h"
#import "UserInfo.h"
#import "BaseFunction.h"
#import "LXSegmentController.h"
/*
@protocol ClearRedDotDelegate

-(void)ClearNewsRedDot;

@end
*/

@interface NewsManagementViewController : LXSegmentController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate,NewsTapDelegate,FocusNewsPassDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    NIDropDown *dropDown;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *btn_Select;

@property (nonatomic,strong) UISearchBar *searchBar;

//@property (nonatomic,strong) id<ClearRedDotDelegate> delegate;

@property  BOOL b_hasnews;

@property BOOL b_isNews;

@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) BaseFunction *baseFunc;

-(IBAction)selectClicked:(id)sender;

-(void)rel;

@end
