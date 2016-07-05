//
//  NewsTableViewResultController.h
//  unicomOA
//
//  Created by hnsi-03 on 16/7/4.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

//新闻搜索结果
@interface NewsTableViewResultController : UITableViewController

@property (strong,nonatomic) NSArray *dataArray;

@property (strong,nonatomic) UINavigationController *nav;

@end
