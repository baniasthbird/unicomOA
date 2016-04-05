//
//  ContactViewControllerNew.h
//  unicomOA
//
//  Created by hnsi-03 on 16/4/5.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultViewController.h"

@interface ContactViewControllerNew : UITableViewController<UISearchBarDelegate,UISearchResultsUpdating>

@property (strong,nonatomic) UISearchController *searchcontroller;

@property (strong,nonatomic) SearchResultViewController *resultViewController;

@end
