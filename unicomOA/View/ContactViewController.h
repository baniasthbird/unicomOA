//
//  ContactViewController.h
//  unicomOA
//
//  Created by zr-mac on 16/2/19.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultViewController.h"

@interface ContactViewController : UITableViewController <UISearchBarDelegate,UISearchResultsUpdating>

@property (strong,nonatomic) UISearchController *searchcontroller;

@property (strong,nonatomic) SearchResultViewController *resultViewController;

@end
