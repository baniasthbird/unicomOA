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

@protocol ClearRedDotDelegate

-(void)ClearNewsRedDot;

@end

@interface NewsManagementViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate,NewsTapDelegate,FocusNewsPassDelegate>
{
    NIDropDown *dropDown;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *btn_Select;

@property (nonatomic,strong) UITextField *txt_Search;

@property (nonatomic,strong) id<ClearRedDotDelegate> delegate;

@property  BOOL b_hasnews;

-(IBAction)selectClicked:(id)sender;

-(void)rel;

@end
