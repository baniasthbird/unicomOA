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

@interface NewsManagementViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NIDropDownDelegate,NewsTapDelegate>
{
    NIDropDown *dropDown;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *btn_Select;

@property (nonatomic,strong) UITextField *txt_Search;

-(IBAction)selectClicked:(id)sender;

-(void)rel;

@end
