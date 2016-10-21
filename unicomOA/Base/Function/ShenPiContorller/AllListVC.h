//
//  AllListVC.h
//  unicomOA
//
//  Created by hnsi-03 on 2016/10/21.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllListSearchResultVC.h"
#import "UserInfo.h"


@class AllListVC;
@protocol AllListVCDelegate <NSObject>

-(void)sendMemberValue:(NSDictionary*)dic_return indexPath:(NSIndexPath*)indexPath;


@end


@interface AllListVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>

@property (strong,nonatomic) UISearchController *searchcontroller;

@property (strong,nonatomic) AllListSearchResultVC *resultViewController;

@property (nonatomic,strong) UserInfo *userInfo;

@property (nonatomic,strong) NSString *str_title;

@property (nonatomic,strong) id<AllListVCDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end
