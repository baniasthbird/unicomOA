//
//  NewsManagementTableViewCell.h
//  unicomOA
//
//  Created by zr-mac on 16/3/10.
//  Copyright © 2016年 zr-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsManagementTableViewCell;

@protocol NewsTapDelegate <NSObject>

@required

/**移除的代理方法*/
-(void)sideslipCellRemoveCell:(NewsManagementTableViewCell*)cell atIndex:(NSInteger)index;

/**点击的代理方法*/
-(void)tapCell:(NewsManagementTableViewCell*)cell atIndex:(NSInteger)index;

@end

@interface NewsManagementTableViewCell : UITableViewCell
/** cell的高度*/
{
    CGFloat _cellHeight;
    
    CGFloat i_TitleX;
    
    CGFloat i_TitleY;
    
    CGFloat i_TitleW;
    
    CGFloat i_TitleH;
    
    CGFloat i_DepartX;
    
    CGFloat i_DepartY;
    
    CGFloat i_DepartW;
    
    CGFloat i_DepartH;
    
    CGFloat i_TimeX;
    
    CGFloat i_TimeY;
    
    CGFloat i_TimeW;
    
    CGFloat i_TimeH;
    
}

@property (nonatomic,retain) UILabel *lbl_Title;

@property (nonatomic,retain) UILabel *lbl_department;

@property (nonatomic,retain) UILabel *lbl_time;

@property (nonatomic,unsafe_unretained) id<NewsTapDelegate> delegate;

@property (nonatomic,assign) NSInteger myTag;

/**快速创建cell的方法*/
+ (instancetype)cellWithTable:(UITableView*)tableView withCellHeight:(CGFloat)cellHeight titleX:(CGFloat)i_TitleX titleY:(CGFloat)i_TitleY titleW:(CGFloat)i_TitleW titleH:(CGFloat)i_TitleH DepartX:(CGFloat)i_DepartX DepartY:(CGFloat)i_DepartY DepartW:(CGFloat)i_DepartW DepartH:(CGFloat)i_DepartH TimeX:(CGFloat)i_TimeX TimeY:(CGFloat)i_TimeY TimeW:(CGFloat)i_TimeW TimeH:(CGFloat)i_TimeH;

@end
