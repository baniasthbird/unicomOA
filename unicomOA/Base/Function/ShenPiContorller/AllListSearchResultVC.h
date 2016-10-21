//
//  AllListSearchResultVC.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/10/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AllListSearchResultVC : UITableViewController

@property (strong,nonatomic) NSArray *dataArray;

@property (strong,nonatomic) UINavigationController *nav;

@property (strong,nonatomic) NSString *str_key;

@property (nonatomic,strong) UIViewController *vc_parent;

@property (nonatomic,strong) NSIndexPath *indexPath_parent;

@end
