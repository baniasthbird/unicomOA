//
//  LocalHeaderView.h
//  unicomOA
//
//  Created by hnsi-03 on 16/8/18.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CitiesGroup,LocalHeaderView;

@protocol LocalHeaderViewDelegate <NSObject>

@optional
-(void)headerViewDidClickedNameView:(LocalHeaderView *)localheaderview;

@end

@interface LocalHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerWithTableView:(UITableView *)tableview;

@property (nonatomic, strong) CitiesGroup *groups;

@property (nonatomic, weak) id<LocalHeaderViewDelegate> delegate;

@end
